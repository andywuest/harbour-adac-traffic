#!/bin/bash
set -x
convert -resize 360X720 about_page.png about_page_small.png
convert -resize 360X720 settings_page.png settings_page_small.png
convert -resize 360X720 traffic_news.png traffic_news_small.png

