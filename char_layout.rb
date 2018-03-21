#!/usr/bin/env ruby

class CharLayout
  def initialize ui, options
    @ui = ui
    @options = options
  end

  def render
    yx = YX.new(2,25)
    ui.clear
    ui.msg(yx, 'PLAYER CHARACTER')
    ui.print_table({gender:  @options[:player].gender.name,
                     race: @options[:player].race.name,
                     class: @options[:player].role.name,
                     alignment:  @options[:player].alignment.name}, yx += [3,-15], :left, 2) # 5, 10
    ui.msg(yx += [8,0], 'Attributes:') # YX.new(13, 10)
    ui.print_table(@options[:player].attributes, yx += [2,3], :right, 2) # 15, 13
  end

  private

  attr_reader :ui, :options
end
