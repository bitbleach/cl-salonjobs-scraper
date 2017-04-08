
require 'nokogiri'
require 'httparty'
require 'json'
require 'csv'
require 'pry'
require 'mechanize'
require 'headless'
require 'watir'
require "open-uri"

require_relative 'scrapmethod'


=begin
url = 'https://orangecounty.craigslist.org/search/spa'

page = HTTParty.get(url)

parse_page = Nokogiri::HTML(page)

title_array = []
listing_url_array = []

test = Container.new(parse_page)
test.get_lists
test.get_href
test.get_links

# no image
#url = 'https://orangecounty.craigslist.org/spa/6067504265.html'
# with image
#url = 'https://orangecounty.craigslist.org/spa/6069870711.html'
# google map scrape

=end
url = 'https://orangecounty.craigslist.org/spa/6075356365.html'

headless = Headless.new
headless.start
browser = Watir::Browser.start url

data = ScrapeData.new(2 ,browser)
data.setup

browser.close
headless.destroy

url = 'https://peerdistrict.com/en/login'

headless = Headless.new
headless.start
browser = Watir::Browser.start url 

auto_list = AutoPost.new(browser, data)
auto_list.login_peerdistrict
auto_list.post_peerdistrict

pry.start(binding)


browser.close
headless.destroy
