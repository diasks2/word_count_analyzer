module WordCountAnalyzer
  class Date
    DOW = %w(monday tuesday wednesday thursday friday saturday sunday)
    DOW_ABBR = %w(mon tu tue tues wed th thu thur thurs fri sat sun)
    MONTHS = %w(january february march april may june july august september october november december)
    MONTH_ABBR = %w(jan feb mar apr jun jul aug sep sept oct nov dec)
    # Rubular: http://rubular.com/r/73CZ2HU0q6
    DMY_MDY_REGEX = /(\d{1,2}(\/|\.|-)){2}\d{4}\.?/

    # Rubular: http://rubular.com/r/GWbuWXw4t0
    YMD_YDM_REGEX = /\d{4}(\/|\.|-)(\d{1,2}(\/|\.|-)){2}\.?/

    # Rubular: http://rubular.com/r/SRZ27XNlvR
    DIGIT_ONLY_YEAR_FIRST_REGEX = /[12]\d{7}\D\.?/

    # Rubular: http://rubular.com/r/mpVSeaKwdY
    DIGIT_ONLY_YEAR_LAST_REGEX = /\d{4}[12]\d{3}\D\.?/

    def includes_date?(text)
      includes_long_date?(text) || includes_number_only_date?(text)
    end

    def replace(text)
      counter = 0
      DOW_ABBR.map { |day| counter +=1 if text.include?('day') }
      text = redact_dates(counter, text)
      redact_regex(text)
    end

    def occurrences(text)
      replace(text).scan(/wsdateword/).size
    end

    def replace_number_only_date(text)
      text.gsub(DMY_MDY_REGEX, ' wsdateword ')
          .gsub(YMD_YDM_REGEX, ' wsdateword ')
          .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' wsdateword ')
          .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' wsdateword ')
    end

    private

    def redact_dates(counter, text)
      if counter > 0
        text = redact_dow_abbr(text)
        text = redact_dow(text)
      else
        text = redact_dow(text)
        text = redact_dow_abbr(text)
      end
      text
    end

    def redact_regex(text)
      text.gsub(DMY_MDY_REGEX, ' wsdateword ')
          .gsub(YMD_YDM_REGEX, ' wsdateword ')
          .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' wsdateword ')
          .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' wsdateword ')
    end

    def redact_dow(text)
      DOW.each do |day|
        MONTHS.map { |month| text = redact_date(text, day, month) }
        MONTH_ABBR.map { |month| text = redact_date(text, day, month) }
      end
      text
    end

    def redact_dow_abbr(text)
      DOW_ABBR.each do |day|
        MONTHS.map { |month| text = text.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}\.?/i, ' wsdateword ') }
        MONTH_ABBR.map { |month| text = text.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}\.?/i, ' wsdateword ') }
      end
      text
    end

    def redact_date(text, day, month)
      text.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                           .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                           .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*\.?/i, ' wsdateword ')
                           .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+\.?/i, ' wsdateword ')
                           .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*\.?/i, ' wsdateword ')
                           .gsub(/\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})\.?/i, ' wsdateword ')
    end

    def includes_long_date?(text)
      includes_long_date_1?(text) || includes_long_date_2?(text)
    end

    def includes_long_date_1?(text)
      DOW.each do |day|
        MONTHS.map { |month| return true if check_for_matches(day, month, text) }
        MONTH_ABBR.map { |month| return true if check_for_matches(day, month, text) }
      end
      false
    end

    def includes_long_date_2?(text)
      DOW_ABBR.each do |day|
        MONTHS.map { |month| return true if !(text !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}/i) }
        MONTH_ABBR.map { |month| return true if !(text !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i) }
      end
      false
    end

    def includes_number_only_date?(text)
      !(text !~ DMY_MDY_REGEX) ||
      !(text !~ YMD_YDM_REGEX) ||
      !(text !~ DIGIT_ONLY_YEAR_FIRST_REGEX) ||
      !(text !~ DIGIT_ONLY_YEAR_LAST_REGEX)
    end

    def check_for_matches(day, month, text)
      !(text !~ /#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i) ||
      !(text !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i) ||
      !(text !~ /\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i) ||
      !(text !~ /\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i) ||
      !(text !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i) ||
      !(text !~ /\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})/i)
    end
  end
end