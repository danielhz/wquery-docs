#!/bin/sh

jekyll build
rsync -aPv _site/* dhernand@dcc.uchile.cl:public_www/wquery/
