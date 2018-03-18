#!/usr/bin/env ruby

GLYPHS = {
  '&' => 't',
  '=' => 'r',
  '^' => 'm',
  '~' => 'd',
  '"' => 'p',
  '-' => 'a',
  '.' => 'f',
  '#' => 'w'
  }

ARGF.each do |line|
  puts line.gsub(/[#{GLYPHS.keys.join}]/, GLYPHS)
end
