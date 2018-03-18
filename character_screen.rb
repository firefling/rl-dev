#!/usr/bin/env ruby

class CharacterScreen
  def initialize(ui, options)
    @ui = ui
    @options = options
  end

  def render
    ui.clear
    ui.message(2, 25, 'PLAYER CHARACTER')
    ui.print_table({gender:  @options[:player].gender.name,
                     race: @options[:player].race.name,
                     class: @options[:player].role.name,
                     alignment:  @options[:player].alignment.name}, 5, 10, :left, 2)
    ui.message(13, 10, 'Attributes:')
    ui.print_table(@options[:player].attributes, 15, 13, :right, 2)
    ui.standby
  end

  private

  attr_reader :ui, :options

end
