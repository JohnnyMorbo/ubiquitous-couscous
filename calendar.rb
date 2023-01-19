#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json/ext'

# shamelessly stolen from https://xkcd.com/1930
# call Calendar.new.to_text
class Calendar
  def initialize
    @parts = JSON.parse(File.read("#{__dir__}/calendar.json"))
  end

  private

  def allstrings(list_of_things)
    list_of_things.each do |thing|
      return false unless thing.is_a? String
    end
    return true
  end

  def allarrays(list_of_things)
    list_of_things.each do |thing|
      return false unless thing.is_a? Array
    end
    return true
  end

  def stepper(phrase)
    output = +''
    case phrase
    when String
      output.concat(" #{phrase}")
    when Array
      if allstrings(phrase)
        output.concat(" #{phrase.sample}")
      elsif allarrays(phrase)
        output.concat(stepper(phrase.sample))
      else # Array with a mish-mash of parts
        phrase.each do |part|
          case part
          when String
            output.concat(" #{part}")
          when Array
            output.concat(stepper(part))
          end
        end
      end
    end
    return output
  end

  def assembler
    # parts = JSON.parse(File.read("#{__dir__}/calendar.json"))
    output = [
      @parts['PHRASES'][0],
      stepper(@parts['FACTS'].sample),
      stepper(@parts['FACTS_SECOND'].sample),
      ' ',
      @parts['PHRASES'][1],
      stepper(@parts['BECAUSES'].sample),
      @parts['PHRASES'][2],
      stepper(@parts['APPARENTLYS'].sample)
    ].join
    return output + "#{@parts['PHRASES'][3]} #{@parts['TRIVIA'].sample}" if rand(5).zero?
    return output
  end

  public

  def to_text
    assembler
  end

  def to_html
    assembler.gsub("\n", "<br>\n")
  end
end
