class Day11
  include Spliteable

  def initialize(test = false)
    @puzzle = self.class.day_input(10, test)
  end
end