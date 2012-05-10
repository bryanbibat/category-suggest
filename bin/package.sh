#!/bin/sh

cd ..
rm dev-challenge.tar.gz
tar --exclude=.gitignore --exclude=bin --exclude=spec --exclude=*.git --exclude=*.csv --exclude=node_modules --exclude=*.swp --exclude=.gitignore -zcvf dev-challenge.tar.gz dev-challenge/
md5sum dev-challenge.tar.gz
cd dev-challenge
