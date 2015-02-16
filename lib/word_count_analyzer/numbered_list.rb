module WordCountAnalyzer
  class NumberedList
    # Rubular: http://rubular.com/r/RKmRH9Y4oO
    NUMBERED_LIST_REGEX = /(?<=\s)\d{1,2}\.(?=\s)|^\d{1,2}\.(?=\s)|(?<=\s)\d{1,2}\.\)|^\d{1,2}\.\)/

    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def includes_numbered_list?
      !(string !~ NUMBERED_LIST_REGEX) && has_at_least_two_items?
    end

    def replace
      new_string = string.dup
      list_array = string.scan(NUMBERED_LIST_REGEX).map(&:to_i)
      skips = 0
      list_array.each_with_index do |a, i|
        if (a + 1).eql?(list_array[i + 1]) ||
                    (a - 1).eql?(list_array[i - 1]) ||
                    (a.eql?(0) && list_array[i - 1].eql?(9)) ||
                    (a.eql?(9) && list_array[i + 1].eql?(0))
          new_string.gsub!(NUMBERED_LIST_REGEX).with_index do |match, index|
            if i.eql?(index + (i - skips)) && match.chomp('.').eql?(a.to_s)
              ''
            else
              match
            end
          end
        else
          skips +=1
        end
      end
      new_string
    end

    def occurences
      count_list_items_in_array
    end

    private

    def has_at_least_two_items?
      count_list_items_in_array >= 2
    end

    def count_list_items_in_array
      list_array = string.scan(NUMBERED_LIST_REGEX).map(&:to_i)
      counter = 0
      list_array.each_with_index do |a, i|
        next unless (a + 1).eql?(list_array[i + 1]) ||
                    (a - 1).eql?(list_array[i - 1]) ||
                    (a.eql?(0) && list_array[i - 1].eql?(9)) ||
                    (a.eql?(9) && list_array[i + 1].eql?(0))
        counter += 1
      end
      counter
    end
  end
end
