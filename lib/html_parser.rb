require 'nokogiri'
require 'open-uri'

module HtmlParser

  def self.doc_from_url(url)
    doc = Nokogiri::HTML(open(url))
  end

  def self.parse(doc, css_tag)
    # css method returns Nokogiri::XML::NodeSet
    nodeset = doc.css(css_tag)
    arr = []
    # convert Nokogiri::XML::NodeSet to normal array so that it can be converted to json
    nodeset.each do |elem|
      arr.push(elem.text)
    end
    arr.to_json
  end

  def self.parse_link(doc)
    # css method returns Nokogiri::XML::NodeSet
    nodeset = doc.css('a')
    arr = []
    # convert Nokogiri::XML::NodeSet to normal array so that it can be converted to json
    nodeset.each do |elem|
      arr.push({href: elem['href'], link_text: elem.text})
    end
    arr.to_json
  end
end
