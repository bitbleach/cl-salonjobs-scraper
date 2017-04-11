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

db = SQLite3::Database.new( "ScrapeData.db" )
db = SQLite3::Database.open "ScrapeData.db"
# gets relevant listing links for county
url = 'https://phoenix.craigslist.org/search/spa?query=hair+stylist&hasPic=1&bundleDuplicates=1'

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

list_data = Container.new(browser)
list_data.setup

list_data.links.each do |link|

    # gets data from individual listing
    browser.goto link
    
    data = ScrapeData.new(browser)
    data.setup
    
    if data.img_flag || data.map_flag == true
        puts data.img_flag
        puts data.map_flag
        next 
    end
    
    url = 'https://peerdistrict.com/en/login'
    
    browser.goto url
    
    auto_list = AutoPost.new(browser, data)
    auto_list.auto_post
    data.delete
    
    select_db = db_selection(data)

    county = list_data.county

    time = Time.now.to_s   
    case select_db
    
    when 'normal'
        db.execute "CREATE TABLE IF NOT EXISTS ListData(PD_Postdate TEXT PRIMARY KEY, 
                Link TEXT, County TEXT, CL_Postdate TEXT)"
        db.execute("INSERT INTO ListData(PD_Postdate, Link, County, CL_Postdate) 
                VALUES(?, ?, ?, ?)", [time, link, county, data.date_posted])
    when 'rental'
        db.execute "CREATE TABLE IF NOT EXISTS BoothRentData(Time TEXT PRIMARY KEY, 
                Link TEXT, County TEXT, CL_Postdate TEXT)"
        db.execute("INSERT INTO BoothRentData(Time, Link, County, CL_Postdate) 
                VALUES(?, ?, ?, ?)", [time, link, county, data.date_posted])
    else
        puts "Nothing to store"
    end
    
    sleep(5)
end

db.execute( "select * from BoothRentData" ) do |row|
  p row
end
db.close 

browser.close
headless.destroy