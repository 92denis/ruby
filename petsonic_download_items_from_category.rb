require 'nokogiri'
require 'open-uri'
require 'openssl'
# Fetch and parse HTML document
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
doc = Nokogiri::HTML(open('https://www.petsonic.com/es/perros/snacks-y-huesos-perro?p=1'))


puts "### Search for nodes by xpath"
doc.xpath('//section//div/a[@class="product_img_link"]').each do |link|
puts link['href']
end

