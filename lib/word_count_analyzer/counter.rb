module WordCountAnalyzer
  class Counter
    attr_reader :text, :ellipsis, :hyperlink, :contraction, :hyphenated_word, :date, :number, :numbered_list, :xhtml, :forward_slash, :backslash, :dotted_line, :dashed_line, :underscore, :stray_punctuation, :equal_sign, :tgr
    def initialize(text:, **args)
      @text = text
      @ellipsis = args[:ellipsis] || 'ignore'
      @hyperlink = args[:hyperlink] || 'count_as_one'
      @contraction = args[:contraction] || 'count_as_one'
      @hyphenated_word = args[:hyphenated_word] || 'count_as_one'
      @date = args[:date] || 'no_special_treatment'
      @number = args[:number] || 'count'
      @numbered_list = args[:numbered_list] || 'count'
      @xhtml = args[:xhtml] || 'remove'
      @forward_slash = args[:forward_slash] || 'count_as_multiple_except_dates'
      @backslash = args[:backslash] || 'count_as_one'
      @dotted_line = args[:dotted_line] || 'ignore'
      @dashed_line = args[:dashed_line] || 'ignore'
      @underscore = args[:underscore] || 'ignore'
      @stray_punctuation = args[:stray_punctuation] || 'ignore'
      @equal_sign = 'ignore'
      @tgr = EngTagger.new
    end

    def count
      word_count
    end

    def pages_count
      @ellipsis = 'ignore'
      @hyperlink = 'split_at_period'
      @contraction = 'count_as_one'
      @hyphenated_word = 'count_as_multiple'
      @date = 'no_special_treatment'
      @number = 'count'
      @numbered_list = 'ignore'
      @xhtml = 'keep'
      @forward_slash = 'count_as_multiple'
      @backslash = 'count_as_multiple'
      @dotted_line = 'ignore'
      @dashed_line = 'ignore'
      @underscore = 'ignore'
      @stray_punctuation = 'ignore'
      @equal_sign = 'break'
      word_count
    end

    def mword_count
      @ellipsis = 'no_special_treatment'
      @hyperlink = 'count_as_one'
      @contraction = 'count_as_one'
      @hyphenated_word = 'count_as_one'
      @date = 'no_special_treatment'
      @number = 'count'
      @numbered_list = 'count'
      @xhtml = 'keep'
      @forward_slash = 'count_as_one'
      @backslash = 'count_as_one'
      @dotted_line = 'count'
      @dashed_line = 'count'
      @underscore = 'count'
      @stray_punctuation = 'count'
      word_count
    end

    private

    def word_count
      processed_text = process_ellipsis(text)
      processed_text = process_hyperlink(processed_text)
      processed_text = process_contraction(processed_text)
      processed_text = process_date(processed_text)
      processed_text = process_number(processed_text)
      processed_text = process_number_list(processed_text)
      processed_text = process_xhtml(processed_text)
      processed_text = process_forward_slash(processed_text)
      processed_text = process_backslash(processed_text)
      processed_text = process_hyphenated_word(processed_text)
      processed_text = process_dotted_line(processed_text)
      processed_text = process_dashed_line(processed_text)
      processed_text = process_underscore(processed_text)
      processed_text = process_stray_punctuation(processed_text)
      processed_text = process_equal_sign(processed_text) if @equal_sign.eql?('break')
      processed_text.split(/\s+/).reject(&:empty?).size
    end

    def process_ellipsis(txt)
      if ellipsis.eql?('ignore')
        WordCountAnalyzer::Ellipsis.new(string: txt).replace.gsub(/wseword/, '')
      elsif ellipsis.eql?('no_special_treatment')
        txt
      else
        raise 'The value you specified for ellipsis is not a valid option. Please use either `ignore` or `no_special_treatment`. The default option is `ignore`'
      end
    end

    def process_hyperlink(txt)
      case
      when hyperlink.eql?('count_as_one')
        WordCountAnalyzer::Hyperlink.new(string: txt).replace
      when hyperlink.eql?('split_at_period')
        WordCountAnalyzer::Hyperlink.new(string: txt).replace_split_at_period
      when hyperlink.eql?('no_special_treatment')
        txt
      else
        raise 'The value you specified for hyperlink is not a valid option. Please use either `count_as_one`, `split_at_period`, or `no_special_treatment`. The default option is `count_as_one`'
      end
    end

    def process_contraction(txt)
      if contraction.eql?('count_as_one')
        txt
      elsif contraction.eql?('count_as_multiple')
        array = txt.split(/\s+/)
        array.each_with_index.map { |token, i| WordCountAnalyzer::Contraction.new(token: token, following_token: array[i +1], tgr: tgr).replace }.join(' ')
      else
        raise 'The value you specified for contraction is not a valid option. Please use either `count_as_one` or `count_as_multiple`. The default option is `count_as_one`'
      end
    end

    def process_hyphenated_word(txt)
      if hyphenated_word.eql?('count_as_one')
        txt
      elsif hyphenated_word.eql?('count_as_multiple')
        txt.split(/\s+/).each_with_index.map { |token, i| WordCountAnalyzer::HyphenatedWord.new(token: token).replace }.join(' ')
      else
        raise 'The value you specified for hyphenated_word is not a valid option. Please use either `count_as_one` or `count_as_multiple`. The default option is `count_as_one`'
      end
    end

    def process_date(txt)
      if date.eql?('no_special_treatment')
        txt
      elsif date.eql?('count_as_one')
        WordCountAnalyzer::Date.new(string: txt).replace
      else
        raise 'The value you specified for date is not a valid option. Please use either `count_as_one` or `no_special_treatment`. The default option is `no_special_treatment`'
      end
    end

    def process_number(txt)
      if number.eql?('ignore')
        WordCountAnalyzer::Number.new(string: txt).replace.gsub(/wsnumword/, '')
      elsif number.eql?('count')
        txt
      else
        raise 'The value you specified for number is not a valid option. Please use either `ignore` or `count`. The default option is `count`'
      end
    end

    def process_number_list(txt)
      if numbered_list.eql?('ignore')
        WordCountAnalyzer::NumberedList.new(string: txt).replace
      elsif numbered_list.eql?('count')
        txt
      else
        raise 'The value you specified for numbered_list is not a valid option. Please use either `ignore` or `count`. The default option is `count`'
      end
    end

    def process_xhtml(txt)
      if xhtml.eql?('remove')
        WordCountAnalyzer::Xhtml.new(string: txt).replace
      elsif xhtml.eql?('keep')
        txt
      else
        raise 'The value you specified for xhtml is not a valid option. Please use either `remove` or `keep`. The default option is `remove`'
      end
    end

    def process_forward_slash(txt)
      case
      when forward_slash.eql?('count_as_multiple')
        WordCountAnalyzer::Slash.new(string: txt, date: date, xhtml: xhtml, hyperlink: hyperlink).replace_forward_slashes
      when forward_slash.eql?('count_as_multiple_except_dates')
        WordCountAnalyzer::Slash.new(string: txt, date: date, xhtml: xhtml, hyperlink: hyperlink).replace_forward_slashes_except_dates
      when forward_slash.eql?('count_as_one')
        txt
      else
        raise 'The value you specified for forward_slash is not a valid option. Please use either `count_as_one`, `count_as_multiple` or `count_as_multiple_except_dates`. The default option is `count_as_multiple_except_dates`'
      end
    end

    def process_backslash(txt)
      if backslash.eql?('count_as_multiple')
        WordCountAnalyzer::Slash.new(string: txt, date: date, xhtml: xhtml, hyperlink: hyperlink).replace_backslashes
      elsif backslash.eql?('count_as_one')
        txt
      else
        raise 'The value you specified for backslash is not a valid option. Please use either `count_as_one` or `count_as_multiple`. The default option is `count_as_one`'
      end
    end

    def process_dotted_line(txt)
      if dotted_line.eql?('ignore')
        WordCountAnalyzer::Punctuation.new(string: txt).replace_dotted_line
      elsif dotted_line.eql?('count')
        txt
      else
        raise 'The value you specified for dotted_line is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`'
      end
    end

    def process_dashed_line(txt)
      if dashed_line.eql?('ignore')
        WordCountAnalyzer::Punctuation.new(string: txt).replace_dashed_line
      elsif dashed_line.eql?('count')
        txt
      else
        raise 'The value you specified for dashed_line is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`'
      end
    end

    def process_underscore(txt)
      if underscore.eql?('ignore')
        WordCountAnalyzer::Punctuation.new(string: txt).replace_underscore
      elsif underscore.eql?('count')
        txt
      else
        raise 'The value you specified for underscore is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`'
      end
    end

    def process_stray_punctuation(txt)
      if stray_punctuation.eql?('ignore')
        WordCountAnalyzer::Punctuation.new(string: txt).replace_stray_punctuation
      elsif stray_punctuation.eql?('count')
        txt
      else
        raise 'The value you specified for stray_punctuation is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`'
      end
    end

    def process_equal_sign(txt)
      txt.split('=').join(' ').split(/>(?=[a-zA-z]+)/).join(' ')
    end
  end
end
