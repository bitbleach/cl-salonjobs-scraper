require 'rubygems'
require 'nokogiri'
require 'httparty'
require 'json'
require 'csv'
require 'pry'
require 'watir'
require 'headless'
#require 'chromedriver'
require_relative 'scrapmethod'
uploadfile = "/scraper/00909_8qYJaR8wTix_600x450.jpg"

url = 'https://peerdistrict.com/en/login'

headless = Headless.new
headless.start
browser = Watir::Browser.start url 

#a = browser.text_field(name: 'person[login]')
a = browser

## website is now defunct, just a sample user and password is shown below
browser.text_field(:name, 'person[login]').set 'fcukexpress@gmail.com'
browser.text_field(:type, 'password').set 'asdqwe'
browser.button(:id, 'main_log_in_button').click
#Get all link texts as an array
# browser.div(:id, "divAddCompany").click
browser.a(:class, 'Topbar__topbarListingButton__2SNl8 AddNewListingButton AddNewListingButton__button__2H8yh AddNewListingButton__responsiveLayout__1JnL9').click
# clicks salon/barber listing type
browser.div(:id, 'option-groups').a(:data_id, '190572').click
# clicks tattoo type
# browser.div(:id, 'option-groups').a(:data_id, '200714')
# clicks subcategory Hair Stylist and Barbers
browser.div(:id, 'option-groups').a(:data_id, '195016').click
# subcategory
# Nail Stations 195004
# Makeup Stations 195915
# Eyebrow Waxing/Threading Stations 195917
# Massage & Spa Rooms 202379

# Rent Out vs Hire Employees
# Rent Out 58183
# Hiring Employees 58185
browser.div(:id, 'option-groups').a(:data_id, '58185').click
# sets listing title
browser.text_field(:id, 'listing_title').set "test auto post"
# gets body txt data from storage

# sets listing body
browser.form(:id, 'new_listing').textarea.set "test"
# sets location
browser.text_field(:id, 'listing_origin').set "huntington beach, ca"
# upload file 
photo = File.open("00909_8qYJaR8wTix_600x450.jpg", "r+") 
path = File.expand_path(photo)
browser.file_field(:type,"file").set(path)
# posts listing
#browser.button(:name, 'button').click
# below code checks if upload is successful
Watir::Wait.until { timeout = 60, browser.img(:class, 'fileupload-preview-image').src != '' }

sleep(1)
browser.button(:name, 'button').click
pry.start(binding)

browser.close
headless.destroy

