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

    p url

    scrapeArray = []

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
        scrapeItem = {}
        threadBody.css('a').each do |aBody|
          if (aBody.attribute('href'))
            if (aBody.attribute('href').value =~ /jpg/)
              scrapeItem["url"] = target + item.attributes["href"].value
              scrapeItem["title"] = item.children.text
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
