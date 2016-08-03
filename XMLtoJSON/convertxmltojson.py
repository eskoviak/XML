#!/usr/bin/python2

import io
import json
import xmltodict

outfile = io.open('FormatTestCase1.json', 'wb')

with io.open('FormatTestCase1.xml') as file:
  outfile.write(json.dumps(xmltodict.parse(file.read())))

outfile.close()
