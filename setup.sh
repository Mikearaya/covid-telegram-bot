#!/bin/bash

gem install bundler

cd $PWD/bin
chmod 755 main.rb ../reset.sh
cp main.rb bionic_covid_bot
ln -s $PWD/bionic_covid_bot /usr/local/bin/
cd -

bundler install
