#!/usr/bin/ruby

require 'yaml'

require 'rubygems'
require 'active_support'

files = ARGV
partials = {}

files.each do |file_name|
  short_name = file_name.sub(/app\/views\//, '').sub(/.html.erb$/, '')
  partials[short_name] = []
  File.open(file_name) do |file|
    file.read.scan(/:partial\s*=>\s*("[^"]*"|'[^']*')/) do |groups|
      name = groups.first.gsub(/^\s*['"]\/?|['"]\s*$/, '')
      partials[short_name] << name.sub(/\/([^\/]+)$/, '/_\1')
    end
  end
  partials[short_name].sort!.uniq!
end

parents = partials.keys.select{|n| !partials.values.any?{|v| v.include?(n)}}

def build_tree(partials, file)
  if !partials[file] || partials[file].empty?
    return file
  else
    {file => partials[file].map{|pn| build_tree(partials, pn)}}
  end
end

puts parents.sort.map{|p| build_tree(partials, p)}.to_yaml
