#!/usr/bin/env ruby

class Weapon
  def self.for_options _
    all
  end

  def self.all
    DataLoader.load_file('weapons').map do |data|
      new(data)
    end
  end

  attr_reader :name, :type, :damage, :magical_damage, :rank, :hotkey

  def initialize data
    data.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def to_s
    name
  end
end
