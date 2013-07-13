#!/usr/bin/env ruby

require_relative "lib/beautiful_ruby"

# dependencies
extras_summary = [
  {:name=>"Extra 1", :unit=>"each", :count=>3},
  {:name=>"Extra 2", :unit=>"each", :count=>2},
  {:name=>"Extra 1", :unit=>"each", :count=>1},
].freeze

def name_with_unit extra_summary
  "#{extra_summary[:name]} #{extra_summary[:unit]}"
end

# expectation
expected = {"Extra 1 each"=>4, "Extra 2 each"=>2}.freeze

# snippet #1: fugly
extras_count_store = {}
extras_summary.each do |extra_summary|
  extras_count_store[name_with_unit(extra_summary)] ||= 0
  extras_count_store[name_with_unit(extra_summary)] += extra_summary[:count]
end

raise unless extras_count_store == expected

# snippet #2: still fugly
extras_count_store_2 = extras_summary.inject({}) do |hash, extra_summary|
  hash[name_with_unit(extra_summary)] ||= 0
  hash[name_with_unit(extra_summary)] += extra_summary[:count]
  hash
end

raise unless extras_count_store_2 == expected

# snippet #3: kinda beautiful
extras_summary_dup = extras_summary.dup # need to modify frozen object
extras_summary_dup.extend BeautifulRuby
extras_count_store_3 = extras_summary_dup.accumulate(
  ->(item) { name_with_unit(item) },
  ->(item) { item[:count] }
)

raise unless extras_count_store_3 == expected

# snippet #4: kinda beautiful
Array.send(:include, BeautifulRuby)
extras_count_store_4 = extras_summary.accumulate(
  ->(item) { name_with_unit(item) },
  ->(item) { item[:count] }
)

raise unless extras_count_store_4 == expected

