class Day4
  include Spliteable
  attr_accessor :deck

  def initialize(test = false)
    @puzzle = self.class.day_input(4, test)
    @deck = []
    @puzzle.length.times do |x|
      @deck[x] = 1
    end
  end

  def self.go(test = false)
    Day4.new(test).perform
  end

  def perform
    points = 0
    @puzzle.each_with_index do |card, card_num|
      cards = card.split(':')[1]
      winners = cards.split("|")[0].split(' ')
      own = cards.split("|")[1].split(' ')
      lucky = winners & own
      # part 1 =====
      point = 0
      lucky.each_index do |ind|
        point += ind == 0 ? 1 : point
      end
      points += point
      # ------
      # Part 2 ===
      deck[card_num].times do
        for copy in (card_num + 1)..(card_num + lucky.length) do
          break if copy == @puzzle.length
          @deck[copy] += 1
        end
      end
    end
    puts "Total points: #{points}"
    puts "Total scratchcards #{deck.sum}"
  end
end