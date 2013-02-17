require 'nokogiri'
class Extractor

  def initialize(content)
    @content = content
  end

  def content
    n = Nokogiri::HTML(@content)
    div = n.css("body p")
      .map{|p| [p.parent.css("p").length, p.parent]}
      .sort {|x,y| y[0] <=> x[0]}
      .first
    div[1].css("p").map {|p| p.text}.join("\n")
  end

end
