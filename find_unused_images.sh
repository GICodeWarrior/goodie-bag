#!/bin/sh
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
# Helps to find images that are not being referenced in your application.

if [ $# -lt 2 ]
then
  echo 'Usage: find_unused_images.sh <image path> <search path>...' >> /dev/stderr
  echo 'Example: find_unused_images.sh public/images app public/stylesheets public/javascripts' >> /dev/stderr
  exit 1
fi

image_path=$1
shift
search_path=$*

escaped_image_path=$(echo $image_path | sed 's/\//\\\//g')
escaped_search_path=$(echo $search_path | sed 's/\//\\\//g')

find $image_path -maxdepth 1 -type f -printf %f\\n \
  | sort \
  | sed 's/^\(.*\)\.\([^.]*\)$/grep -qR "\1" '"$escaped_search_path"' || echo '"$escaped_image_path"'\/\1.\2/' \
  | sh

