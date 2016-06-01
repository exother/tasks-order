require "rails_helper"

RSpec.describe Task, type: :model do
  describe 'creating collection from string' do
    it 'passes when one line' do
      string_to_parse = "A => B"
      expect{Task.create_from_string(string_to_parse)}.not_to raise_error
    end

    it 'passes when more lines' do
      string_to_parse = "A => B\nC => D"
      expect{Task.create_from_string(string_to_parse)}.not_to raise_error
    end

    it 'passes when correct format' do
      string_to_parse = "A => B"
      expect{Task.create_from_string(string_to_parse)}.not_to raise_error
    end

    it 'fails when invalid format' do
      string_to_parse = "A => B =>"
      expect{Task.create_from_string(string_to_parse)}.to raise_error('invalid format')
    end

    it 'passes when the second element missing' do
      string_to_parse = "A => "
      expect{Task.create_from_string(string_to_parse)}.not_to raise_error
    end

    it 'fails when the first element missing' do
      string_to_parse = " => A"
      expect{Task.create_from_string(string_to_parse)}.to raise_error('invalid format')
    end

    it 'fails when first element has more than one character' do
      string_to_parse = "AB => B"
      expect{Task.create_from_string(string_to_parse)}.to raise_error('invalid format')
    end

    it 'fails when second element has more than one character' do
      string_to_parse = "A => BA"
      expect{Task.create_from_string(string_to_parse)}.to raise_error('invalid format')
    end
  end

  describe 'ordering collection' do
    it 'fails when task depend on themself' do
      string_to_parse = "A => A"
      collection = Task.create_from_string(string_to_parse)
      expect{Task.order(collection)}.to raise_error('self dependency')
    end

    it 'fails when there is a circular dependency' do
      string_to_parse = "A => \nB => C\nC => F\nD => A\nE => \nF => B"
      collection = Task.create_from_string(string_to_parse)
      expect{Task.order(collection)}.to raise_error('circular dependency')
    end

    it 'returns single job when one job given' do
      a = Task.new(name: "a")
      collection = [a]
      expect(Task.order(collection)).to eq([a])
    end

    it 'returns proper sequence when some jobs, one dependency' do
      a = Task.new
      b = Task.new
      c = Task.new
      b.next << c
      collection = [a,b,c]
      ordered = Task.order(collection)

      expect(ordered.index(b)).to be < ordered.index(c)
    end

    it 'return proper sequence when many jobs and many dependencies' do
      a = Task.new
      b = Task.new
      c = Task.new
      d = Task.new
      e = Task.new
      f = Task.new
      b.next << c
      c.next << f
      d.next << a
      e.next << b
      collection = [a,b,c,d,e,f]
      ordered = Task.order(collection)

      expect(ordered.index(b)).to be < ordered.index(c)
      expect(ordered.index(c)).to be < ordered.index(f)
      expect(ordered.index(d)).to be < ordered.index(a)
      expect(ordered.index(e)).to be < ordered.index(b)
    end
  end
end