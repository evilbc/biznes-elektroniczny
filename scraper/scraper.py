import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy.http import HtmlResponse
from scrapy.selector import SelectorList, Selector
from pathlib import Path


class EmpikSpider(scrapy.Spider):
	name = 'empik'
	allowed_domains = ['empik.com']
	start_urls = ['https://www.empik.com/']

	def parse(self, response: HtmlResponse):
		categories: SelectorList = response.xpath(
			'//nav[@class="empikNav"]/div[@class="empikNav__menu-desktop"]//ul[@class="main-nav__categories '
			'nav-categories"]/li['
			'@class!="nav-categories__separator"]/a[@title!="Empikfoto.pl" and @title!="Empikbilety.pl"]')

		result_directory: Path = Path('../' + 'scrape-result')
		result_directory.mkdir(exist_ok=True)  # jeśli folder nie istnieje, to go tworzy
		file: Path = result_directory / 'categories.txt'

		with open(file, "w", encoding="utf-8") as f:
			for category in categories:
				link = response.urljoin(category.attrib['href'])
				title = category.attrib['title']
				f.write(f"{title} -> {link}\n")

				# yield scrapy.Request(link, self.parse_category, cb_kwargs=dict(category_name=title))

	# def parse_category(self, response: HtmlResponse, category_name: str):
	# 	subcategories: SelectorList = response.xpath(
	# 		'//nav[@class="empikNav"]/div[@class="empikNav__menu-desktop"]//ul[@class="main-nav__categories '
	# 		'nav-categories"]/li['
	# 		'@class!="nav-categories__separator"]/a[@title!="Empikfoto.pl" and @title!="Empikbilety.pl"]')


if __name__ == "__main__":
	process: CrawlerProcess = CrawlerProcess()
	process.crawl(EmpikSpider)
	process.start()
