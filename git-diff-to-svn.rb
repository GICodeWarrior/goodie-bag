#!/usr/bin/ruby -w
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
# Crude attempt to make a git diff look like an svn diff.  Useful for tools
# that only like svn diffs.

diff_options=ARGV.join(' ')
diff = `unset GIT_EXTERNAL_DIFF; git diff #{diff_options}`;
svn_rev = `git svn info | awk '/^Revision: /{print$2}'`.chomp

diff.gsub!(/^diff --git (.*\n)+?--- .*\n\+\+\+ .*\n/) do |matched|
  file = matched.match(/^--- a\/.*$/).to_s.sub(/^--- a\//, '')
  "Index: #{file}\n#{'='*66}\n" +
  "--- #{file}\t(revision #{svn_rev})\n" +
  "+++ #{file}\t(working copy)\n"
end

puts diff
