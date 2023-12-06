class Day6
  include Spliteable
  attr_accessor :times, :distances

  def initialize(test = false)
    @puzzle = self.class.day_input(6, test)
    build_games
  end

  def self.go(test = false)
    day = Day6.new(test)
    day.possible_winners
    day.winning2
  end

  def possible_winners
    multi = 1
    @times.each_with_index do |time, pos|
      max = 0
      for s in 1..(time-1) do
        d = (time - s) * s
        max += 1 if d > @distances[pos]
      end
      multi *= max
    end
    puts "Ways rate: #{multi}"
  end

  def winning2
    time = @times.join('').to_i
    distance = @distances.join('').to_i
    max = 0
    for s in 1..(time-1) do
      d = (time - s) * s
      max += 1 if d > distance
    end
    puts "Ways rate: #{max}"
  end

  private

  def build_games
    @times = @puzzle[0].split('Time:')[1].split(" ").map(&:to_i)
    @distances = @puzzle[1].split('Distance:')[1].split(" ").map(&:to_i)
  end
end