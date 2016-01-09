#!/bin/sh


cd "$(dirname "$0")"

cd ..

#remove all .md files except README.md from the root directory
find . -type f -name '*.md' -delete

# create book directory if does not exist
if [ ! -d book ]; then
  mkdir book
fi

# temporary - until I put the script into the right place
cp ../../dtw-wiki/wiki/Technology-space.md ./book/
#temporary - end

#copy everything until the first section to the README.md
echo '#Introduction \n' >> README.md
sed -e '/^[#]/,$d' book/Technology-space.md >> README.md
#remove table of contents
sed '/TOC/d' -i README.md
# and then get rid of the same
sed '/^[#]/,$!d' -i book/Technology-space.md

#inserting '---' before every (sub)secton in order for the markdown splitter to know how to split the single markdown file
sed "/^[#]/i ---\n" book/Technology-space.md > book/Technology-space-split.md

#delete first two lines of a file
cat book/Technology-space-split.md | tail -n+2 > book/Technology-space-split2.md

node_modules/.bin/markdown-splitter book/Technology-space-split2.md --output . --summary=./SUMMARY.md

#this was supopsedly needed for trimming the tab character from all the lines but suddenly everything started to work without it...

first_char=$(head -c 1 SUMMARY.md)
echo $first_char

if [ $first_char==\t ]
then
sed 's/^\t//' -i SUMMARY.md
fi
