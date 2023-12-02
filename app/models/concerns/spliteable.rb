module Spliteable
  extend ActiveSupport::Concern

  class_methods do
    def puzzle(raw_input)
      raw_input.split("\n")
    end

    def day_input(day, test = false)
      filename = "./public/day#{day}#{test ? '_test' : ''}.txt"
      File.read(filename).split("\n")
    end
  end
end