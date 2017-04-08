
require 'nokogiri'
require 'httparty'
require 'json'
require 'csv'
require 'pry'
require 'mechanize'
require_relative 'scrapmethod'

url = 'https://orangecounty.craigslist.org/search/spa'
page = HTTParty.get(url)

# google map scrape
url = 'https://orangecounty.craigslist.org/spa/6068712195.html'
agent = Mechanize.new
doc = agent.get(url)

latitude = doc.search('.mapbox').xpath('//div/@data-latitude').text
longitude = doc.search('.mapbox').xpath('//div/@data-longitude').text

# get posting body and remove useless header
doc.search('.userbody').css('section#postingbody').css('p').remove
body = doc.search('.userbody').css('section#postingbody').text

File.open("body.txt", "a") do |line|
    line.puts body
end

pry.start(binding)
