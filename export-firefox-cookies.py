#!/usr/bin/python
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
# Given a cookies.sqlite from your firefox profile, an output file and any part
# of a hostname will export all of the matching cookies into the output file.

import sqlite3 as db
import sys

cookiedb = sys.argv[1]
targetfile = sys.argv[2]
what = '%' + sys.argv[3] + '%'

print "Filter: %s" % what

connection = db.connect(cookiedb)
cursor = connection.cursor()
statement = """
  SELECT host, path, isSecure, expiry, name, value
    FROM moz_cookies
    WHERE host LIKE ?
"""

cursor.execute(statement, (what,))

file = open(targetfile, 'w')
format = "%s\tTRUE\t%s\t%s\t%d\t%s\t%s\n"
index = 0
for row in cursor.fetchall():
  file.write(format % (row[0], row[1], str(bool(row[2])).upper(), row[3],
                       str(row[4]), str(row[5])))
  index += 1

print "Count: %d" % index

file.close()
connection.close()
