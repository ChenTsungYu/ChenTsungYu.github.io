#!/bin/bash

set -xe

echo "start cleaning"
d1=$(date +"%s")
hexo clean
echo "start deploying"
hexo d -g
# echo "start applying algolia"
# hexo algolia
d2=$(date +"%s")
echo " Done. It takes $((d2-d1)) seconds"

