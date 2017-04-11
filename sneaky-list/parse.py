#! /usr/bin/python

import csv
reader = csv.reader(open('/usr/local/sneaky-wifi/sneaky-list/tmp-01.csv','rb'), delimiter=',')
i = 0
for row in reader:
    if 1 < i < 21:
        if row:
            if "00" not in row[13]:
                print row[0] + " " + row[3] + " " + row[13]
    i += 1
