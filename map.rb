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

  def load ui
    @ui = ui
    @layout = File.read(path)
    @width = layout.index("\n")
    @height = layout.count("\n")
    @terrains = Terrains.new
    return self
  end

  def get_tile y, x
    layout[y * (width + 1) + x]
  end

  def terrain_info y, x
    terrains = Terrains.new
    terrains[get_tile(y, x)]
  end

  def path
    MAP_PATH + file
  end

  attr_reader :ui, :name, :file, :layout, :width, :height, :terrains

  def render box_width, box_height, offset
    err 'Cannot render map. Layout not loaded.' unless layout

    yoffset = offset.y
    xoffset = offset.x

    # this information is already included in the Map object (should be passed as arguments)
    if layout.include?("\n")
      width = layout.index("\n")
      height = layout.count("\n")
    else
      width = layout.size
      height = 1
    end

    # centre map if needed
    yoffset += (box_height - height) / 2 if height < box_height and height > 1
    xoffset += (box_width - width) / 2 if width < box_width and width > 1

    index = 0
    for t in layout.scan(/((.)\2*)/).map{ |m| [m[1], m[0].length] } #.each_with_index do |t, i|
      next if t[0] == "\n"
      terrain = terrains[t[0]]
      ui.draw_terrain(YX.new(yoffset + (index/width).round(0), xoffset + (index % width)), terrain.glyph, t[1], terrain.color, terrain.bold)
      index += t[1]
    end
  end

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

class MapDisplay
  def initialize ui
    @ui = ui
    @terrains = Terrains.new
    @maps = Maps.new
  end

  # separate function for rendering one tile?
  def render map_layout, box_width, box_height, y=0, x=0
    err 'Cannot render map. Layout not loaded.' unless map_layout

    yoffset = y
    xoffset = x

    # this information is already included in the Map object (should be passed as arguments)
    if map_layout.include?("\n")
      width = map_layout.index("\n")
      height = map_layout.count("\n")
    else
      width = map_layout.size
      height = 1
    end

    # centre map if needed
    yoffset += (box_height - height) / 2 if height < box_height and height > 1
    xoffset += (box_width - width) / 2 if width < box_width and width > 1

    index = 0
    for t in map_layout.scan(/((.)\2*)/).map{ |m| [m[1], m[0].length] } #.each_with_index do |t, i|
      next if t[0] == "\n"
      terrain = terrains[t[0]]
      ui.draw_terrain(yoffset + (index/width).round(0), xoffset + (index % width), terrain.glyph, t[1], terrain.color, terrain.bold)
      index += t[1]
    end

  end

  private

  attr_reader :ui, :terrains

end
