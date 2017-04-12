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

db = SQLite3::Database.new( "ScrapeData.db" )
db = SQLite3::Database.open "ScrapeData.db"
# gets relevant listing links for county
url = 'https://orangecounty.craigslist.org/search/spa?bundleDuplicates=1&query=stylist&hasPic=1'

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

list_data = Container.new(browser)
list_data.setup

list_data.links.each do |link|
    
    #skips links 
    match1 = db.execute("SELECT COUNT(*) FROM ListData WHERE Link=? ", link)
    match2 = db.execute("SELECT COUNT(*) FROM BoothRentData WHERE Link=? ", link)
    if match1[0][0] >= 1 || match2[0][0] >= 1
        next 
    end
    
    # gets data from individual listing
    
    browser.goto link
    
    data = ScrapeData.new(browser)
    data.setup
    
    if data.img_flag || data.map_flag == true
        puts data.img_flag
        puts data.map_flag
        data.delete
        next 
    end
    
    url = 'https://peerdistrict.com/en/login'
    
    browser.goto url
    unless data.flag == true
        auto_list = AutoPost.new(browser, data)
        auto_list.auto_post
    end
    data.delete
    
    select_db = db_selection(data)

    county = list_data.county
    time = Time.now.to_s 
    
    case select_db
    
    when 'normal'
        db.execute "CREATE TABLE IF NOT EXISTS ListData(PD_Postdate TEXT PRIMARY KEY, 
                PD_Link TEXT, Link TEXT, County TEXT, CL_Postdate TEXT)"
        db.execute("INSERT INTO ListData(PD_Postdate, PD_Link, Link, County, CL_Postdate) 
                VALUES(?, ?, ?, ?, ?)", [time, auto_list.post_link, link, county, data.date_posted])
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
=begin
db.execute( "select * from ListData" ) do |row|
  p row
end
=end
db.close 

browser.close
headless.destroy