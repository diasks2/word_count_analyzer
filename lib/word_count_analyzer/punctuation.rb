module WordCountAnalyzer
  class Punctuation
    # Rubular: http://rubular.com/r/ZVBsZVkiqC
    DOTTED_LINE_REGEX = /…{2,}|\.{5,}/

    # Rubular: http://rubular.com/r/RjZ7qi0uFf
    DASHED_LINE_REGEX = /(?<=\s)-{2,}(\s|$)|\A-{2,}(?=(\s|$))/

    # Rubular: http://rubular.com/r/hNofimZwdh
    UNDERSCORE_REGEX = /(?<=\s)_{2,}(\s|$)|\A_{2,}(?=(\s|$))/

    # Rubular: http://rubular.com/r/FexKxGUuIe
    STRAY_PUNCTUATION_REGEX = /(?<=\s)[[:punct:]](?=(\s|$))|(?<=\s)\|(?=(\s|$))/

    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def dotted_line_ocurrances
      string.scan(DOTTED_LINE_REGEX).size
    end

    def dashed_line_ocurrances
      string.scan(DASHED_LINE_REGEX).size
    end

    def underscore_ocurrances
      string.scan(UNDERSCORE_REGEX).size
    end

    def stray_punctuation_occurences
      string.scan(STRAY_PUNCTUATION_REGEX).size
    end

    def replace_dotted_line
      string.gsub(DOTTED_LINE_REGEX, '')
    end

    def replace_dashed_line
      string.gsub(DASHED_LINE_REGEX, '')
    end

    def replace_underscore
      string.gsub(UNDERSCORE_REGEX, '')
    end

    def replace_stray_punctuation
      string.gsub(STRAY_PUNCTUATION_REGEX, '')
    end
  end
end
