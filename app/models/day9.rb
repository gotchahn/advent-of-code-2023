class Day9
  include Spliteable
  def initialize(test = false)
    @puzzle = self.class.day_input(9, test)
  end

  def self.go(test = false)
    day = Day9.new(test)
    day.parts
  end

  def parts
    sum_past = 0
    sum_future = 0
    @puzzle.each do |history|
      results = next_in_history(history)
      sum_past += results[:past]
      sum_future += results[:future]
    end
    puts "OASIS Past: #{sum_past} - OASIS Future: #{sum_future}"
  end

  def next_in_history(history)
    # code here
    map = []
    nums = history.split(' ').map(&:to_i)
    map.push(nums)

    while nums.find{|v| v!=0 }.present?
      another_set = []
      nums.each_with_index do |v,i|
        break if i == nums.length - 1
        diff = nums[i+1] - nums[i]
        another_set.push(diff)
      end
      map.push(another_set)
      #puts "new set #{another_set}"
      nums = another_set
    end

    pos = map.length - 1
    while pos > 0
      down_set = map[pos]
      up_set = map[pos-1]
      new_value_last = down_set.last + up_set.last
      new_value_first = up_set.first - down_set.first
      map[pos-1].unshift(new_value_first)
      map[pos-1].push(new_value_last)
      pos -= 1
    end
    r = {past: map[0].first, future: map[0].last}
    puts r
    r
  end
end