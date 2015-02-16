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

    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def includes_date?
      long_date || number_only_date
    end

    def replace
      new_string = string.dup
      counter = 0
      DOW_ABBR.each do |day|
        counter +=1 if string.include?('day')
      end
      if counter > 0
        DOW_ABBR.each do |day|
          MONTHS.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
          end
          MONTH_ABBR.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
          end
        end
        DOW.each do |day|
          MONTHS.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th)*\.?/i, ' wsdateword ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+\.?/i, ' wsdateword ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*\.?/i, ' wsdateword ')
                                   .gsub(/\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})\.?/i, ' wsdateword ')
          end
          MONTH_ABBR.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                           .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                           .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th)*\.?/i, ' wsdateword ')
                           .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+\.?/i, ' wsdateword ')
                           .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*\.?/i, ' wsdateword ')
                           .gsub(/\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})\.?/i, ' wsdateword ')
          end
        end
      else
        DOW.each do |day|
          MONTHS.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th)*\.?/i, ' wsdateword ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+\.?/i, ' wsdateword ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*\.?/i, ' wsdateword ')
                                   .gsub(/\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})\.?/i, ' wsdateword ')
          end
          MONTH_ABBR.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                           .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
                           .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th)*\.?/i, ' wsdateword ')
                           .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+\.?/i, ' wsdateword ')
                           .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*\.?/i, ' wsdateword ')
                           .gsub(/\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})\.?/i, ' wsdateword ')
          end
        end
        DOW_ABBR.each do |day|
          MONTHS.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
          end
          MONTH_ABBR.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}\.?/i, ' wsdateword ')
          end
        end
      end
      new_string = new_string.gsub(DMY_MDY_REGEX, ' wsdateword ')
                     .gsub(YMD_YDM_REGEX, ' wsdateword ')
                     .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' wsdateword ')
                     .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' wsdateword ')
    end

    def occurences
      replace.scan(/wsdateword/).size
    end

    def replace_number_only_date
      string.gsub(DMY_MDY_REGEX, ' wsdateword ')
            .gsub(YMD_YDM_REGEX, ' wsdateword ')
            .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' wsdateword ')
            .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' wsdateword ')
    end

    private

    def long_date
      match_found = false
      DOW.each do |day|
        MONTHS.each do |month|
          break if match_found
          match_found = check_for_matches(day, month)
        end
        MONTH_ABBR.each do |month|
          break if match_found
          match_found = check_for_matches(day, month)
        end
      end
      DOW_ABBR.each do |day|
        MONTHS.each do |month|
          break if match_found
          match_found = !(string !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th)*(,)*\s\d{4}/i)
        end
        MONTH_ABBR.each do |month|
          break if match_found
          match_found = !(string !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}/i)
        end
      end
      match_found
    end

    def number_only_date
      !(string !~ DMY_MDY_REGEX) ||
      !(string !~ YMD_YDM_REGEX) ||
      !(string !~ DIGIT_ONLY_YEAR_FIRST_REGEX) ||
      !(string !~ DIGIT_ONLY_YEAR_LAST_REGEX)
    end

    def check_for_matches(day, month)
      !(string !~ /#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}/i) ||
      !(string !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*(,)*\s\d{4}/i) ||
      !(string !~ /\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th)*/i) ||
      !(string !~ /\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i) ||
      !(string !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th)*/i) ||
      !(string !~ /\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})/i)
    end
  end
end
