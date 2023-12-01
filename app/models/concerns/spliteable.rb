module Spliteable
  extend ActiveSupport::Concern

  class_methods do
    def puzzle(raw_input)
      raw_input.split("\n")
    end
  end
end