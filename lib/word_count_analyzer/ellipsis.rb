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

    def includes_ellipsis?(text)
      !(text !~ FOUR_CONSECUTIVE_REGEX) ||
      !(text !~ THREE_SPACE_REGEX) ||
      !(text !~ FOUR_SPACE_REGEX) ||
      !(text !~ OTHER_THREE_PERIOD_REGEX) ||
      !(text !~ UNICODE_ELLIPSIS)
    end

    def replace(text)
      text.gsub(FOUR_CONSECUTIVE_REGEX, ' wseword ')
            .gsub(THREE_SPACE_REGEX, ' wseword ')
            .gsub(FOUR_SPACE_REGEX, ' wseword ')
            .gsub(OTHER_THREE_PERIOD_REGEX, ' wseword ')
            .gsub(UNICODE_ELLIPSIS, ' wseword ')
    end

    def occurrences(text)
      count = 0
      replace(text).split(' ').map { |token| count += 1 if token.strip.eql?('wseword') }
      count
    end
  end
end