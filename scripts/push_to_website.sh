#!/bin/sh

cd "$(dirname "$0")"
cp -r ../_book/* ../../../future-internet/

cd ../../../future-internet
git add .
git commit -m 'updated the book'
git push -u origin gh-pages
