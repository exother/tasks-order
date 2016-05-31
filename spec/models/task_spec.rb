require "rails_helper"

RSpec.describe Task, type: :model do
  describe 'creating from string' do
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
end