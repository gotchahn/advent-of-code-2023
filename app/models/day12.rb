class Day12
  include Spliteable

  def initialize(test = false)
    @puzzle = self.class.day_input(12, test)
  end

  def self.go(part, test = false)
    day = Day12.new(test)
    day.combinations(part)
  end

  def combinations(part = 1)
    sum = 0
    @saved_combinations = {}
    @puzzle.each_with_index do |row, index|
      total = 0
      info = row.split(' ')
      map = info[0]
      damages = info[1].split(',').map(&:to_i)
      total_damaged = damages.sum

      #map = refine_map(map.deep_dup, damages)
      total_marked = map.count('#')
      total_unknow = map.count('?')
      total_missing = total_damaged - total_marked

      if total_missing == 0
        total = 1
      else
        combination_txt = ''
        combination_txt += '#' * total_missing
        combination_txt += '.' * (total_unknow - total_missing)
        combination_key = "combination#{combination_txt.length}"

        if @saved_combinations[combination_key]
          puts "Using Saved combination"
          combinations = @saved_combinations[combination_key]
        else
          combinations = permutation(combination_txt.length)
          @saved_combinations[combination_key] = combinations
        end

        if part == 2
          map = ([map] * 5).join('?')
          damages *= 5
          combinations = part2_combination(combinations)
        end
        puts "#{map} #{damages.join(' ')}"

        # start testing
        combinations.each do |combination|
          test_map = map.deep_dup
          combination.chars.each do |val|
            index_of_unknown = test_map.index('?')
            test_map[index_of_unknown] = val
          end

          test_map_splitted = test_map.split('.')
          test_map_splitted.delete('')
          test_map_size = test_map_splitted.map(&:size)

          if test_map_size == damages
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

  def permutation(total)
    arr = %w[# .]
    (1..total).to_a.flat_map { |i| arr.repeated_permutation(i).map(&:join) }.uniq.select{|c|c.size == total}
  end

  def part2_combination(combinations)
    new_larged = []
    combinations = combinations.map{|c| ([c]*5).join('?')}
    @four_com ||= permutation(4)

    combinations.each do |comb|
      @four_com.each do |four_val|
        test_comb = comb.deep_dup
        four_val.chars.each do |val|
          index_of_unknown = test_comb.index('?')
          test_comb[index_of_unknown] = val
        end
        new_larged.push(test_comb)
      end
    end
    new_larged
  end
end