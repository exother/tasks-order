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
      tasks
    end

    private

    def parse_line(line)
      line = line.scan(/(\S+)\s*=>\s*(\S*)/)
      line.first
    end

  end
end