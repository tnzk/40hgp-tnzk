#!/usr/bin/env ruby

abort 'Usage ./auto_upgrade.rb [migrate|upgrade]' if ARGV.empty?

ENV['APP_ROOT'] = File.expand_path(File.dirname(__FILE__))

require 'ramaze'
require 'dm-migrations'
require "#{ENV['APP_ROOT']}/config/config"

p DataMapper.auto_migrate! if ARGV[0] == 'migrate'
p DataMapper.auto_upgrade! if ARGV[0] == 'upgrade'
