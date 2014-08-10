# coding: utf-8

require 'open-uri'
require 'nokogiri'

Encoding.default_external = "utf-8"

Class Scrape
  def scrape(target, string)
    if (!target)
      target = 'http://engawa.open2ch.net'
    end

    url = target + '/poverty/subback.html'

    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::XML.parse(html, nil, charset)

    thread = doc.xpath('//small/a')

    def printThread(url, title)
      p url
      p title
    end

    thread.each do |item|
      firstUrl = target + item.attributes["href"].value
      firstHtml = open(firstUrl) do |f|
        charset = f.charset
        f.read
      end

      firstDoc = Nokogiri::XML.parse(firstHtml, nil, charset)
      firstBody = firstDoc.xpath('//dd')
      firstBody.children.each do |threadBody|
        threadBody.css('a').each do |aBody|
          if (aBody.attribute('href'))
            if (aBody.attribute('href').value =~ /jpg/)
              printThread( target + item.attributes["href"].value, item.children.text)
            end
          end
        end
      end
    end
  end
end
