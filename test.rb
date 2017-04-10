require 'nokogiri'
require 'httparty'
require 'json'
require 'csv'
require 'pry'
require 'sqlite3'

require_relative 'scrapmethod'
url = 'https://orangecounty.craigslist.org/spa/6075356365.html'

headless = Headless.new
headless.start
browser = Watir::Browser.start url

data = ScrapeData.new(browser)
data.setup



begin
    
    db = SQLite3::Database.open "test.db"
    db.execute "CREATE TABLE IF NOT EXISTS ListData(Id INTEGER PRIMARY KEY, 
        Name TEXT, Price INT)"
    db.execute("INSERT INTO ListData(id, name) VALUES(?, ?)", [1, 'Bugs Bunny'])

rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
ensure
    db.close if db
end

browser.close
headless.destroy

pry.start(binding)
