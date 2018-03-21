#!/usr/bin/env ruby

class UserInputController
  def initialize options
    @options = options
    @charscreen_actions = {
      'm' => :mainscreen
    }
    @mainscreen_actions = {
      'c' => :charscreen,
      Curses::KEY_UP => :up,
      Curses::KEY_DOWN => :down,
      Curses::KEY_LEFT => :left,
      Curses::KEY_RIGHT => :right,
      'q' => :quit
    }
  end

  def get_action ch
    instance_variable_get("@#{options[:gamestate]}_actions")[ch]
  end

  private

  attr_reader :options

end
