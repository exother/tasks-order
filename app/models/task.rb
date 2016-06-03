class Task
  include ActiveModel::Model

  attr_accessor :name
  attr_accessor :next

  def initialize(*args)
    @next ||= []
    super
  end

  class << self

    # Creates collection of tasks from the given string, sets 'next' elements
    def create_from_string(string_to_parse)
      collection = {}

      string_to_parse.each_line do |line|
        parsed_line = parse_line(line)
        collection[parsed_line.first] ||= Task.new(name: parsed_line.first)
        collection[parsed_line.first].next ||= []

        unless parsed_line.second.empty?
          collection[parsed_line.second] ||= Task.new(name: parsed_line.second)
          collection[parsed_line.first].next << collection[parsed_line.second]
        end
      end

      collection.values
    end

    def order(tasks)
      queue = []
      in_deg = {}
      final_order = []

      # Update inner degrees
      tasks.each do |task|
        in_deg[task] ||= 0
        task.try(:next).each do |next_task|
          raise 'self dependency' if task == next_task
          in_deg[next_task] ||= 0
          in_deg[next_task] += 1
        end
      end

      # Init queue with zero-in-degree tasks
      tasks.each do |task|
        queue.push(task) if in_deg[task] == 0
      end

      # Proccess zer-in-degree tasks one by one
      while queue.present?
        task = queue.pop
        task.try(:next).each do |next_task|
          in_deg[next_task] -= 1
          queue.push(next_task) if in_deg[next_task] == 0
        end
        final_order << task
      end

      raise 'circular dependency' if final_order.size < tasks.size

      final_order.reverse
    end

    def print_collection(tasks)
      output = ""
      tasks.each do |task|
        output << task.name
      end
      output
    end

    private

    def parse_line(line)
      line = line.scan(/^(\S{1})\s*=>\s*(\S{0,1})$/)
      raise 'invalid format' unless line.present?
      line.first
    end

  end
end