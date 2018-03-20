#!/usr/bin/env ruby

class UI
  include Curses

  attr_reader :win

  def initialize
    noecho # do not print characters the user types
    init_screen
    @win = Window.new(0,0,0,0)
    win.keypad = true
    start_color
    use_default_colors
    initialize_colors
  end

  def close
    close_screen
  end

  def clear
    win.clear #super
  end

  def msg coordinates, str
    y = coordinates.y
    x = coordinates.x

    x = x + cols if x < 0
    y = y + lines if y < 0

    win.setpos(y, x) # place the cursor at our position
    win.addstr(str) # prints a string at cursor position
    curs_set(0)
  end

  def draw_player coordinates, glyph, color=16, bold=false
    win.attron(color_pair(color)|(bold ? A_BOLD : A_NORMAL)){
      msg(coordinates, glyph)
    }
  end

  def vertical coordinates, length, char='|'
    length.times do |i|
      msg(coordinates.down(i), char)
    end
  end

  def horizontal coordinates, length, char='-'
    length.times do |i|
      msg(coordinates.right(i), char)
    end
  end

  def rectangle coordinates, width, height, color=8
    win.attron(color_pair(color)){
      horizontal(coordinates, width + 2)
      horizontal(coordinates.up(height + 1), width + 2)
      vertical(coordinates.up, height)
      vertical(coordinates + Coordinates.new(1, width + 1), height)
    }
  end

  def print_table hash, coordinates, just=:none, interline=1, separator=':'
    line = 0
    for key, value in hash
      left_indent = 0
      centre_indent = 1
      case just
      when :centre
        left_indent = hash.keys.longest.to_s.length - key.to_s.length
      when :right
        left_indent = hash.keys.longest.to_s.length - key.to_s.length
        centre_indent = 1 + hash.values.longest.to_s.length - value.to_s.length
      when :left
        centre_indent = 1 + hash.keys.longest.to_s.length - key.to_s.length
      end
      msg(coordinates + Coordinates.new(line, left_indent),
              key.to_s.capitalize + separator + ' '*centre_indent + value.to_s)
      line += interline
    end
  end

  def choice_prompt coordinates, string, choices
    msg(coordinates, string + " ")

    loop do
      choice = win.getch
      return choice if choices.include?(choice)
    end
  end

  def draw_terrain coordinates, symbol, n=1, color=8, bold=false
    # color = Object.const_get('Curses::'+c)
    win.attron(color_pair(color)|(bold ? A_BOLD : A_NORMAL)){
      msg(coordinates, symbol*n)
    }
  end

  def user_input
    win.getch
  end

  def initialize_colors
    colors.times do |i|
      init_pair(i + 1, i, -1)
    end
  end

  def standby
    win.getch
  end
end
