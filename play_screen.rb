#!/usr/bin/env ruby

class PlayScreen
  def initialize ui, options
    @ui = ui
    @options = options
    @map_box_y_offset = 1
    @map_box_x_offset = 4
    @width = Curses.cols
    @height = Curses.lines
    @horizontal_margin = 1
    @vertical_margin = 2
    @map_box = MapBox.new(ui, map_box_y_offset, map_box_x_offset)
    @msg_box = MessageBox.new(ui, msg_box_y_offset, msg_box_x_offset(map_box.width) , msg_box_width(map_box.width))
    # @maps = Maps.new
  end

  def render
    ui.clear
    map_box.render
    msg_box.render
  end

  def load_initial_map
    load_map(options[:initial_map])
  end

  def load_map map=options[:current_map]
    map_box.load_map(map)
  end

  private

  attr_reader :ui, :options, :map_box_y_offset, :map_box_x_offset, :width, :height, :horizontal_margin, :vertical_margin, :msg_box, :map_box

  def msg_box_x_offset map_box_width
    map_box_x_offset + map_box_width + 2 + vertical_margin
  end

  def msg_box_y_offset
    map_box_y_offset + 1
  end

  def msg_box_width map_box_width
    width - msg_box_x_offset(map_box_width) - map_box_x_offset
  end

end


class MapBox
  def initialize ui, yoffset=0, xoffset=0
    @ui = ui
    @maps = Maps.new
    @map_loader = MapRenderer.new(ui)
    @width = 135
    @height = 40
    @yoffset = yoffset
    @xoffset = xoffset
  end

  def render
    ui.rectangle(yoffset, xoffset, width, height)
  end

  def load_map map_name
    map = maps[map_name]
    map_loader.render_map(map, width, height, yoffset + 1, xoffset + 1)
  end

  attr_reader :width, :height

  private

  attr_reader :ui, :maps, :map_loader, :yoffset, :xoffset
end


class MapRenderer
  def initialize ui
    @ui = ui
    @terrains = Terrains.new
  end

  def render_map map, box_width, box_height, y=0, x=0
    yoffset = y
    xoffset = x

    # load map text
    map_symbols = map.load
    height = map_symbols.count("\n")
    width = map_symbols.index("\n")

    # centre map if needed
    yoffset += (box_height - height) / 2 if height < box_height
    xoffset += (box_width - width) / 2 if width < box_width

    index = 0
    for t in map_symbols.scan(/((.)\2*)/).map{ |m| [m[1], m[0].length] } #.each_with_index do |t, i|
      next if t[0] == "\n"
      terrain = terrains[t[0]]
      ui.draw_terrain(yoffset + (index/width).round(0), xoffset + (index % width), terrain.glyph, t[1], terrain.color, terrain.bold)
      index += t[1]
    end
  end

  private

  attr_reader :ui, :terrains
end


class MessageBox
  def initialize ui, yoffset, xoffset, width=40, height=20
    @ui = ui
    @width = width
    @height = height
    @yoffset = yoffset
    @xoffset = xoffset
  end

  def render
    ui.message(yoffset, xoffset+2, 'MESSAGES')
    ui.rectangle(yoffset+1, xoffset, width, height)
  end

  attr_reader :width, :height

  private

  attr_reader :ui, :yoffset, :xoffset
end
