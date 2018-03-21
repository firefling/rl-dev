#!/usr/bin/env ruby

$LOAD_PATH.unshift '.' # makes requiring files easier

require 'pathname'
require 'pp'
require 'curses'
require 'utils'
require 'ui'
require 'selection_screen'
require 'role'
require 'race'
require 'gender'
require 'alignment'
require 'weapon'
require 'terrain'
require 'player'
require 'attribute_generator'
require 'game'
require 'map'
require 'display'
require 'char_layout'
require 'main_layout'
require 'title_screen'
require 'yaml'
require 'data_loader'
require 'messages'

MAP_PATH = Pathname.new(__FILE__).dirname + 'maps'
DATA_PATH = Pathname.new(__FILE__).dirname + 'data'

Game.new.run
