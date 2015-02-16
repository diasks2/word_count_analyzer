module WordCountAnalyzer
  class Xhtml
    # Rubular: http://rubular.com/r/ENrVFMdJ8v
    XHTML_REGEX = /<\/?[^>]*>/
    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def includes_xhtml?
      !(string !~ XHTML_REGEX)
    end

    def replace
      string.gsub(XHTML_REGEX, ' ')
    end

    def count_difference_word_boundary
      string.split(/\s+/).size - replace.strip.split(/\s+/).size
    end

    def occurences
      string.gsub(XHTML_REGEX, ' wsxhtmlword ').scan(/wsxhtmlword/).size / 2
    end
  end
end
