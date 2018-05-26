#!/usr/bin/env ruby

class Display
  def initialize ui, options
    @ui = ui
    @options = options
    @mainscreen = MainLayout.new(ui, options)
    @charscreen = CharLayout.new(ui, options)
  end

  def render
    case options[:gamestate]
    when :mainscreen
      render_mainscreen
    when :charscreen
      render_charscreen
    end
  end

  def render_mainscreen
    mainscreen.render
    mainscreen.render_map
    mainscreen.render_player
    mainscreen.render_monsters
#    ui.hide_cursor
  end

  def render_tile coordinates
    mainscreen.render_tile(coordinates)
  end

  def render_player
    mainscreen.render_player
  end

  def render_monsters
    mainscreen.render_monsters
  end

  def render_charscreen
    charscreen.render
  end

  private

  attr_reader :ui, :options, :mainscreen, :charscreen

end
