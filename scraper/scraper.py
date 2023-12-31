import bisect
import json
from pathlib import Path
from typing import Dict, Any

import scrapy
from bs4 import BeautifulSoup
from itemadapter import ItemAdapter
from scrapy.crawler import CrawlerProcess
from scrapy.http import HtmlResponse
from scrapy.selector import SelectorList, Selector


class ScrapeResult(scrapy.Item):
	nazwa: str = scrapy.Field()
	cena: float = scrapy.Field()
	opis: str = scrapy.Field()
	kategorie: [str] = scrapy.Field()

	image_urls: [str] = scrapy.Field()
	images = scrapy.Field()


def get_nazwa_opis(item: ScrapeResult) -> str:
	return item['nazwa'] + item['opis']


def inner_text(selector: Selector) -> str:
	"""
	wyciąga lepiej sformatowany text z uwzględnieniem tagów html
	np. <div>test1</div><p>test2</p> -> test1\ntest2
	"""
	html: str = selector.get()
	soup: BeautifulSoup = BeautifulSoup(html, 'html.parser')
	return soup.get_text().strip()


class KeezaSpider(scrapy.Spider):
	name: str = 'keeza'
	allowed_domains: [str] = ['sklep.keeza.pl']
	start_urls: [str] = [
		'https://sklep.keeza.pl/']

	def parse(self, response: HtmlResponse):
		# kategorie bez podkategorii
		links: SelectorList = response.xpath(
			'//nav[@class="innermenu row container relative"]/ul[@class="menu-list large standard"]/li['
			'not(@class)]/h3/a')

		# podkategorie bez kolejnego poziomu podkategorii
		links += response.xpath(
			'//nav[@class="innermenu row container relative"]/ul[@class="menu-list large standard"]/li['
			'@class="parent"]/div[@class="submenu level1"]/ul[@class="level1"]/li[@class!="parent"]/h3/a')

		# podkategorie podkategorii - ostatni poziom zagłębienia
		links += response.xpath(
			'//nav[@class="innermenu row container relative"]/ul[@class="menu-list large standard"]/li['
			'@class="parent"]/div[@class="submenu level1"]/ul[@class="level1"]/li[@class="parent"]/div['
			'@class="submenu '
			'level2"]/ul[@class="level2"]/li/h3/a')

		for link in links:
			url: str = response.urljoin(link.attrib['href'])
			yield scrapy.Request(url, self.parse_product_list)

	def parse_product_list(self, response: HtmlResponse):
		links: SelectorList = response.css('.product-inner-wrap').xpath('./a')
		for link in links:
			url: str = response.urljoin(link.attrib['href'])
			yield scrapy.Request(url, self.parse_product)
		current_page: SelectorList = response.xpath(
			'//div[@class="innerbox"]//ul[@class="paginator"]/li[@class="selected"]')
		if len(current_page) > 1:
			self.logger.error(
				f"Found {len(current_page)} possible pages")
		elif len(current_page) == 1:
			next_page: SelectorList = current_page[0].xpath(
				'following-sibling::li[2]/a')  # drugi li po obecnym; pierwszy li nie ma linku i jest tylko dodany w
			# html żeby lepiej wyglądało
			if len(next_page) > 1:
				self.logger.error(
					f"Found {len(next_page)} possible next pages")
			elif len(next_page) == 1:
				url = response.urljoin(next_page[0].attrib['href'])
				yield scrapy.Request(url, self.parse_product_list)

	def parse_product(self, response: HtmlResponse):
		cena_str: str = response.css('.main-price').xpath('./text()').extract_first().strip()  # np. 79,99 zł
		cena_str = (cena_str.split(u'\xa0')[0]).replace(",", ".")  # 79.99
		cena: float = float(cena_str)
		opis_selector: Selector = response.xpath('//div[@itemprop="description"]')[0]
		opis: str = inner_text(opis_selector)
		nazwa: str = response.xpath('//h1[@itemprop="name"]/text()').extract_first().strip()
		kategorie: [str] = []
		kategorie_selectors: SelectorList = response.xpath(
			'//li[@itemprop="itemListElement"]/a[@href!="/"]/span[@itemprop="name"]/text()')
		for kat in kategorie_selectors:
			kategorie.append(kat.extract().strip())
		image_urls: [str] = []
		images_selectors: SelectorList = response.css('.innersmallgallery').xpath('./ul/li/a')
		for img in images_selectors:
			image_urls.append(response.urljoin(img.attrib['href']))
		yield ScrapeResult(
			{ 'cena': cena, 'opis': opis, 'nazwa': nazwa, 'kategorie': kategorie, 'image_urls': image_urls })


class JsonWriterPipeline:

	def open_spider(self, spider: scrapy.Spider):
		self.result_tree: Dict[str, Any] = { }

	def close_spider(self, spider: scrapy.Spider):
		result_directory: Path = Path('../scrape-result')
		result_directory.mkdir(exist_ok=True)  # jeśli folder nie istnieje, to go tworzy, jak istnieje to ok
		file: Path = result_directory / 'result.json'
		with open(file, "w", encoding="utf-8") as f:
			json_data: str = json.dumps(self.result_tree, ensure_ascii=False, indent=4, sort_keys=True)
			f.write(json_data)

	def process_item(self, item: ScrapeResult, spider: scrapy.Spider):
		tree_level: Dict[str, Any] = self.result_tree
		# tworzy strukturę, że na pierwszym poziomie są główne kategorie, potem ich podkategorie i w podkategoriach
		# jest pole products będące listę
		for kategoria in item['kategorie']:
			if kategoria not in tree_level:
				tree_level[kategoria] = { }
			tree_level = tree_level[kategoria]
		if 'products' not in tree_level:
			tree_level['products'] = []
		product_list: [dict] = tree_level['products']
		product_to_insert: dict = ItemAdapter(item).asdict()
		product_to_insert['images'] = ['img/' + img['path'] for img in product_to_insert['images']]
		# dodaje produkty alfabetycznie najpierw według nazwy, potem według opisu
		index = bisect.bisect_left(product_list, get_nazwa_opis(product_to_insert), key=get_nazwa_opis)
		product_list.insert(index, product_to_insert)
		return item


if __name__ == "__main__":
	result_directory: Path = Path('../scrape-result/img')
	result_directory.mkdir(exist_ok=True)

	process: CrawlerProcess = CrawlerProcess(settings={
		'ITEM_PIPELINES': {
			'scrapy.pipelines.images.ImagesPipeline': 1,
			'scraper.JsonWriterPipeline': 2,
		},
		'LOG_LEVEL': 'INFO',
		'IMAGES_STORE': result_directory
	})
	process.crawl(KeezaSpider)
	process.start()
