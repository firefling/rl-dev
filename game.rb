#!/usr/bin/env ruby

class Game
  def initialize
    @ui = UI.new
    @options = { quit: false, randall: false }
    at_exit { ui.close; pp options } # runs at program exit
  end

  def run
    play_screen
    ui.standby
    # title_screen
    # setup_character
    # character_screen
  end

  private

  TRAITS = [Role, Race, Gender, Alignment]

  attr_reader :ui, :options

  def play_screen
    playscreen = PlayScreen.new(ui, options).render
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
    select_item
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

  def select_item
    SelectionScreen.new(Weapon, ui, options).render
    quit?
  end

  def character_screen
    CharacterScreen.new(ui, options).render
  end

end
