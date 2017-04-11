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
require "sqlite3"

require_relative 'scrapmethod'

url = 'https://orangecounty.craigslist.org/spa/6075356365.html'
def start_up(url)
    headless = Headless.new
    headless.start
    browser = Watir::Browser.start url
    return browser, headless
end

