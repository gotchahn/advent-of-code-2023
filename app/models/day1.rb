# frozen_string_literal: true

class Day1
  include Spliteable

  DIGITS = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9'
  }

  def self.go(raw_input)
    sum_puzzle(puzzle(raw_input))
  end

  def self.go2(raw_input)
    sum_puzzle(curated_puzzle2(raw_input))
  end

  private

  def self.sum_puzzle(input)
    sum = 0
    input.each do |line|
      nums = line.gsub(/[^0-9]/, '')
      puts "Adding to #{sum} += #{nums.first}#{nums.last}"
      sum += "#{nums.first}#{nums.last}".to_i
    end
    puts sum
  end

  # this didn't work, don't know why!!
  def self.curated_puzzle(raw)
    new_puzzle = []

    puzzle(raw).each do |line|
      puts "original: #{line}"

      while digit_available = first_digit(line)
        #puts "replacing #{digit_available} with #{DIGITS[digit_available]}"
        line = line.gsub(digit_available, DIGITS[digit_available])
      end

      puts "new line: #{line}"
      new_puzzle.push(line)
    end
    new_puzzle
  end

  def self.curated_puzzle2(raw)
    new_puzzle = []

    puzzle(raw).each do |line|
      puts "original: #{line}"

      DIGITS.each do |key, value|
        line = line.gsub(key,"#{key}#{value}#{key}")
      end

      puts "new line: #{line}"
      new_puzzle.push(line)
    end
    new_puzzle
  end

  def self.first_digit(line)
    analyze = {}
    indexes = []

    DIGITS.keys.each do |digit|
      index = line.index(digit)
      if index && !indexes.include?(index)
        indexes.push(index)
        analyze[index] = digit
      end
    end
    analyze[indexes.min]
  end
end
