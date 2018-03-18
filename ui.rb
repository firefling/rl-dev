#!/usr/bin/env ruby

class UI
  include Curses

  def initialize
    noecho # do not print characters the user types
    init_screen
    start_color
    use_default_colors
    initialize_colors
  end

  def close
    close_screen
  end

  def clear
    super
  end

  def message(y, x, string)
    x = x + cols if x < 0
    y = y + lines if y < 0

    setpos(y, x) # place the cursor at our position
    addstr(string) # prints a string at cursor position
  end

  def vertical y, x, length, char='|'
    length.times do |i|
      message(i+y, x, char)
    end
  end

  def horizontal y, x, length, char='-'
    length.times do |i|
      message(y, i+x, char)
    end
  end

  def rectangle y, x, width, height, color=8
    attron(color_pair(color)){
      horizontal(y, x, width + 2)
      horizontal(y + height + 1, x, width + 2)
      vertical(y + 1, x, height)
      vertical(y + 1, x + width + 1, height)
    }
  end

  def print_table hash, y, x, just=:none, interline=1, separator=':'
    line = y
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
      message(line,
              x + left_indent,
              key.to_s.capitalize + separator + ' '*centre_indent + value.to_s)
      line += interline
    end
  end

  def choice_prompt(y, x, string, choices)
    message(y, x, string + " ")

    loop do
      choice = getch
      return choice if choices.include?(choice)
    end
  end

  def draw_terrain y, x, symbol, n=1, color=8, bold=false
    # color = Object.const_get('Curses::'+c)
    attron(color_pair(color)|(bold ? A_BOLD : A_NORMAL)){
      message(y, x, symbol*n)
    }
  end

  def initialize_colors
    colors.times do |i|
      init_pair(i + 1, i, -1)
    end
    # init_pair(COLOR_CYAN,6,COLOR_BLACK)
    # init_pair(COLOR_GREEN,2,COLOR_BLACK)
    # init_pair(COLOR_YELLOW,3,COLOR_BLACK)
    # init_pair(COLOR_BLUE,4,COLOR_BLACK)
    # init_pair(COLOR_RED,1,COLOR_BLACK)
    # init_pair(COLOR_WHITE,7,COLOR_BLACK)
    # init_color(5, 0, 100, 100)
    # init_pair(5,5,2)
  end

  def standby
    getch
  end
end
