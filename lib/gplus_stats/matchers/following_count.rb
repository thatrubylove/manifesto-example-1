require 'nokogiri'
require 'gplus_stats/matchers/match'

module GplusStats::Matchers::FollowingCount
  extend self
  extend GplusStats::Matchers::Match

private

  def match_followings(html)
    doc = Nokogiri::HTML(html)
    doc.css('.bkb').children.first.children.first.text.gsub(/\D/,'').to_i
  end

end
