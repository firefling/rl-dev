#!/usr/bin/env ruby

class Game
  def initialize
    @ui = UI.new
    @options = { quit: false, randall: false, initial_y: 22, initial_x: 1 }
    @maps = Maps.new
    @options[:initial_map] = 'world'
    @options[:current_map] = maps[options[:initial_map]].load(ui)
    at_exit { ui.close; pp options } # runs at program exit
  end

  def run
    title_screen
    setup_character
    character_screen

    game_screen = MainLayout.new(ui, options)
    game_screen.render
    game_screen.render_map
    game_screen.render_player

    ui.user_input
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

  attr_reader :ui, :options, :maps

  def player
    options[:player]
  end

  def map
    options[:current_map]
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
