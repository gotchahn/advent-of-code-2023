class Day3
  include Spliteable

  def initialize(test = false)
    @puzzle = self.class.day_input(3, test)
  end

  def self.go_test
    day3 = Day3.new(true)
    puts "Sum parts: #{day3.sum_parts}"
    puts "Ratio: #{day3.sum_ratio_gears}"
  end

  def self.go
    day3 = Day3.new
    puts "Sum parts: #{day3.sum_parts}"
    puts "Ratio: #{day3.sum_ratio_gears}"
  end

  def sum_parts
    sum = 0
    @puzzle.each_with_index do |line, row_index|
      # Extract all the numbers
      nums = line.split(/[^\d]/)
      nums.delete("")

      if nums
        # there is numbers! Check each
        removed = 0
        nums.each do |num|
          puts "Analyzing #{num}"
          num_index = line.index(num)
          if symbol_left?(line, num_index - 1) ||
            symbol_right?(line, num_index + num.length) ||
            symbol_in_other_line?(num_index + removed, num.length, row_index - 1) ||
            symbol_in_other_line?(num_index + removed, num.length, row_index + 1)
            # is a part!
            sum += num.to_i
          end
          line = line[(num_index+num.length)..(line.length - 1)]
          removed += num_index + num.length
        end
      end
    end
    sum
  end

  def sum_ratio_gears
    sum = 0
    @puzzle.each_with_index do |line, row_index|
      # Extract all the *
      asterisks = line.split(/[^\*]/)
      asterisks.delete("")

      if asterisks
        # there is numbers! Check each
        removed = 0
        asterisks.each do |ast|
          num_index = line.index(ast)
          num_left = number(row_index, num_index + removed - 1)
          num_right = number(row_index, num_index + removed + 1)
          num_above = number(row_index - 1, num_index + removed)
          num_down = number(row_index + 1, num_index + removed)
          num_d_up_left = nil
          num_d_up_right = nil
          unless num_above
            num_d_up_left = number(row_index - 1, num_index + removed - 1)
            num_d_up_right = number(row_index - 1, num_index + removed + 1)
          end
          num_d_down_left = nil
          num_d_down_right = nil
          unless num_down
            num_d_down_left = number(row_index + 1, num_index + removed - 1)
            num_d_down_right = number(row_index + 1, num_index + removed + 1)
          end
          nums = [num_left, num_right, num_above, num_down, num_d_up_left, num_d_up_right, num_d_down_left, num_d_down_right].compact
          puts "Nums found #{nums}"
          if nums.length == 2
            sum += nums.map{|n| n.to_i}.inject(:*)
          end
          line = line[(num_index+1)..(line.length - 1)]
          removed += num_index + 1
        end
      end
    end
    sum
  end

  private

  def symbol_left?(line, index)
    left = index >= 0 && symbol?(line[index])
    left
  end

  def symbol_right?(line, index)
    right = symbol?(line[index])
    right
  end

  def symbol_in_other_line?(index, num_length, row_index)
    return false if row_index < 0
    return false if row_index == @puzzle.length

    line = @puzzle[row_index]
    init = index == 0 ? 0 : index - 1
    stop = index + num_length

    for pos in init..stop do
      return true if symbol?(line[pos])
    end
    false
  end

  def symbol?(element)
    element.present? && element != '.' && !element.match?(/[[:digit:]]/)
  end

  def number(row_index, pos)
    return nil if row_index < 0
    return nil if row_index == @puzzle.length

    line = @puzzle[row_index]
    return nil if pos < 0
    return nil if pos == line.length
    return nil unless line[pos].match?(/[[:digit:]]/)

    init = pos
    while line[init].present? && line[init].match?(/[[:digit:]]/)
      init -= 1
    end
    stop = pos
    while line[stop].present? && line[stop].match?(/[[:digit:]]/)
      stop += 1
    end
    num = line[(init+1)..(stop-1)]
    puts "Num found: #{num}"
    num
  end
end