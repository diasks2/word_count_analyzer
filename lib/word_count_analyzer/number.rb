module WordCountAnalyzer
  class Number
    # Rubular: http://rubular.com/r/OGj82uEu8d
    NUMBER_REGEX = /(?<=\A)\D?\d+((,|\.)*\d)*(\D?\s|\s|\.?\s|\.$)|(?<=\s)\D?\d+((,|\.)*\d)*(\D?\s|\s|\.?\s|\.$)/

    attr_reader :string
    def initialize(string:)
      @string = WordCountAnalyzer::NumberedList.new(string: WordCountAnalyzer::Date.new.replace(string)).replace
    end

    def includes_number?
      !(string !~ NUMBER_REGEX)
    end

    def replace
      string.gsub(NUMBER_REGEX, ' wsnumword ')
    end

    def occurrences
      replace.scan(/wsnumword/).size
    end
  end
end
