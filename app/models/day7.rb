class Day7
  include Spliteable
  attr_accessor :hands, :rank

  STRENGTHS = {
    'A' => 13,
    'K' => 12,
    'Q' => 11,
    'J' => 10,
    'T' => 9,
    '9' => 8,
    '8' => 7,
    '7' => 6,
    '6' => 5,
    '5' => 4,
    '4' => 3,
    '3' => 2,
    '2' => 1
  }

  def initialize(test = false)
    @puzzle = self.class.day_input(7, test)
    @hands = {}
  end

  def self.go(test = false)
    day = Day7.new(test)
    day.part1
  end

  def part1
    build_hands
    total_winning
  end

  def build_hands
    @puzzle.each do |line|
      info = line.split(' ')
      hand_txt = info[0]
      bid = info[1].to_i

      hand = hand_txt.chars
      hand_count = hand.uniq.length

      case hand_count
      when 1
        # five kind
        add_to_hand(:five_kinds, hand, bid)
      when 2
        # Four Kind or Full House
        first_char_count = hand.count(hand[0])
        case first_char_count
        when 4,1
          # five kind
          add_to_hand(:four_kinds, hand, bid)
        else
          # Full House
          add_to_hand(:full_houses, hand, bid)
        end
      when 3
        # Three or 2 pair
        pos = 0
        char_count = 0

        loop do
          char_count = hand.count(hand[pos])
          break if char_count > 1
          pos += 1
        end

        case char_count
        when 3
          # Three kind
          add_to_hand(:three_kinds, hand, bid)
        else
          # 2 pair
          add_to_hand(:two_kinds, hand, bid)
        end
      when 4
        # One Pair
        add_to_hand(:one_kinds, hand, bid)
      else
        # High Card
        add_to_hand(:high_cards, hand, bid)
      end
    end
  end

  def total_from_hand(hand_name)
    return 0 unless @hands[hand_name].present?
    total = 0
    sorted_hand = @hands[hand_name].sort{ |h1, h2| sort_hand(h1,h2) }
    puts "Sorted #{hand_name} hand: #{sorted_hand}"
    sorted_hand.each do |hand|
      total += hand[:bid] * @rank
      puts "#{hand[:bid]} * #{@rank} = #{total}"
      @rank += 1
    end
    total
  end

  def total_winning
    total = 0
    @rank = 1
    total += total_from_hand(:high_cards)
    total += total_from_hand(:one_kinds)
    total += total_from_hand(:two_kinds)
    total += total_from_hand(:three_kinds)
    total += total_from_hand(:full_houses)
    total += total_from_hand(:four_kinds)
    total += total_from_hand(:five_kinds)
    puts "Total Winning: #{total}"
  end

  private

  def sort_hand(h1, h2)
    hand1 = h1[:hand]
    hand2 = h2[:hand]
    pos = 0
    while pos < hand1.length
      s1 = STRENGTHS[hand1[pos]]
      s2 = STRENGTHS[hand2[pos]]
      return 1 if s1 > s2
      return -1 if s1 < s2
      pos += 1
    end
    0
  end

  def add_to_hand(hand_name, hand, bid)
    @hands[hand_name] ||= []
    @hands[hand_name].push({bid: bid, hand: hand})
  end
end