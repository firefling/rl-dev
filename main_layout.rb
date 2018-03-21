#!/usr/bin/env ruby

class MainLayout
  def initialize ui, options
    @ui = ui
    @options = options

    @width = Curses.cols
    @height = Curses.lines

    @horizontal_margin = 1
    @vertical_margin = 2

    @map_box_offset = YX.new(1, 4)
    @map_box = Box.new(ui, 135, 40, map_box_offset)

    @msg_box_offset = YX.new(2, map_box.width + vertical_margin + 2) + map_box_offset
    @msg_box = Box.new(ui, width - msg_box_offset.x - map_box_offset.x, 20, msg_box_offset)

    @map_obj_offset = map_box_offset + [1,1]
    @msg_obj_offset = msg_box_offset + [1,1]
  end

  attr_reader :ui, :options, :width, :height

  def render
    ui.clear
    msg_box.render_with_title('MESSAGES:')
    map_box.render
  end

  def render_map
    map.render(map_box.width, map_box.height, map_obj_offset)
  end

  def render_tile
    tile = map.terrain_info(options[:player].coordinates)
    ui.draw_map_obj(options[:player].coordinates + map_obj_offset, tile.glyph, tile.color, tile.bold)
  end

  def render_player
    player.render(map_obj_offset)
  end

  private

  attr_reader :map_box_offset, :msg_box_offset, :horizontal_margin, :vertical_margin, :msg_box, :map_box, :map_obj_offset, :msg_obj_offset

  def player
    options[:player]
  end

  def map
    options[:current_map]
  end

end

class Box
  def initialize ui, width, height, offset
    @ui = ui
    @width = width
    @height = height
    @offset = offset
  end

  attr_reader :ui, :width, :height, :offset

  def render
    ui.rectangle(offset, width, height)
  end

  def render_with_title title
    ui.msg(offset.up.right(2), title)
    render
  end
end
