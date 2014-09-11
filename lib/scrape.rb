# encoding: utf-8
module Scrape
  require 'open-uri'
  require 'nokogiri'
  Encoding.default_external = "utf-8"
  def scrape(target,thread)
    if (!target)
      target = 'http://engawa.open2ch.net'
    end
    if (!thread)
      thread = 'proverty'
    end

    url = target + "/" + thread + "/subback.html"

    p "Log :scrape url=" + url

    scrapeArray = []

    charset = nil
    html = open(url) do |f|
      charset = f.charset
      p charset
      p f
      #f.read.encode("utf-8", :invalid => :replace, :undef => :replace)
      f.read
    end

    doc = Nokogiri::XML.parse(html, nil, charset)

#    p "parse: " + doc

    thread = doc.xpath('//small/a')

    thread.each do |item|
      firstUrl = target + item.attributes["href"].value
      firstUrl = firstUrl.sub("l50","1")
      firstHtml = open(firstUrl) do |f|
        firstHtmlCharset = f.charset
        f.read
      end

      firstDoc = Nokogiri::XML.parse(firstHtml, nil, firstHtmlCharset)
      p "firstDoc: " + firstDoc
      firstBody = firstDoc.xpath('//dd')
      firstBody.children.each do |threadBody|
        scrapeItem = {}
        threadBody.css('a').each do |aBody|
          if (aBody.attribute('href'))
            if (aBody.attribute('href').value =~ /jpg|png/)
              p item.children.text
              scrapeItem["url"] = target + item.attributes["href"].value
              scrapeItem["title"] = item.children.text
              scrapeItem["image"] = aBody.attribute('href').value
              scrapeArray.push(scrapeItem)
              break
            end
          end
        end
      end
    end
    return scrapeArray
  end
end
