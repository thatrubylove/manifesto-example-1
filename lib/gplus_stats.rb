require "gplus_stats/version"

require 'gplus_stats/matchers/follower_count'
require 'gplus_stats/matchers/following_count'
require 'gplus_stats/get_profile_html'

module GplusStats
  extend self

  def call(uid)
    google_url = url(uid)
    {
      follower_count:  follower_count(google_url),
      following_count: following_count(google_url),
    }
  end

private

  def follower_count(url)
    GplusStats::Matchers::FollowerCount.(profile_html(url))
  end

  def following_count(url)
    GplusStats::Matchers::FollowingCount.(profile_html(url))
  end

  def profile_html(url)
    GplusStats::GetProfileHtml.(url)
  end

  def url(uid)
    "https://plus.google.com/u/0/#{uid}/posts"
  end

end
