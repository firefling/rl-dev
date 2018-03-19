#!/usr/bin/env ruby

class Player
  attr_reader :role, :race, :gender, :alignment, :attributes, :hitpoints, :max_hitpoints, :power, :max_power, :coordinates

  def initialize options
    @role = options[:role]
    @race = options[:race]
    @gender = options[:gender]
    @alignment = options[:alignment]
    @hitpoints = role.hitpoints + race.hitpoints
    @max_hitpoints = hitpoints
    @power = role.power + rand(role.rand_power + 1) + race.power
    @max_power = power

    @attributes = AttributeGenerator.new(role).attributes

    @coordinates = Coordinates.new(22, 1)
  end
end

class PlayerDisplay

  def initialize ui
    @ui = ui
    @glyph = '@'
    @color = 229
    @bold = true
  end

  attr_reader :ui, :glyph, :color, :bold

  def render y, x, yoffset=0, xoffset=0
    ui.draw_player(y + yoffset, x + xoffset, glyph, color, bold)
  end
end
