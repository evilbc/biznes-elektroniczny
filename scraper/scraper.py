import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy.http import HtmlResponse
from scrapy.selector import SelectorList, Selector
from pathlib import Path


class EmpikSpider(scrapy.Spider):
	name = 'empik'
	allowed_domains = ['empik.com']
	start_urls = ['https://www.empik.com/szukaj/produkt']

	def parse(self, response: HtmlResponse):
		categories: SelectorList = response.xpath(
			'//div[@class="filters__group  filters__category js-category-facet ta-category-filters"]/ul/li/a')

		result_directory: Path = Path('../scrape-result')
		result_directory.mkdir(exist_ok=True)  # jeśli folder nie istnieje, to go tworzy
		file: Path = result_directory / 'categories.txt'

		with open(file, "w", encoding="utf-8") as f:
			for category in categories:
				link: str = response.urljoin(category.attrib['href'])
				title: str = category.xpath('text()').extract_first().strip()
				f.write(f"{title}\n")
				yield scrapy.Request(link, self.parse_category, cb_kwargs=dict(category_name=title))

	def parse_category(self, response: HtmlResponse, category_name: str):
		subcategories: SelectorList = response.xpath(
			'//div[@class="filters__group  filters__category js-category-facet ta-category-filters"]/ul/li['
			'@class="filter--active indent1 ta-active-filter ta-category"]/ul/li/a')
		result_directory: Path = Path('../' + 'scrape-result')
		file: Path = result_directory / f'{category_name}.txt'

		with open(file, "w", encoding="utf-8") as f:
			for subcategory in subcategories:
				link: str = response.urljoin(subcategory.attrib['href'])
				title: str = subcategory.xpath('text()').extract_first().strip()
				f.write(f"{title}\n")
				yield scrapy.Request(link, self.parse_subcategory,
				                     cb_kwargs=dict(category_name=category_name, subcategory_name=title))

	def parse_subcategory(self, response: HtmlResponse, category_name: str, subcategory_name: str):
		pass
# products: SelectorList = response.xpath('//div[@class="search-content js-search-content"]/div')
# result_directory: Path = Path(f'../scrape-result/{category_name}/{subcategory_name}')
# result_directory.mkdir(exist_ok=True)


if __name__ == "__main__":
	process: CrawlerProcess = CrawlerProcess()
	process.crawl(EmpikSpider)
	process.start()
