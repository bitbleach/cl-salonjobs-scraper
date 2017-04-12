gem 'geocoder'
require 'nokogiri'
require 'httparty'
require 'json'
require 'csv'
require 'pry'
require 'mechanize'
require 'headless'
require 'watir'
require "open-uri"
require 'geocoder'
require_relative 'scrapmethod'
# 1 image
url = 'https://orangecounty.craigslist.org/spa/6074023996.html'

begin
    headless = Headless.new
    headless.start
    browser = Watir::Browser.start url
rescue
    sleep(10)
    headless = Headless.new
    headless.start
    browser = Watir::Browser.start url
    puts "failed once"
end

data = ScrapeData.new(browser)
data.setup
#puts data.img_flag
#data.delete

#no image
=begin
url = 'https://orangecounty.craigslist.org/spa/6084134271.html'
browser.goto url
data2 = ScrapeData.new(browser)
data2.setup
puts data2.img_flag
=end
pry.start(binding)

browser.close
headless.destroy

