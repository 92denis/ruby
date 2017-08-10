require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'csv'
# Fetch and parse HTML document
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def getProductPageUrls(url)
    doc = Nokogiri::HTML(open(url))
    pageCount = doc.xpath('//div[@id="pagination_bottom"]//ul/li[last()-1]')[0].content.to_i
    links = []
    for i in 1..pageCount
        doc = Nokogiri::HTML(open("#{url}?p=#{i}"))
        doc.xpath('//section//div/a[@class="product_img_link"]').each do |link|
            links.push(link['href'])
        end 
    end
    return links
end

def getProducts(url) 
    note =[]
    # url = 'https://www.petsonic.com/hobbit-alf-barritas-redonda-ternera-para-perros.html'
    petsonic = Nokogiri::HTML(open(url))
    name = petsonic.xpath('//h1[@itemprop="name"]/text()')

    weights = []
    petsonic.xpath('//div[@class="attribute_list"]//ul//li/span[@class="attribute_name"]/text()').each do |weight|
        weights.push(weight)
    end

    prices =[]
    petsonic.xpath('//div[@class="attribute_list"]//ul//li/span[@class="attribute_price"]/text()').each do |price|
        prices.push(price) 
    end

    linkPicture = petsonic.xpath('//img[@id="bigpic"]')[0]

    count = weights.size
    for i in 0..(count-1)
    note.push(
        title: name.text + '-' + weights[i].text,
        price: prices[i].text,
        picture: linkPicture['src']
        )
    end
    return note
end

def getAllProducts(categoryUrl)
    products = []
    productPageUrls = getProductPageUrls(categoryUrl)
    productPageUrls.size.times do |i|
        pageProducts = getProducts(productPageUrls[i])
        pageProducts.each do |product|
            products.push(product)
        end
    end    
    return products
end

def saveToCsv(products,filename)
    header = " title; price; picture"
    File.open(filename, "w") do |csv|
        csv << header + "\n"
        products.each do |product|
            csv << "#{product[:title]}; #{product[:price]}; #{product[:picture]}\n"       
        end
    end
end
if ARGV.length != 2
  puts "Нам нужны ровно два аргумента"
  exit
end
# categoryUrl = 'https://www.petsonic.com/galletas-para-perro/'
# filename = 'data.csv'
products = getAllProducts(ARGV[0])
saveToCsv(products,ARGV[1])

