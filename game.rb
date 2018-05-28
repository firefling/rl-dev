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
    @options[:walkable_indices] = map.layout.chars.map.with_index{ |t, i| (map.walkable_tiles.include?(t) ? i : nil) }.compact

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

  def action_in_mainscreen action
    case action
    when :up, :down, :left, :right
#      new_yx = player.coordinates.add(DIRECTIONS[action])
#      unless map.outside?(new_yx) or not map.terrain_info(new_yx).walkable
      #if monster - attack
      #if npc - talk (on arrows or other keys?)
      #if object - interact (on arrows or other keys?)
      #otherwise - move
      if map.can_move?(player.coordinates, action) and not @options[:monsters][map.yx_to_i(player.coordinates + DIRECTIONS[action])]
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
      random_i = @options[:walkable_indices].sample
      m.set_coordinates(map.i_to_yx(random_i))
      @options[:monsters][random_i] = m
    end
  end

  def move_monsters
    for m in @options[:monsters].compact
      @options[:monsters][map.yx_to_i(m.coordinates)] = nil
      display.render_tile(m.coordinates)
      direction = DIRECTIONS.keys.sample
      direction = m.get_dir_to_follow(player.coordinates) if m.coordinates.dist(player.coordinates) <= 4
      new_yx = m.coordinates + DIRECTIONS[direction]
      if map.can_move?(m.coordinates, direction) and not @options[:monsters][map.yx_to_i(new_yx)] and not new_yx == player.coordinates # what if cannot move? should go in a different direction
          m.move(DIRECTIONS[direction])
      end
      @options[:monsters][map.yx_to_i(m.coordinates)] = m
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
