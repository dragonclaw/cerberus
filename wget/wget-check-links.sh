#!/bin/bash

# wget check links for 404s
#==========================

wget --spider -o ~/Desktop/wget.log -e robots=off -w 1 -r -p http://127.0.0.1


# --spider, this tells Wget not to download anything since we only want a report so it will only do a HEAD request not a GET 

# -o ~/wget.log, log messages to the declared file, in this case a file called wget.log that will be saved to your home directory 

# -e robots=off, this one tells wget to ignore the robots.txt file

# -w 1, adds a 1 second wait between requests, this slows down Wget to more consistent rate to minimise stress on the hosting server so you don’t get back any false positives

# -r, this means recursive

# -p, get all page requisites such as images, etc. needed to display HTML page so we can find broken image links too

# http://www.example.com, finally the website url to start from
