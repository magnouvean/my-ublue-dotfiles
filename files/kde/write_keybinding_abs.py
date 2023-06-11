#!/usr/bin/env python

import configparser
import sys

if len(sys.argv) != 5:
    raise Exception

_, file, group, key, value = sys.argv

config = configparser.ConfigParser()
config.optionxform = str
config.read(file)
if not group in config:
    config.add_section(group)
if key in config[group]:
    del config[group][key]
config.set(group, key + "[$i]", value)

with open(file, 'w') as configfile:
    config.write(configfile)
