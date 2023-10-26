import os
from pathlib import Path

import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy.http import HtmlResponse
from scrapy.selector import SelectorList
from scrapy.utils.reactor import install_reactor


class EmpikSpider(scrapy.Spider):
	name = 'empik'
	allowed_domains = ['empik.com']
	start_urls = [
		'https://www.empik.com/szukaj/produkt']
	max_pages_per_subcategory = 2
	max_products = 100
	products = 0

	def start_requests(self):
		install_reactor('twisted.internet.asyncioreactor.AsyncioSelectorReactor')
		for url in self.start_urls:
			yield scrapy.Request(url, self.parse)

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
				                     cb_kwargs=dict(category_name=category_name, subcategory_name=title, page=1))

	def parse_subcategory(self, response: HtmlResponse, category_name: str, subcategory_name: str, page: int):
		if self.products >= self.max_products:
			return
		products: SelectorList = response.xpath(
			'//div[@class="search-content js-search-content"]/div[@class="search-list-item  js-reco-product '
			'js-energyclass-product ta-product-tile"]/div/a')
		for product in products:
			if self.products > self.max_products:
				return
			self.products += 1
			link: str = response.urljoin(product.attrib['href'])
			yield scrapy.Request(link, callback=self.parse_product,
			                     cb_kwargs=dict(category_name=category_name, subcategory_name=subcategory_name),
			                     meta={ "playwright": True })
		if page >= self.max_pages_per_subcategory:
			return
		next_page_selector: SelectorList = response.xpath(
			f'//div[@class="pagination"]/span[@class="mobile-hide"]/a[text()="\n{page + 1} "]')
		if len(next_page_selector) > 1:
			self.logger.error(
				f"Found {len(next_page_selector)} possible pages for subcategory {subcategory_name} on page {page}")
		elif len(next_page_selector) == 1:
			yield scrapy.Request(response.urljoin(next_page_selector[0].attrib['href']), self.parse_subcategory,
			                     cb_kwargs=dict(category_name=category_name, subcategory_name=subcategory_name,
			                                    page=page + 1))

	async def parse_product(self, response: HtmlResponse, category_name: str, subcategory_name: str):
		try:
			title: str = response.xpath('//h1[@data-ta="title"]/text()').extract_first()
			cena_str: str = response.xpath(
				'//div[@class="css-tgz8pg-container"]/div[@class="css-im6n0l-priceMainContainer"]/div['
				'@class="css-0"]/span/text()').extract_first()  # w stylu 79,99 zł
			cena_str = (cena_str.split(u'\xa0')[0]).replace(",", ".")  # 79.99
			cena: float = float(cena_str)
			detail_rows: SelectorList = response.xpath(
				'//section[@data-ta-section="DetailedData"]/div/div/table/tbody/tr')

			result_directory: Path = Path(f'../scrape-result/{category_name}/{subcategory_name}/{title}')
			os.makedirs(result_directory, exist_ok=True)
			file: Path = result_directory / 'properties.txt'

			with open(file, "w", encoding="utf-8") as f:
				f.write(f'cena; {cena}\n')
				for row in detail_rows:
					detail_name = row.xpath('th/text()').extract_first()
					detail_value = row.xpath('td/div/text()').extract_first()
					f.write(f'{detail_name}; {detail_value}\n')
		except:
			self.products -= 1


if __name__ == "__main__":
	process: CrawlerProcess = CrawlerProcess(settings={
		"DOWNLOAD_HANDLERS": {
			"http": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
			"https": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
		},
		"TWISTED_REACTOR": "twisted.internet.asyncioreactor.AsyncioSelectorReactor",
		"PLAYWRIGHT_LAUNCH_OPTIONS": {
			"headless": True,
			"timeout": 10 * 1000,  # 10 seconds
		}
	})
	process.crawl(EmpikSpider)
	process.start()
