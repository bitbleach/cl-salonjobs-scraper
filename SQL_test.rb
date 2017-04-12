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

url_test = ['https://orangecounty.craigslist.org/spa/6056942933.html', 'https://orangecounty.craigslist.org/spa/6071740915.html', 'https://orangecounty.craigslist.org/spa/6054140239.html', 'nomatch']
require_relative 'scrapmethod'
db = SQLite3::Database.open "ScrapeData.db"

db.execute( "select Link from ListData WHERE County = ?", 'orangecounty' )  do |row|
  p row
end

puts "======================"
db.execute( "select Link from BoothRentData WHERE County = ?", 'orangecounty' )  do |row|
  p row
end

db.execute( "select Link from BoothRentData WHERE County = ?", 'orangecounty' )
holder = Array.new
url_test.each do |link|
    match1 = db.execute("SELECT COUNT(*) FROM ListData WHERE Link IN (?) ", link)
    match2 = db.execute("SELECT COUNT(*) FROM BoothRentData WHERE Link IN (?) ", link)
    if match1[0][0] >= 1 || match2[0][0] >= 1
        puts "test"
        puts match1[0][0]
        puts match2[0][0]
    else
        puts "no match"
        puts link
    end
end
pry.start(binding)

db.close 


