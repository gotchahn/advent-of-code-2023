class Day12
  include Spliteable

  def initialize(test = false)
    @puzzle = self.class.day_input(12, test)
  end

  def self.go(test = false)
    day = Day12.new(test)
    day.combinations
  end

  def combinations
    sum = 0
    @puzzle.each_with_index do |row, index|
      total = 0
      info = row.split(' ')
      map = info[0]
      damages = info[1].split(',').map(&:to_i)
      total_damaged = damages.sum


      map = refine_map(map.deep_dup, damages)
      total_marked = map.count('#')
      total_unknow = map.count('?')
      total_missing = total_damaged - total_marked

      if total_missing == 0
        total = 1
      else
        combination_txt = ''
        combination_txt += '#' * total_missing
        combination_txt += '.' * (total_unknow - total_missing)

        #combinations = combination_txt.chars.permutation(total_unknow).to_a.uniq
        combinations = permutation(combination_txt)
        total_combinations = combinations.size

        # start testing
        combinations.each_with_index do |combination, ci|
          puts "Testing combination #{ci+1}/#{total_combinations} for row #{index+1}"
          test_map = map.deep_dup
          combination.chars.each do |val|
            index_of_unknown = test_map.index('?')
            test_map[index_of_unknown] = val
          end

          test_map_splitted = test_map.split('.')
          test_map_splitted.delete('')
          test_map_size = test_map_splitted.map(&:size)

          if test_map_size == damages
            puts "found a combination! #{test_map}"
            total += 1
          end
        end
      end

      puts "total arrangements for row #{index + 1}: #{total}"
      sum += total
    end
    puts "Total Arrangements: #{sum}"
  end

  private

  def refine_map(map, damages)
    first_damaged = damages.first
    last_damaged = damages.last

    #refine first, get the first N (N= first_damaged+1)
    first_str = map[0..first_damaged]
    if first_str.count('#') == first_damaged
      # refine oportunity!
      if map[0] == '?'
        map[0] = '.'
        map[first_damaged+1] = '.'
      elsif map[0] == '#'
        map[first_damaged] = '.'
      end
      puts "Refined first #{map}"
    end

    #refine last, get the last N (N= last_damaged+1)
    end_of_str = map.length - 1
    start_at = end_of_str - last_damaged
    last_str = map[start_at..end_of_str]
    if last_str.count('#') == last_damaged
      # refine oportunity!
      if map[start_at] == '?'
        map[start_at] = '.'
      elsif map[start_at] == '#'
        map[end_of_str] = '.'
      end
      puts "Refined last #{map}"
    end
    map
  end

  def permutation(string)
    return [''] if string.empty?

    (0...string.size).flat_map { |i|
      chr, rest = string[i], string[0...i] + string[i+1..-1]
      permutation(rest).map { |sub|
        chr + sub
      }
    }.uniq
  end
end