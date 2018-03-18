#!/usr/bin/env ruby

class MapLoader
  def self.load_file(file)
    new.load_file(file)
  end

  def load_file(file)
    File.readlines(file)
  end
end
