require 'nokogiri'
require 'open-uri'
require 'openssl'
# Fetch and parse HTML document
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
url = 'https://www.petsonic.com/es/perros/snacks-y-huesos-perro'
doc = Nokogiri::HTML(open(url))

puts "### Search for nodes by xpath"
pageCount = doc.xpath('//div[@id="pagination_bottom"]//ul/li[last()-1]')[0].content.to_i
puts pageCount

1..pageCount.times do |i|
    doc = Nokogiri::HTML(open(url +'?p={i}'))
    doc.xpath('//section//div/a[@class="product_img_link"]').each do |link|
         puts link['href']
    end  
end

