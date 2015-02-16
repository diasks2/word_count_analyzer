module WordCountAnalyzer
  class HyphenatedWord
    # Rubular: http://rubular.com/r/RjZ7qi0uFf
    DASHED_LINE_REGEX = /\s-{2,}(\s|$)|\A-{2,}(\s|$)/

    attr_reader :token
    def initialize(token:)
      @token = token.gsub(DASHED_LINE_REGEX, '')
    end

    def hyphenated_word?
      (token.include?('-') || token.include?('﹘')) && !WordCountAnalyzer::Hyperlink.new(string: token).hyperlink?
    end

    def count_as_multiple
      token.split(/[﹘,-]/).length
    end

    def replace
      token.split(/[﹘,-]/).join(' ')
    end
  end
end
