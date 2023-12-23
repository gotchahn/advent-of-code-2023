class Day19
  attr_accessor :workflows, :parts, :queue, :accepted, :rejected
  def initialize(test = false)
    filename = "./public/day19#{test ? '_test' : ''}.txt"
    @puzzle = File.read(filename).split("\n\n")
  end

  def self.go(test = false)
    day = Day19.new(test)
    day.factory
  end

  def factory
    @accepted = []
    @rejected = []
    build_workflows
    build_parts
    start_queue
    start_inventory
    extract_accepted_total
  end

  def build_workflows
    @workflows = {}
    raw_workflows = @puzzle[0].split("\n")

    raw_workflows.each do |raw_workflow|
      w = Workflow.new(raw_workflow)
      @workflows[w.name] = w
    end
    # puts "\n\nWorkflows:\n#{@workflows}\n\n"
  end

  def build_parts
    # {x=787,m=2655,a=1222,s=2876}
    @parts = []
    raw_parts = @puzzle[1].split("\n")

    raw_parts.each do |raw_part|
      first_bracket = raw_part.index('{')
      last_bracket = raw_part.index('}')
      extraction = raw_part[(first_bracket+1)..(last_bracket-1)].split(',')

      part_hash = {}
      extraction.each do |part|
        vals = part.split('=')
        part_hash[vals[0]] = vals[1].to_i
      end
      @parts.push(part_hash)
    end
    # puts "\n\nParts:\n#{@parts}\n\n"
  end

  def start_queue
    @queue = []
    @parts.each do |part|
      @queue.push({workflow: 'in', part: part})
    end
  end

  def start_inventory
    while @queue.any?
      part_check = @queue.delete_at(0)
      redirect_to = @workflows[part_check[:workflow]].send_to(part_check[:part])
      case redirect_to
      when 'A'
        @accepted.push(part_check[:part]) if redirect_to == 'A'
      when 'R'
        @rejected.push(part_check[:part]) if redirect_to == 'R'
      else
        @queue.push({workflow: redirect_to, part: part_check[:part]})
      end
    end
    # puts "Accepted #{@accepted}"
  end

  def extract_accepted_total
    sum = 0
    @accepted.each do |accepted|
      accepted.values.each do |val|
        sum += val
      end
    end
    puts "Total: #{sum}"
  end

  class Workflow
    attr_accessor :name, :rules

    def initialize(raw_input)
      build_rules(raw_input)
    end

    def build_rules(raw_input)
      @rules = []
      first_bracket = raw_input.index('{')
      last_bracket = raw_input.index('}')
      @name = raw_input[0..(first_bracket-1)]
      raw_rules = raw_input[(first_bracket+1)..(last_bracket-1)].split(',')
      raw_rules.each do |rule|
        @rules.push(rule)
      end
    end

    def send_to(parts)
      # px{a<2006:qkq,m>2090:A,rfg}
      @rules.each do |rule|
        if rule.index(':')
          if rule.index('>')
            vals = rule.split('>')
            var = vals[0]
            vals2 = vals[1].split(':')
            amount = vals2[0].to_i
            return vals2[1] if parts[var] && parts[var] > amount
          else
            vals = rule.split('<')
            var = vals[0]
            vals2 = vals[1].split(':')
            amount = vals2[0].to_i
            return vals2[1] if parts[var] && parts[var] < amount
          end
        else
          return rule
        end
      end
    end
  end
end