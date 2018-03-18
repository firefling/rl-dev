#!/usr/bin/env ruby

class Player
  attr_reader :role, :race, :gender, :alignment, :attributes, :hitpoints, :max_hitpoints, :power, :max_power

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
