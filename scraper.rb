
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

# gets relevant listing links for county
=begin
url = 'https://orangecounty.craigslist.org/search/spa?query=stylist&hasPic=1&bundleDuplicates=1'

headless = Headless.new
headless.start
browser = Watir::Browser.start url

list_data = Container.new(browser)
list_data.setup

puts list_data.links.size

pry.start(binding)

browser.close
headless.destroy

=end

# gets data from individual listing
url = 'https://orangecounty.craigslist.org/spa/6075356365.html'

headless = Headless.new
headless.start
browser = Watir::Browser.start url

data = ScrapeData.new(browser)
data.setup
pry.start(binding)

browser.close
headless.destroy

=begin
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
=end