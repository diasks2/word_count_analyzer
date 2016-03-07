module WordCountAnalyzer
  class Analyzer
    attr_reader :text, :tagger
    def initialize(text:)
      @text = text
      @tagger = EngTagger.new
    end

    def analyze
      analysis = {}
      analysis['ellipsis'] = WordCountAnalyzer::Ellipsis.new.occurences(text)
      contraction_count = 0
      hyphenated_word_count = 0
      WordCountAnalyzer::Xhtml.new(string: text).replace.split(/\s+/).each_with_index do |token, index|
        contraction_count += 1 if WordCountAnalyzer::Contraction.new(token: token, following_token: text.split(/\s+/)[index + 1], tgr: tagger, hyphen: 'single').contraction?
        hyphenated_word_count += 1 if WordCountAnalyzer::HyphenatedWord.new(token: token).hyphenated_word?
      end
      analysis['hyperlink'] = WordCountAnalyzer::Hyperlink.new.occurences(text)
      analysis['contraction'] = contraction_count
      analysis['hyphenated_word'] = hyphenated_word_count
      analysis['date'] = WordCountAnalyzer::Date.new.occurences(text)
      analysis['number'] = WordCountAnalyzer::Number.new(string: text).occurences
      analysis['numbered_list'] = WordCountAnalyzer::NumberedList.new(string: text).occurences
      analysis['xhtml'] = WordCountAnalyzer::Xhtml.new(string: text).occurences
      analysis['forward_slash'] = WordCountAnalyzer::Slash.new(string: text).forward_slash_occurences
      analysis['backslash'] = WordCountAnalyzer::Slash.new(string: text).backslash_occurences
      analysis['dotted_line'] = WordCountAnalyzer::Punctuation.new(string: text).dotted_line_ocurrances
      analysis['dashed_line'] = WordCountAnalyzer::Punctuation.new(string: text).dashed_line_ocurrances
      analysis['underscore'] = WordCountAnalyzer::Punctuation.new(string: text).underscore_ocurrances
      analysis['stray_punctuation'] = WordCountAnalyzer::Punctuation.new(string: text).stray_punctuation_occurences
      analysis
    end
  end
end
