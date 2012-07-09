require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

class WikiTravelCrawler
	
	attr_accessor :wiki_travel_base_url ,:pwd
	
	def initialize
		@wiki_travel_base_url = "http://wikitravel.org/en/"
		@pwd = `pwd`
	end
	
	def get_content(wiki_title)
	
		if is_available_locally(wiki_title)
			puts "Fetching data from local disk......."
			wiki_travel_html_content = File.read("../input/#{wiki_title}")
		else
			puts "Fetching data from Web......."
			wiki_travel_full_url = URI.escape(@wiki_travel_base_url + wiki_title)
			wiki_travel_html_content = `wget #{wiki_travel_full_url} -O ../input/#{wiki_title}`
		end

		return wiki_travel_html_content	
	end

	def is_available_locally(wiki_title)
		return File.exist?("../input/#{wiki_title}")
	end

	def get_title

		puts "Enter wiki page title you want to parse : "

		wiki_title = gets.strip
		wiki_content = get_content(wiki_title)
		wiki_doc = Nokogiri::HTML(wiki_content)
		output_file = File.open("../output/#{wiki_title}","w") 

		wiki_doc.xpath('//span[@class="editsection"]').each do | method_span |  
    			output_file.write  "#{method_span.css('a')[0]['title']}\n"  
		end  
	end

end

w = WikiTravelCrawler.new
w.get_title
