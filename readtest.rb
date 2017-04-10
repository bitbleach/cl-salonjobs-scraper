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
url = 'https://orangecounty.craigslist.org/spa/6075454494.html'

headless = Headless.new
headless.start
browser = Watir::Browser.start url

data = ScrapeData.new(browser)
data.setup
puts data.img_flag
data.delete
browser.close
headless.destroy

pry.start(binding)
