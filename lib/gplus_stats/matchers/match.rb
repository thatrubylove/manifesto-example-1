module GplusStats
  module Matchers
  end
end

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
