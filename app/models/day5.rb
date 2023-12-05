class Day5
  include Spliteable
  attr_accessor :seeds, :maps, :min

  def initialize(test = false)
    @puzzle = self.class.day_input(5, test).join("\n")
    @seeds = @puzzle.split("seeds:")[1].split("\n")[0].split(" ").map(&:to_i)
    mapping
  end

  def self.go(test = false)
    day = Day5.new(test)
    puts "Min location 1: #{day.min_location_part1}"
    day.min_location_part2
    puts "Min location 2: #{day.min}"
  end

  def min_location_part1
    locations = []
    seeds.each do |seed|
      locations.push(location_of(seed))
    end
    locations.min
  end

  def min_location_part2
    pos = 0
    while pos < seeds.length
      init_seed = seeds[pos]
      pos += 1
      limit = seeds[pos]
      pos += 1

      quarter = limit/4
      seed2 = init_seed + quarter
      seed3 = seed2 + quarter
      end_seed = init_seed + limit

      location1 = location_of(init_seed)
      location2 = location_of(seed2)
      location3 = location_of(seed3)
      location4 = location_of(end_seed)

      min_location = [location1, location2, location3, location4].min
      if pos == 2
        # the first
        @min = min_location
      else
        if min_location < @min
          @min = min_location
          puts "Location #{min_location} is the new min"
        end
      end

      if min_location == location1
        min_location_part2_helper(init_seed, quarter)
      elsif min_location == location2
        min_location_part2_helper(seed2, quarter)
      elsif min_location == location3
        min_location_part2_helper(seed3, quarter)
      end

      puts "\n\nCompleted Set: #{(pos+1)/2}\n\n"
    end
  end


  def min_location_part2_helper(init_seed, limit)
    for s in 0..(limit - 1) do
      location = location_of(init_seed + s)
      if location < @min
        @min = location
        puts "Location #{location} is the new min"
      end
    end
  end

  def destination_of(map_name, source)
    maps[map_name].each do |set|
      if source >= set[:init_source] && source <= set[:end_source]
        return source - set[:init_source] + set[:destination]
      end
    end
    return source
  end

  def location_of(seed)
    soil = destination_of(:seed_to_soil, seed)
    fertilizer = destination_of(:soil_to_fertilizer, soil)
    water = destination_of(:fertilizer_to_water, fertilizer)
    light = destination_of(:water_to_light, water)
    temperature = destination_of(:light_to_temperature, light)
    humidity = destination_of(:temperature_to_humidity, temperature)
    destination_of(:humidity_to_location, humidity)
  end

  private

  def parse_map(map_name, following_map = "")
    map = []
    lines = @puzzle.split(map_name)[1].gsub(/^\n/, "")
    lines = lines.split(following_map)[0] if following_map.present?
    lines = lines.split("\n")

    lines.each do |line|
      vals = line.split(" ").map(&:to_i)
      destination = vals[0]
      init_source = vals[1]
      end_source = init_source + vals[2] - 1
      map.push({destination: destination, init_source: init_source, end_source: end_source})
    end
    map
  end

  def mapping
    @maps = {}
    @maps[:seed_to_soil] = parse_map("seed-to-soil map:", "soil-to-fertilizer map:")
    @maps[:soil_to_fertilizer] = parse_map("soil-to-fertilizer map:", "fertilizer-to-water map:")
    @maps[:fertilizer_to_water] = parse_map("fertilizer-to-water map:", "water-to-light map:")
    @maps[:water_to_light] = parse_map("water-to-light map:", "light-to-temperature map:")
    @maps[:light_to_temperature] = parse_map("light-to-temperature map:", "temperature-to-humidity map:")
    @maps[:temperature_to_humidity] = parse_map("temperature-to-humidity map:", "humidity-to-location map:")
    @maps[:humidity_to_location] = parse_map("humidity-to-location map:")
  end
end