
class Container
attr_reader :listing_links

    def initialize(parse)
        # Instance variables
        @parse = parse
        @listing_titles = []
        @listing_href = []
        @listing_links = []
        @body
    end
    
    # Gets listing titles
    def get_lists
        @parse.css('li').css('.result-row').css('p').css('a').css(".result-title").each do |a|
          @title = a.text
          @listing_titles.push(@title)
        end
    end
    
    # Gets links to listings
    def get_href
        @parse.css('li').css('.result-row').css('p').css('a').css(".result-title").xpath('@href').each do |a|
          @title = a.text
          @listing_href.push(@title)
        end
    end

    def totalcount
        @parse.css('span').css('.totalcount')[0].text.to_i
    end
    
    def get_links
        @listing_href.each_with_index do |listing, index|
          @listing_links.push('https://orangecounty.craigslist.org' + @listing_href[index])
        end
    end
    
    def show
        puts @listing_titles
        puts @listing_links
    end
end