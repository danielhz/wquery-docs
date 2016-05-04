#!/bin/sh

jekyll build
rsync -aPv _site/* dhernand@dichato.dcc.uchile.cl:public_www/wquery/
