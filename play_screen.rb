#!/usr/bin/env ruby

class MainScreen
  def initialize ui, options
    @ui = ui
    @options = options
    @screen_layout = MainLayout.new
    @map_display = MapDisplay.new(ui)
    @player_display = PlayerDisplay.new(ui)
  end

  def render
    ui.clear
    render_map_box
    render_msg_box
  end

  def render_map map=options[:current_map]
    map_display.render(map.layout, screen_layout.map_box.width, screen_layout.map_box.height, map_yoffset, map_xoffset)
  end

  def render_tile y, x, map=options[:current_map]
    map_display.render(map.get_tile(y, x), screen_layout.map_box.width, screen_layout.map_box.height, map_yoffset + y, map_xoffset + x)
  end

  def render_player
    player_display.render(options[:player].coordinates.y, options[:player].coordinates.x, map_yoffset, map_xoffset)
  end

  private

  attr_reader :ui, :options, :screen_layout, :map_display, :player_display

  def render_map_box
    ui.rectangle(screen_layout.map_box.yoffset, screen_layout.map_box.xoffset, screen_layout.map_box.width, screen_layout.map_box.height)
  end

  def render_msg_box
    ui.msg(screen_layout.msg_box.yoffset, screen_layout.msg_box.xoffset+2, 'MESSAGES')
    ui.rectangle(screen_layout.msg_box.yoffset+1, screen_layout.msg_box.xoffset, screen_layout.msg_box.width, screen_layout.msg_box.height)
  end

  def map_yoffset
    1 + screen_layout.map_box.yoffset
  end

  def map_xoffset
    1 + screen_layout.map_box.xoffset
  end
end

# TO STRUCT
class MainLayout
  def initialize
    @map_box_y_offset = 1
    @map_box_x_offset = 4
    @width = Curses.cols
    @height = Curses.lines
    @horizontal_margin = 1
    @vertical_margin = 2
    @map_box = MapBox.new(map_box_y_offset, map_box_x_offset)
    @msg_box = MessageBox.new(msg_box_y_offset, msg_box_x_offset(map_box.width) , msg_box_width(map_box.width))
  end

  attr_reader :width, :height, :msg_box, :map_box

  private

  attr_reader :map_box_y_offset, :map_box_x_offset, :horizontal_margin, :vertical_margin

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

# TO STRUCT
class MapBox
  def initialize yoffset=0, xoffset=0
    @width = 135
    @height = 40
    @yoffset = yoffset
    @xoffset = xoffset
  end

  attr_reader :width, :height, :yoffset, :xoffset
end

# TO STRUCT
class MessageBox
  def initialize yoffset, xoffset, width=40, height=20
    @width = width
    @height = height
    @yoffset = yoffset
    @xoffset = xoffset
  end

  attr_reader :width, :height, :yoffset, :xoffset
end
