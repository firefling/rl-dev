#!/usr/bin/env ruby

class Game

  STATES = [:dead, :playscreen, :eqscreen, :charscreen]

  def initialize
    @ui = UI.new
    @options = { quit: false, randall: false, initial_y: 22, initial_x: 1 }
    @maps = Maps.new
    @options[:initial_map] = 'world'
    @options[:current_map] = maps[options[:initial_map]].load(ui)
    @options[:gamestate] = :playscreen
    @display = Display.new(ui, options)
    at_exit { ui.close; pp options } # runs at program exit
  end

  def run
    title_screen
    setup_character
    display.render_mainscreen

    while (ch = ui.user_input)
      case get_gamestate
      when :playscreen
        set_gamestate(:charscreen) if ch == 'c'
      when :charscreen
        set_gamestate(:playscreen) if ch == 'm'
      else
      end
      display.render
    end
    # play_screen.render_map
    # play_screen.render_player
    # while (ch = ui.user_input)
    #   if (258..261).include?(ch)
    #     play_screen.render_tile(options[:player].coordinates.y, options[:player].coordinates.x)
    #     case ch
    #     when 258
    #       options[:player].coordinates.y += 1 if not options[:player].coordinates.y + 1 >= options[:current_map].height and options[:current_map].terrain_info(options[:player].coordinates.y + 1, options[:player].coordinates.x).walkable
    #     when 259
    #       options[:player].coordinates.y -= 1 if not options[:player].coordinates.y - 1 < 0 and options[:current_map].terrain_info(options[:player].coordinates.y - 1, options[:player].coordinates.x).walkable
    #     when 260
    #       options[:player].coordinates.x -= 1 if not options[:player].coordinates.x - 1 < 0 and options[:current_map].terrain_info(options[:player].coordinates.y, options[:player].coordinates.x - 1).walkable
    #     when 261
    #       options[:player].coordinates.x += 1 if not options[:player].coordinates.x + 1 >= options[:current_map].width and options[:current_map].terrain_info(options[:player].coordinates.y, options[:player].coordinates.x + 1).walkable
    #     end
    #     play_screen.render_player
    #   end
    # end
  end

  private

  TRAITS = [Role, Race, Gender, Alignment]

  attr_reader :ui, :options, :maps, :display

  def get_gamestate
    options[:gamestate]
  end

  def set_gamestate state
    options[:gamestate] = state
  end

  def title_screen
    TitleScreen.new(ui, options).render
    quit?
  end

  def quit?
    exit if options[:quit]
  end

  def setup_character
   get_traits
   options[:player] = make_player
  end

  def get_traits
    TRAITS.each do |trait|
      SelectionScreen.new(trait, ui, options).render
      quit?
    end
  end

  def make_player
    Player.new(ui, options).tap do
      %i(role race gender alignment).each{ |key| options.delete(key) }
    end
  end

  # def select_item
  #   SelectionScreen.new(Weapon, ui, options).render
  #   quit?
  # end

  def character_screen
    CharacterScreen.new(ui, options).render
  end

end
