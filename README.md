# Google Stats Library
## Ruby Programming Manifesto - Example 1

### The public interface and usage

```ruby
require 'gplus_stats'
GplusStats.('+DreamrOKelly')
# => {:follower_count=>21, :following_count=>9}
```

### The business object

```ruby
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
```

### A downloader delegate object

```ruby
module GplusStats::GetProfileHtml
  extend self

  def call(url)
    scrape(url)
  end

private

  def crawler
    Typhoeus
  end

  def scrape(url)
    html = crawler.get(url, followlocation: true).body
    return rescrape(url) if has_moved?(url)
    html
  end

  def rescrape(url)
    redirection_url = redirect_location(html)
    scrape(redirect_location)
  end

  def has_moved?(html)
    html =~ /<title>moved temporarily<\/title>/i
  end

  def url_matcher
    /The document has moved \<A HREF=\"(.*)\">here<\/A>/i
  end

  def redirect_location(html)
    html.scan(url_matcher).flatten[0]
  end

end
```


### A Matcher object for follower_count

```ruby
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
```


### A Matcher object for following_count

```ruby
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
```

### A 'base' matcher object to share functionality

```ruby
module GplusStats::Matchers::Match

  def call(html)
    matches(html) || 0
  end

protected

  def matchers
    private_methods.map(&:to_s).select {|m| m =~ /match_/}
  end

  def matches(html)
    results = matchers.map {|matcher| send(matcher, html) }
    results.compact.any? ? results[0] : nil
  end

end
```
