#!/usr/bin/env ruby

class Game

  STATES = [:dead, :mainscreen, :eqscreen, :charscreen]

  def initialize
    @ui = UI.new
    @maps = Maps.new
    @options = { quit: false, randall: false, initial_y: 22, initial_x: 1 }
    @options[:initial_map] = 'world'
    @options[:current_map] = maps[options[:initial_map]].load(ui)
    @options[:monsters] = Array.new
    @options[:gamestate] = :mainscreen

    @display = Display.new(ui, options)
    @uicontrol = UserInputController.new(options)

    at_exit { ui.close; pp options } # runs at program exit
  end

  def run

    title_screen
    setup_character

    load_map(options[:initial_map])
    display.render_mainscreen

    while (ch = ui.user_input)
      action = uicontrol.get_action(ch)
      if STATES.include?(action)
        set_gamestate(action)
        display.render
        next
      end
      case get_gamestate
      when :mainscreen
        action_in_mainscreen(action)
        move_monsters
      when :charscreen
        action_in_charscreen(action)
      end
    end

  end

  private

  TRAITS = [Role, Race, Gender, Alignment]

  attr_reader :ui, :options, :maps, :display, :uicontrol

  DIRECTIONS = {
    up: [-1,0],
    down: [1,0],
    left: [0,-1],
    right: [0,1]
  }

  def action_in_mainscreen action
    case action
    when :up, :down, :left, :right
      new_yx = player.coordinates.add(DIRECTIONS[action])
#      unless map.outside?(new_yx) or not map.terrain_info(new_yx).walkable
      if map.can_move?(player.coordinates, action)
        display.render_tile(player.coordinates)
        player.move(DIRECTIONS[action])
        display.render_player
      end
    when :quit
      options[:quit] = true
      quit?
    end
  end

  def action_in_charscreen action
  end

  def load_map map
    @options[:current_map] = maps[map].load(ui)
    generate_monsters
  end

  def generate_monsters
    for m in Monster.all
      @options[:monsters] << m
      m.set_coordinates(YX.new(rand(map.height), rand(map.width)))
    end
  end

  def move_monsters
    for m in @options[:monsters]
      direction = DIRECTIONS.keys.sample
      if map.can_move?(m.coordinates, direction)
        display.render_tile(m.coordinates)
        m.move(DIRECTIONS[direction])
      end
      display.render_monsters
    end
    display.render_monsters
  end

  def player
    options[:player]
  end

  def map
    options[:current_map]
  end

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
