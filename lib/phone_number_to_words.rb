require 'phone_number_to_words/version'
ERROR_MSG = "Can't generate words: As length may be greater or lesser than 10 (or) phone number has 0 or 1 values".freeze
module PhoneNumberToWords
  class Convert
    attr_accessor :number_key_mapping, :dictionary
    def initialize
      @number_key_mapping = {
        '2' => %w[a b c],
        '3' => %w[d e f],
        '4' => %w[g h i],
        '5' => %w[j k l],
        '6' => %w[m n o],
        '7' => %w[p q r s],
        '8' => %w[t u v],
        '9' => %w[w x y z]
      }
      @dictionary = load_dictionary
    end

    def load_dictionary
      words = {}
      File.foreach('lib/dictionary.txt') do |word|
        word = word.chop.to_s.downcase
        if words[word.length]
          words[word.length] << word
        else
          words[word.length] = [word]
        end
      end
      words
    end

    def is_valid_no(phone_no)
      phone_no.match(/^[2-9]*$/).to_s.length == 10
    end

    def generate_words(phone_number)
      return ERROR_MSG unless is_valid_no(phone_number)
      character_arrays = phone_number.chars.map { |digit| number_key_mapping[digit] }
      character_arrays_lng = character_arrays.length - 1
      results = []
      compared_hash = {}
      for i in (2..character_arrays_lng - 2)
        temp_split_array = []
        temp_split_array << character_arrays[0..i]
        next if temp_split_array.first.length < 3
        temp_split_array << character_arrays[i + 1..character_arrays_lng]
        next if temp_split_array.last.length < 3
        temp_combinate_array = []
        temp_combinate_array << temp_split_array.first.shift.product(*temp_split_array.first).map(&:join)
        next if temp_combinate_array.first.nil?
        temp_combinate_array << temp_split_array.last.shift.product(*temp_split_array.last).map(&:join)
        next if temp_combinate_array.last.nil?
        compared_hash[i] = [(temp_combinate_array.first & dictionary[i + 1]), (temp_combinate_array.last & dictionary[character_arrays_lng - i])]
        compared_hash[i].first.product(compared_hash[i].last).each do |words|
          results << words
        end
      end
      results << (character_arrays.shift.product(*character_arrays).map(&:join) & dictionary[10]).join(', ')
    end
  end
end
