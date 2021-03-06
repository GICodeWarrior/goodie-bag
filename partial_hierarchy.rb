#!/usr/bin/ruby
#
# Copyright (c) 2009 Rusty Burchfield
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Crude script to show the reference hierarchy of the specified partials.

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
