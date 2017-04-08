class ScrapeData
attr_reader :body
attr_reader :listing_title
attr_reader :longitude
attr_reader :latitude
attr_reader :image_titles

    def initialize(num, browser)
        # Instance variables
        @num = num
        @browser = browser
        @image_titles = []
        @image_links = []
    end
    
    def setup
        scrape_text
        img_dl
    end
    
    def img_dl
        (1..@num).each do |count|
            
            href_holder = @browser.a(:title, "#{count}").href
            @image_links.push(href_holder)
            
            title = href_holder.match /\/(?!.*\/)(.*)/
            title = title[1]
            @image_titles.push(title)
        end
        file(@image_links, @image_titles)
    end
    
    def file(image_links, image_titles)
        image_titles.each_with_index do |title, index|
            File.open("#{title}", "wb") do |f|
               f.write open(@image_links[index]).read
            end
        end
    end
    
    def scrape_text
        @body = @browser.section(:id, 'postingbody').text
        @listing_title = @browser.title
        @latitude = @browser.div(:id, 'map').data_latitude
        @longitude = @browser.div(:id, 'map').data_longitude
    end
    
end


class AutoPost 
attr_reader :browser

    def initialize(browser, object)
        # Instance variables
        @browser = browser
        @post_object = object
    end
    
    def login_peerdistrict
        @browser.text_field(:name, 'person[login]').set 'fcukexpress@gmail.com'
        @browser.text_field(:type, 'password').set 'asdqwe'
        @browser.button(:id, 'main_log_in_button').click
    end
    
    def post_peerdistrict

        #Get all link texts as an array
        # browser.div(:id, "divAddCompany").click
        @browser.a(:class, 'Topbar__topbarListingButton__2SNl8 AddNewListingButton AddNewListingButton__button__2H8yh AddNewListingButton__responsiveLayout__1JnL9').click
        # clicks salon/barber listing type
        @browser.div(:id, 'option-groups').a(:data_id, '190572').click
        # clicks tattoo type
        # browser.div(:id, 'option-groups').a(:data_id, '200714')
        # clicks subcategory Hair Stylist and Barbers
        @browser.div(:id, 'option-groups').a(:data_id, '195016').click
        # subcategory
        # Nail Stations 195004
        # Makeup Stations 195915
        # Eyebrow Waxing/Threading Stations 195917
        # Massage & Spa Rooms 202379
        
        # Rent Out vs Hire Employees
        # Rent Out 58183
        # Hiring Employees 58185
        @browser.div(:id, 'option-groups').a(:data_id, '58185').click
        # sets listing title
        @browser.text_field(:id, 'listing_title').set @post_object.listing_title
        # gets body txt data from storage
        
        # sets listing body
        @browser.form(:id, 'new_listing').textarea.set @post_object.body
        # sets location
        @browser.text_field(:id, 'listing_origin').set "huntington beach, ca"
        # upload file 
        photo = File.open(@post_object.image_titles[0], "r+") 
        path = File.expand_path(photo)
        @browser.file_field(:type,"file").set(path)
 #      File.close

        # posts listing
        #browser.button(:name, 'button').click
        # below code checks if upload is successful
        Watir::Wait.until { timeout = 60, @browser.img(:class, 'fileupload-preview-image').src != '' }
        
        sleep(2)
        # clicks post listing
        @browser.button(:name, 'button').click
    end
    
end