require 'nokogiri'
require 'gplus_stats/matchers/match'

module GplusStats::Matchers::FollowerCount
  extend self
  extend GplusStats::Matchers::Match

private

  def match_followers(html)
    doc = Nokogiri::HTML(html)
    doc.css(".vkb").children.first.text.gsub(/\D/,'').to_i
  rescue NoMethodError
  end

end
