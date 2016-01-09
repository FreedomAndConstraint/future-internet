#!/bin/sh


cd "$(dirname "$0")"

cd ..

#remove all .md files except README.md from the root directory
find . -type f -name '*.md' ! -name 'README.md' -delete

# create book directory if does not exist
if [ ! -d book ]; then
  mkdir book
fi

# copy the markdown wiki files from wiki directory which should be cloned in ../dtw-wiki/wiki
cp ../../dtw-wiki/wiki/Vision.md ./book/
cp ../../dtw-wiki/wiki/Technology-space.md ./book/
#temporary - end

#copy everything until the first section to the README.md
# not really needed anymore - corrected the source file
:<<'deleting_first_lines'
echo '#Introduction \n' >> README.md
sed -e '/^[#]/,$d' book/Technology-space.md >> README.md
deleting_first_lines

#remove tables of contents
sed '/TOC/d' -i README.md
# and then get rid of the same
sed '/^[#]/,$!d' -i book/Technology-space.md

#inserting '---' before every (sub)secton in order for the markdown splitter to know how to split the single markdown file
sed "/^[#]/i ---\n" book/Vision.md > book/Vision-split.md

sed "/^[#]/i ---\n" book/Technology-space.md > book/Technology-space-split.md

#delete first two lines of a file
cat book/Vision-split.md | tail -n+2 > book/Vision-split2.md
mv book/Vision-split2.md book/Vision-split.md

#cat book/Technology-space-split.md | tail -n+2 > book/Technology-space-split2.md

# put both files into one for splitting
cat book/Vision-split.md >> book/All_text.md
cat book/Technology-space-split.md >> book/All_text.md

#split the joned file
node_modules/.bin/markdown-splitter book/All_text.md --output . --summary=./SUMMARY.md

#this is needed for trimming the tab characters from all the lines, if the file starts with tab character (which means that thewhole file is innented one tab too much...)

:<<'delete_tabs'
first_char=$(head -c 1 SUMMARY.md)

if [ $first_char==\t ]
then
sed 's/^\t//' -i SUMMARY.md
fi
delete_tabs
