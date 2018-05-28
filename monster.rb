#!/usr/bin/env ruby

class Monster
  def self.for_options _
    all
  end

  def self.all
    DataLoader.load_file('monsters').map do |data|
      new(data)
    end
  end

  attr_reader :name, :max_hp, :hp, :strength, :weapon, :glyph, :color, :bold, :level, :coordinates

  def initialize data
    data.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def to_s
    name
  end

  def set_coordinates yx
    @coordinates = yx
  end

  # def move_randomly n=1
  #   case rand(99) % 4
  #   when 0
  #     yx = [0,-n]
  #   when 1
  #     yx = [-n,0]
  #   when 2
  #     yx = [0,n]
  #   when 3
  #     yx = [n,0]
  #   else
  #     yx = [5,5]
  #   end 
  #   coordinates.add!(yx)
  # end

  def move yx
    coordinates.add!(yx)
  end

  def get_dir_to_follow yx
    dist_y = coordinates.y - yx.y
    dist_x = coordinates.x - yx.x
    if dist_y.abs > dist_x.abs
      direction = (dist_y > 0 ? :up : :down)
    else
      direction = (dist_x > 0 ? :left : :right)
    end
    direction
  end

  def render ui, offset
    ui.draw_map_obj(coordinates + offset, glyph, color, bold)
  end
end
