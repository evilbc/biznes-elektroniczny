using Bukimedia.PrestaSharp.Factories;
using dotenv.net;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace ProductInit
{
    internal class Initializer
    {
        private const string SCRAPE_RESULT_PATH = @"..\..\scrape-result";
        private const string DOMAIN_ENV = "DOMAIN";
        private const string SCRAPE_RESULT_FILE = "result.json";
        private const string PRODUCT_NAME = "nazwa";
        private const string PRODUCT_PRICE = "cena";
        private const string PRODUCT_DESCRIPTION = "opis";
        private const string PRODUCT_IMAGES = "images";

        private readonly CategoryFactory categoryFactory;
        private readonly ProductFactory productFactory;
        private readonly StockAvailableFactory stockAvailableFactory;
        private readonly ImageFactory imageFactory;
        private readonly Random random;

        public Initializer()
        {
            IEnumerable<string> envFiles = new string[] { @"..\..\shop\.env" };
            DotEnvOptions envOptions = new DotEnvOptions(envFilePaths: envFiles);
            IDictionary<string, string> envVars = DotEnv.Read(envOptions);


            string baseUrl = $"https://{envVars[DOMAIN_ENV]}/api";
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
            IDictionary<string, JToken> data = JObject.Parse(File.ReadAllText(Path.Combine(SCRAPE_RESULT_PATH, SCRAPE_RESULT_FILE)));
            Parse(data, new long[] { 2 });
        }

        private void Parse(IDictionary<string, JToken> data, long[] parentCategoryIds)
        {
            foreach (KeyValuePair<string, JToken> element in data)
            {
                if (element.Value is JObject)
                {
                    Bukimedia.PrestaSharp.Entities.category category = AddCategory(element, parentCategoryIds);
                    Parse(element.Value as JObject, parentCategoryIds.Prepend(category.id.Value).ToArray());
                }
                else if (element.Value is JArray)
                {
                    ParseProducts(element.Value as JArray, parentCategoryIds);
                }
            }
        }

        private Bukimedia.PrestaSharp.Entities.category AddCategory(KeyValuePair<string, JToken> element, long[] parentCategoryIds)
        {
            Bukimedia.PrestaSharp.Entities.category category = new Bukimedia.PrestaSharp.Entities.category();
            category.active = 1;
            category.name.Add(PrestaString(element.Key));
            category.id_parent = parentCategoryIds[0];
            category.link_rewrite.Add(LinkRewrite(element.Key));
            category.is_root_category = 0;
            category.id_shop_default = 1;
            return categoryFactory.Add(category);
        }

        private void ParseProducts(JArray arr, long[] parentCategoryIds)
        {
            foreach (JObject item in arr)
            {
                Bukimedia.PrestaSharp.Entities.product product = AddProduct(item, parentCategoryIds);
                AddImages(item, product);
                AddStock(product);

            }
        }

        private Bukimedia.PrestaSharp.Entities.product AddProduct(JObject item, long[] parentCategoryIds)
        {
            Bukimedia.PrestaSharp.Entities.product product = new Bukimedia.PrestaSharp.Entities.product();
            product.active = 1;
            product.state = 1;
            product.available_for_order = 1;
            product.id_tax_rules_group = 1;
            product.show_price = 1;
            product.type = "simple";
            product.visibility = "both";
            product.name.Add(PrestaString(item.GetValue(PRODUCT_NAME)));
            product.minimal_quantity = 1;
            product.description.Add(PrestaString(item.GetValue(PRODUCT_DESCRIPTION)));
            decimal cenaBrutto = (decimal) item.GetValue(PRODUCT_PRICE);
            product.price = decimal.Round(cenaBrutto / 1.23M, 6); // tu musi być cena przed podatkiem, podatek musi być zadeklarowany oddzielnie
            product.id_category_default = parentCategoryIds[0];
            product.id_shop_default = 1;
            foreach (long id in parentCategoryIds)
            {
                product.associations.categories.Add(new Bukimedia.PrestaSharp.Entities.AuxEntities.category(id));
            }
            return productFactory.Add(product);

        }

        private void AddImages(JObject item, Bukimedia.PrestaSharp.Entities.product product)
        {
            foreach (string imagePath in item.GetValue(PRODUCT_IMAGES))
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

        }

        private void AddStock(Bukimedia.PrestaSharp.Entities.product product)
        {
            product = productFactory.Get(product.id.Value);
            foreach (var association in product.associations.stock_availables)
            {
                Bukimedia.PrestaSharp.Entities.stock_available stock = stockAvailableFactory.Get(association.id);
                //Część produktów ma być niedostępna.Stany magazynowe proszę ustawić tak, aby liczba dostępnych
                //produktów każdego rodzaju nie przekraczała 10 szt.
                stock.quantity = random.Next(10);
                stock.out_of_stock = 0;
                stockAvailableFactory.Update(stock);
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
