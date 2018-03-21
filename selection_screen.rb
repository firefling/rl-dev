#!/usr/bin/env ruby

class SelectionScreen
  def initialize(trait, ui, options)
    @items = trait.for_options(options)

    @ui = ui
    @options = options

    @key = trait.name.downcase.to_sym
    @messages = Messages[key]
  end

  def render
    if random?
      options[key] = random_item
    else
      render_screen
    end
  end

  private

  attr_reader :items, :ui, :options, :key, :messages

  def random?
    options[:randall] or items.length == 1
  end

  def random_item
    items.sample
  end

  def render_screen
    xy = YX.new(0, 0)
    ui.clear
    ui.msg(xy, messages[:choosing])
    ui.msg(xy.right(right_offset), instructions)
    render_choices
    handle_choice(prompt)
  end

  def instructions
    @instructions ||= interpolate(messages[:instructions])
  end

  def interpolate message
    message.gsub(/%(\w+)/){ options[$1.to_sym] }
  end

  def right_offset
    @right_offset ||= (instructions.length + 2) * -1
  end

  def render_choices
    items.each_with_index do |item, index|
      ui.msg(YX.new(index + 2, right_offset), "#{item.hotkey} - #{item}")
    end

    ui.msg(YX.new(items.length + 2, right_offset), '* - Random')
    ui.msg(YX.new(items.length + 3, right_offset), 'q - Quit')
  end

  def handle_choice choice
    case choice
    when 'q' then options[:quit] = true
    when '*' then options[key] = random_item
    else options[key] = item_for_hotkey(choice)
    end
  end

  def item_for_hotkey hotkey
    items.find{ |item| item.hotkey == hotkey }
  end

  def prompt
    ui.choice_prompt(YX.new(items.length + 4, right_offset), '(end)', hotkeys)
  end

  def hotkeys
    items.map(&:hotkey).join + '*q'
  end
end
