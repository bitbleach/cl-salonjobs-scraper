class ScrapeData
attr_reader :body
attr_reader :listing_title
attr_reader :image_titles
attr_reader :address
attr_reader :city
attr_reader :flag
attr_reader :img_flag
attr_reader :map_flag
attr_reader :date_posted



    def initialize(browser)
        # Instance variables
        @browser = browser
        @image_titles = []
        @image_links = []
        @flag = false
        @img_flag = false
        @map_flag = false
    end
    
    def setup
        scrape_text
        img_dl
        keyword_flag
    end
    
    def img_num
        if @browser.span(:class, 'slider-info').exist?
            @img_num = @browser.span(:class, 'slider-info').text
            @img_num = @img_num[-1].to_i
            
            if @img_num > 5
                @img_num = 5
            end
        else
            @img_flag = true
        end
    end
    
    def img_dl
            img_num
            unless @img_flag == true
                (1..@img_num).each do |count|
                    
                    href_holder = @browser.a(:title, "#{count}").href
                    @image_links.push(href_holder)
                    
                    title = href_holder.match /\/(?!.*\/)(.*)/
                    title = title[1]
                    @image_titles.push(title)
                end
                file(@image_links, @image_titles)
            end
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
        post_date
        map_check
        unless @map_flag == true
            @latitude = @browser.div(:id, 'map').data_latitude
            @longitude = @browser.div(:id, 'map').data_longitude
            location
        end
    end
    
    def map_check
        map_check = @browser.div(:id, 'map').exist?
        if map_check == false
            @map_flag = true
        end
    end
    
    
    def location
        geo_localization = "#{@latitude},#{@longitude}"
        query = Geocoder.search(geo_localization).first
        @address = query.address
        @city = query.city
    end
    
    def post_date
        @date_posted = @browser.time.title
    end
    
    def delete
        @image_titles.each do |title|
            File.delete(title)
        end
    end

    def keyword_flag
        @rentKW = @body.scan(/\brent\b/i).size
        @rentalKW = @body.scan(/\brental\b/i).size
        total_match = @rentKW + @rentalKW
        if total_match > 0
            @flag = true
        end
    end
end


class AutoPost 
attr_reader :browser
attr_reader :date_posted
attr_reader :post_link

    def initialize(browser, object)
        # Instance variables
        @browser = browser
        @post_object = object
    end
    
    def auto_post
        login_peerdistrict
        post_peerdistrict
    end
    
    def login_peerdistrict
        @browser.text_field(:name, 'person[login]').set 'jalcazar'
        @browser.text_field(:type, 'password').set 'mherkhatang0531'
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
        @browser.text_field(:id, 'listing_origin').set @post_object.address
        photo_upload
 #      File.close

        # posts listing
        #browser.button(:name, 'button').click
        # below code checks if upload is successful
        Watir::Wait.until { timeout = 60, @browser.img(:class, 'fileupload-preview-image').src != '' }
        
        sleep(5)
        # clicks post listing
        @browser.button(:name, 'button').click
        @post_link = @browser.url
        @date_posted = Time.now
        sleep(2)
    end
    
    def photo_upload
        # upload file 
        @post_object.image_titles.each do |title|
            photo = File.open(title, "r+") 
            path = File.expand_path(photo)
            @browser.file_field(:type,"file").set(path)
            sleep(2)
        end
    end

    
end


class Container
attr_reader :links
attr_reader :list_count
attr_reader :county


    def initialize(browser)
        # Instance variables
        @browser = browser
        @links = []
    end
    
    def setup
        filter
        get_list_count
        crawl
    end
    
    def get_links
        @browser.as(:class, 'result-title hdrlnk').each do |link|
        href = link.href
        title = link.text
            if @county_match === href
                unless @avoid_title === title
                    unless title.empty?
                        @links.push(href)
                    end
                end
            end
        end 
    end
    
    def crawl
        get_links
        if @clicks > 0 
            (1..@clicks).each do |x|
                sleep(5)
                @browser.a(:title, 'next page').click
                get_links
            end
        end
    end

    def get_list_count
         @list_count = @browser.span(:class, 'totalcount').text.to_i
         if @list_count > 120
            @clicks = (@list_count/120).floor
         else
            @clicks = 0
         end
    end
    
    def filter
        url = @browser.url
        pattern = /(?<=\/\/).*(?=\.c)/
        @county_match = url.match pattern
        @county = "#{@county_match[0]}"
        @county_match = /#{@county_match[0]}/
        @avoid_title = [/sola/i, /phenix/i]
        @avoid_title = Regexp.union(@avoid_title)
    end
end

def db_selection(object)
    if object.flag == true
        return 'rental'
    elsif object.img_flag == true
        return 'img_problem' 
    elsif object.map_flag == true
        return 'map_problem' 
    else
        return 'normal'
    end
end