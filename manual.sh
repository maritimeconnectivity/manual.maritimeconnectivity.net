#!/bin/bash

if [ "$1" = "pdf" ]; then
    cd asciidoc
    asciidoctor-pdf manual.asciidoc -D ../target -a imagesdir=../images/
    cd ..
    exit
elif [ "$1" = "html" ]; then
    asciidoctor asciidoc/manual.asciidoc -D target
    mkdir -p target/images
    cp images/*.png target/images/
    exit
elif [ "$1" = "site" ]; then
    echo "Checking for changes to the manual"
    git status
    if ! git diff-index --quiet HEAD --; then
        echo "There are uncommitted changes"
        exit 1
    fi
    rm -rf target/
    asciidoctor asciidoc/manual.asciidoc -D target
    mkdir -p target/images
    cp images/*.png target/images/
    
    git checkout gh-pages
    cp target/manual.html index.html
    mkdir -p images
    cp target/images/* images/
    git add index.html
    git add images/*
    git commit -m "update manual"
    git push
    git checkout master
    exit   
elif [ -z "$1" ]; then 
    echo Usage: $0 target
    echo where target is:
else
    echo Unknown target: "$1"
    echo Valid targets are:
fi

echo "  pdf        Generates documentation in pdf"
echo "  html       Generates documentation in html"
echo "  site       Generates documentation in html and push to GitHub Pages"

