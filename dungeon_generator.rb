#!/usr/bin/env ruby

# Rect = Struct.new(:left, :top, :right:, :bottom)

# class DungeonGenerator
#   WIDTH = 80
#   HEIGHT = 21

#   STONE = ' '
#   FLOOR = '.'
#   HWALL = '-'
#   VWALL = '|'

#   def initialize
#     @dungeon = Array.new(HEIGHT){ Array.new(WIDTH){ STONE } }
#     @rects = [ Rect.new(0, 0, WIDTH, HEIGHT) ]
#   end

#   def generate
#     room = create_room
#     render_room(room)
#     print_dungeon
#   end

#   private

#   attr_reader :dungeon, :rects

#   def create_room
#     rect = rects.first








height = 2 + rand(4)
width = 2 + rand(12)

if width * height > 50
  width = 50 / height
end

Rect = Struct.new(:left, :top, :right, :bottom)
rect = Rect.new(0,0,80,21)

left = rect.left + 1 + rand(rect.right - width - 2)
top = rect.top + 1 + rand(rect.bottom - height - 2)

right = left + width
bottom = top + height

dungeon = Array.new(21){ Array.new(80){ ' ' } }

left.upto(right) do |x|
  top.upto(bottom) do |y|
    dungeon[y][x] = '.'
  end
end

top.upto(bottom) do |y|
  dungeon[y][left-1] = '|'
  dungeon[y][right+1] = '|'
end

(left - 1).upto(right + 1) do |x|
  dungeon[top-1][x] = '-'
  dungeon[bottom+1][x] = '-'
end

puts dungeon.map(&:join)
