module BeautifulRuby
  def accumulate(key, value)
    each.inject({}) do |hash, item|
      hash[key.call(item)] ||= 0
      hash[key.call(item)] += value.call(item)
      hash
    end
  end
end


