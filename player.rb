#!/usr/bin/env ruby

class Player
  attr_reader :ui, :role, :race, :gender, :alignment, :attributes, :hitpoints, :max_hitpoints, :power, :max_power, :glyph, :color, :bold, :coordinates

  def initialize ui, options
    @ui = ui
    @role = options[:role]
    @race = options[:race]
    @gender = options[:gender]
    @alignment = options[:alignment]
    @hitpoints = role.hitpoints + race.hitpoints
    @max_hitpoints = hitpoints
    @power = role.power + rand(role.rand_power + 1) + race.power
    @max_power = power

    @attributes = AttributeGenerator.new(role).attributes

    @coordinates = YX.new(options[:initial_y], options[:initial_x])

    @glyph = '@'
    @color = 229
    @bold = true
  end

  def render offset
    ui.draw_map_obj(coordinates + offset, glyph, color, bold)
  end

  def move yx
    coordinates.add!(yx)
  end

  private

  attr_writer :coordinates

end
