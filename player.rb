#!/usr/bin/env ruby

class Player
  attr_reader :role, :race, :gender, :alignment, :attributes, :hitpoints, :max_hitpoints, :power, :max_power, :glyph, :color, :bold

  @@glyph = '@'
  @@color = 229
  @@bold = true

  def self.glyph
    @@glyph
  end

  def self.color
    @@color
  end

  def self.bold
    @@bold
  end

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
  end
end

class PlayerController
  def initialize ui, options
    @ui = ui
    @options = options
    @x = options[:player_x]
    @y = options[:player_y]
  end

  # def player
  #   options[:player]
  # end

  attr_reader :ui, :options, :x, :y

  def render
    ui.draw_player(y, x, Player.glyph, Player.color, Player.bold)
  end
end
