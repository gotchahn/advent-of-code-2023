class Day2
  include Spliteable

  MAXIMUMS = {
    'red' => 12,
    'blue' => 14,
    'green' => 13
  }

  def self.go1
    part1(true)
    part1
  end

  def self.go2
    part2(true)
    part2
  end

  private

  def self.part1(test = false)
    test_input = day_input(2, test)

    game_id = 1
    sum = 0
    test_input.each do |game|
      if not_over_max?(game)
        puts "Game #{game_id} is possible! Adding it to #{sum}"
        sum += game_id
      end
      game_id += 1
    end
    sum
  end

  def self.not_over_max?(game)
    MAXIMUMS.each do |k, max|
      cubes = game.scan(/\d+ #{k}/)
      vals = cubes.map{|v| v.gsub(/[^0-9]/, '').to_i}
      puts "vals for #{k}: #{vals}"
      return false if vals.any?{ |v| v > max }
    end
    true
  end

  def self.part2(test = false)
    test_input = day_input(2, test)

    powerup = 0
    test_input.each do |game|
      powerup += game_power(game)
    end
    powerup
  end

  def self.game_power(game)
    power = 1
    MAXIMUMS.each do |k, max|
      cubes = game.scan(/\d+ #{k}/)
      vals = cubes.map{|v| v.gsub(/[^0-9]/, '').to_i}
      max = vals.max
      puts "max for #{k}: #{max}"
      power *= max
    end
    power
  end
end