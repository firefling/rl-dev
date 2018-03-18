#!/usr/bin/env ruby

class Map

  def initialize data
    data.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def verify_format
    ## string.sub!(/^1/, '')
  end

  def load
    File.read(path)
  end

  def path
    MAP_PATH + file
  end

  attr_reader :name, :file

end

class Maps
  def initialize
    @list = DataLoader.load_file('maps').map do |data|
      Map.new(data)
    end
  end

  def [] name
    @list.find{ |m| m.name == name }
  end

  private

  attr_reader :list

end
