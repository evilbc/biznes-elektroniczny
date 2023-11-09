using Bukimedia.PrestaSharp.Factories;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace ProductInit
{
    internal class Initializer
    {
        private const string SCRAPE_RESULT_PATH = @".\..\..\..\..\..\..\scrape-result";
        private readonly CategoryFactory categoryFactory;
        private readonly ProductFactory productFactory;
        private readonly StockAvailableFactory stockAvailableFactory;
        private readonly ImageFactory imageFactory;
        private readonly Random random;

        public Initializer()
        {
            // url do zmiany na taki, jaki się podało w .env
            string baseUrl = "https://localhost/api";
            string account = "NM5MUI12C95VICSZW2ELLTFWUYIXM11U";
            string password = "";

            // https://stackoverflow.com/questions/12553277/allowing-untrusted-ssl-certificates-with-httpclient
            // pozwala na używanie niezaufanych certyfikatów SSL
            ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

            categoryFactory = new CategoryFactory(baseUrl, account, password);
            productFactory = new ProductFactory(baseUrl, account, password);
            stockAvailableFactory = new StockAvailableFactory(baseUrl, account, password);
            imageFactory = new ImageFactory(baseUrl, account, password);

            random = new Random();
        }

        public void Run()
        {
            IDictionary<string, JToken> data = JObject.Parse(File.ReadAllText(Path.Combine(SCRAPE_RESULT_PATH, "result.json")));
            Parse(data, new long[] { 2 });
        }

        private void Parse(IDictionary<string, JToken> data, long[] parentCategoryIds)
        {
            foreach (KeyValuePair<string, JToken> element in data)
            {
                if (element.Value is JObject)
                {
                    Bukimedia.PrestaSharp.Entities.category category = new Bukimedia.PrestaSharp.Entities.category();
                    category.active = 1;
                    category.name.Add(PrestaString(element.Key));
                    category.id_parent = parentCategoryIds[0];
                    category.link_rewrite.Add(LinkRewrite(element.Key));
                    category.is_root_category = 0;
                    category.id_shop_default = 1;
                    category = categoryFactory.Add(category);

                    Parse(element.Value as JObject, parentCategoryIds.Prepend(category.id.Value).ToArray());
                }
                else if (element.Value is JArray)
                {
                    foreach (JObject item in (element.Value as JArray))
                    {
                        Bukimedia.PrestaSharp.Entities.product product = new Bukimedia.PrestaSharp.Entities.product();
                        product.active = 1;
                        product.state = 1;
                        product.available_for_order = 1;
                        product.id_tax_rules_group = 1;
                        product.show_price = 1;
                        product.type = "simple";
                        product.visibility = "both";
                        product.name.Add(PrestaString(item.GetValue("nazwa")));
                        product.minimal_quantity = 1;
                        product.description.Add(PrestaString(item.GetValue("opis")));
                        decimal cenaBrutto = (decimal) item.GetValue("cena");
                        product.price = decimal.Round(cenaBrutto / 1.23M, 6); // tu musi być cena przed podatkiem, podatek musi być zadeklarowany oddzielnie
                        product.id_category_default = parentCategoryIds[0];
                        product.id_shop_default = 1;
                        foreach (long id in parentCategoryIds)
                        {
                            product.associations.categories.Add(new Bukimedia.PrestaSharp.Entities.AuxEntities.category(id));
                        }
                        product = productFactory.Add(product);
                        foreach (string imagePath in item.GetValue("images"))
                        {
                            try
                            {
                                imageFactory.AddProductImage(product.id.Value, Path.Combine(SCRAPE_RESULT_PATH, imagePath));
                            }
                            catch (Exception e)
                            {
                                Console.Error.WriteLine(e);
                            }
                        }

                        product = productFactory.Get(product.id.Value);
                        foreach (var association in product.associations.stock_availables)
                        {
                            Bukimedia.PrestaSharp.Entities.stock_available stock = stockAvailableFactory.Get(association.id);
                            //Część produktów ma być niedostępna.Stany magazynowe proszę ustawić tak, aby liczba dostępnych
                            //produktów każdego rodzaju nie przekraczała 10 szt.
                            stock.quantity = random.Next(10);
                            stock.out_of_stock = 1;
                            stockAvailableFactory.Update(stock);
                        }
                    }
                }
            }
        }

        private Bukimedia.PrestaSharp.Entities.AuxEntities.language LinkRewrite(string str)
        {
            return PrestaString(str.ToLower().Replace(' ', '_'));
        }


        private Bukimedia.PrestaSharp.Entities.AuxEntities.language PrestaString(string str)
        {
            return new Bukimedia.PrestaSharp.Entities.AuxEntities.language(1, str);
        }

        private Bukimedia.PrestaSharp.Entities.AuxEntities.language PrestaString(JToken token)
        {
            return PrestaString(token.ToString());
        }


        public static void Main(string[] args)
        {
            Initializer initializer = new Initializer();
            initializer.Run();
        }
    }
}
