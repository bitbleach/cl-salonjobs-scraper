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

begin
    headless = Headless.new
    headless.start
    browser = Watir::Browser.start url
rescue
    browser.close
    headless.destroy
    sleep(10)
    headless = Headless.new
    headless.start
    browser = Watir::Browser.start url
    puts "failed once"
end

data = ScrapeData.new(browser)
data.setup
data.delete

url2 = 'https://orangecounty.craigslist.org/spa/6084218956.html'
browser.goto url2

data2 = ScrapeData.new(browser)
data2.setup
data2.delete

url = 'https://orangecounty.craigslist.org/search/spa?query=stylist&hasPic=1&bundleDuplicates=1'
browser.goto url

list_data = Container.new(browser)
list_data.setup

list_data.links.each do |link|
    puts link
end


=begin
url = 'https://orangecounty.craigslist.org/search/spa?query=stylist&hasPic=1&bundleDuplicates=1'

headless = Headless.new
headless.start
browser = Watir::Browser.start url

list_data = Container.new(browser)
list_data.setup

puts list_data.links.size
=end
pry.start(binding)

browser.close
headless.destroy
select_db = db_selection(data)

county = 'orangecounty'
db = SQLite3::Database.new( "firstTest.db" )

time = Time.now.to_s   
db = SQLite3::Database.open "firstTest.db"
case select_db

when 'normal'
    db.execute "CREATE TABLE IF NOT EXISTS ListData(PD_Postdate TEXT PRIMARY KEY, 
            Link TEXT, County TEXT, CL_Postdate TEXT)"
    db.execute("INSERT INTO ListData(PD_Postdate, Link, County, CL_Postdate) 
            VALUES(?, ?, ?, ?)", [time, url, county, data.date_posted])
when 'rental'
    db.execute "CREATE TABLE IF NOT EXISTS BoothRentData(Time TEXT PRIMARY KEY, 
            Link TEXT, County TEXT, CL_Postdate TEXT)"
    db.execute("INSERT INTO BoothRentData(Time, Link, County, CL_Postdate) 
            VALUES(?, ?, ?, ?)", [time, url, "test county2", data2.date_posted])
else
    puts "Nothing to store"
end

db.execute( "select * from BoothRentData" ) do |row|
  p row
end


db.close 



