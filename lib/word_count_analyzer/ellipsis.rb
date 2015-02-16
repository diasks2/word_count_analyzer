module WordCountAnalyzer
  class Ellipsis
    # Rubular: http://rubular.com/r/mfdtSeuIf2
    FOUR_CONSECUTIVE_REGEX = /(?<=[^\.]|\A)\.{3}\.(?=[^\.]|$)/

    # Rubular: http://rubular.com/r/YBG1dIHTRu
    THREE_SPACE_REGEX = /(\s\.){3}\s/

    # Rubular: http://rubular.com/r/2VvZ8wRbd8
    FOUR_SPACE_REGEX = /(?<=[a-z]|\A)(\.\s){3}\.(\z|$|\n)/

    OTHER_THREE_PERIOD_REGEX = /(?<=[^\.]|\A)\.{3}(?=([^\.]|$))/

    UNICODE_ELLIPSIS = /(?<=[^…]|\A)…{1}(?=[^…]|$)/

    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def includes_ellipsis?
      !(string !~ FOUR_CONSECUTIVE_REGEX) ||
      !(string !~ THREE_SPACE_REGEX) ||
      !(string !~ FOUR_SPACE_REGEX) ||
      !(string !~ OTHER_THREE_PERIOD_REGEX) ||
      !(string !~ UNICODE_ELLIPSIS)
    end

    def replace
      string.gsub(FOUR_CONSECUTIVE_REGEX, ' wseword ')
            .gsub(THREE_SPACE_REGEX, ' wseword ')
            .gsub(FOUR_SPACE_REGEX, ' wseword ')
            .gsub(OTHER_THREE_PERIOD_REGEX, ' wseword ')
            .gsub(UNICODE_ELLIPSIS, ' wseword ')
    end

    def occurences
      count = 0
      replace.split(' ').map { |token| count += 1 if token.strip.eql?('wseword') }
      count
    end
  end
end