require "gplus_stats/version"

require 'gplus_stats/matchers/follower_count'
require 'gplus_stats/matchers/following_count'
require 'gplus_stats/get_profile_html'

module GplusStats
  extend self

  def call(uid)
    html = profile_html(url(uid))
    {
      follower_count:  follower_count(html),
      following_count: following_count(html),
    }
  end

private

  def follower_count(html)
    GplusStats::Matchers::FollowerCount.(html)
  end

  def following_count(html)
    GplusStats::Matchers::FollowingCount.(html)
  end

  def profile_html(url)
    GplusStats::GetProfileHtml.(url)
  end

  def url(uid)
    "https://plus.google.com/u/0/#{uid}/posts"
  end

end
