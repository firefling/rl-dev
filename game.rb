#!/usr/bin/env ruby

class Game
  def initialize
    @ui = UI.new
    @options = { quit: false, randall: false, initial_map: 'world', initial_x: 0, initial_y: 0 }
    @play_screen = PlayScreen.new(ui, options)
    @player_controller = PlayerController.new(ui, options)
    at_exit { ui.close; pp options } # runs at program exit
  end

  def run
    title_screen
    setup_character
#    character_screen

    play_screen.render
    play_screen.load_initial_map
#    player_controller.render
    ui.standby
  end

  private

  TRAITS = [Role, Race, Gender, Alignment]

  attr_reader :ui, :options, :play_screen, :player_controller

  def title_screen
    TitleScreen.new(ui, options).render
    quit?
  end

  def quit?
    exit if options[:quit]
  end

  def setup_character
    get_traits
#    select_item
    options[:player] = make_player
  end

  def get_traits
    TRAITS.each do |trait|
      SelectionScreen.new(trait, ui, options).render
      quit?
    end
  end

  def make_player
    Player.new(options).tap do
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
