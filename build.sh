#!/bin/bash

# install pandoc
if $(test -s $(pwd)/pandoc-2.19.2/bin/pandoc) || $(command -v pandoc >/dev/null 2>&1); then
    echo 'already have pandoc here.'
else
    echo -e "\e[36m install pandoc \e[0m"
    curl -s -L https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz | tar xvzf - -C ./
    # set $PATH
    export PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"
fi

# install mdfmt
if $(test -s $(pwd)/pandoc-2.19.2/bin/mdfmt) || $(command -v mdfmt >/dev/null 2>&1); then
    echo 'already have mdfmt here.'
else
    echo -e "\e[36m install mdfmt \e[0m"
    mkdir $(pwd)/mdfmt && curl -s -L https://github.com/elliotxx/mdfmt/releases/download/v0.4.2/mdfmt_0.4.2_Linux_x86_64.tar.gz | tar xvzf - -C ./mdfmt/ && mv ./mdfmt/mdfmt ./pandoc-2.19.2/bin/
    rm -rf ./mdfmt
    # set $PATH
    export PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"
fi

echo -e "\tdo mdfmt -w *.md ..."
for i in $(find . -name "*.md"); do mdfmt -w $i; done

if test -s /etc/passwd && test -s /etc/os-release; then
    echo "You are use Linux now."
else
    echo -e "\e[36m Widows: LF --> CRLF \e[0m"
    for i in $(find . -name "*.md"); do sed -i 's/$/\r/g' $(find . -name "*.md"); done
fi

rm -rf ./docs/*
mkdir -p docs/p

cp -rf reveal.js sources

for i in $(ls sources/*.md); do
    echo " " >>$i
    echo "## [返回目录](../index.html#/my-slides)" >>$i
    if [ -s $(pwd)/pandoc-2.19.2/bin/pandoc ]; then
        $(pwd)/pandoc-2.19.2/bin/pandoc -t revealjs -M revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js@4 --mathjax -s "$i" -o docs/p/"$(echo $i | sed 's/sources\///g' | sed 's/md/html/g')"
    else
        pandoc -t revealjs -M revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js@4 --mathjax -s "$i" -o docs/p/"$(echo $i | sed 's/sources\///g' | sed 's/md/html/g')"
    fi
    echo "convert $i to html ..."
done

rm -rf sources

cp revealjs.md index.md

echo ' ' >>index.md
echo '## My slides' >>index.md
echo ' ' >>index.md
# echo '|  [目录](/slides/#/my-slides)  |' >>index.md
echo '|   目录  |' >>index.md
echo '| :-----: |' >>index.md

for i in $(find docs/p/ -name *.html); do
    echo "| [$(echo $i | sed 's/docs\/p\///' | sed 's/.html//')]($(echo $i | sed 's/docs/./')) |" >>index.md
done
echo 'make menu ...'

if [ -s $(pwd)/pandoc-2.19.2/bin/pandoc ]; then
    $(pwd)/pandoc-2.19.2/bin/pandoc -t revealjs -M revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js@4 --mathjax -s index.md -o docs/index.html
else
    pandoc -t revealjs -M revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js@4 --mathjax -s index.md -o docs/index.html
fi

rm index.md

echo 'clean ...'
