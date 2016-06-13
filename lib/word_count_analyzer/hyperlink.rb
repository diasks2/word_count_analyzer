require 'uri'

module WordCountAnalyzer
  class Hyperlink
    NON_HYPERLINK_REGEX = /\A\w+:$/

    # Rubular: http://rubular.com/r/fXa4lp0gfS
    HYPERLINK_REGEX = /(http|https|www)(\.|:)/

    def hyperlink?(text)
      !(text !~ URI.regexp) && text !~ NON_HYPERLINK_REGEX && !(text !~ HYPERLINK_REGEX)
    end

    def occurrences(text)
      text.scan(URI.regexp).map { |link| link.compact.size > 1 ? 1 : 0 }.inject(0) { |sum, x| sum + x }
    end

    def replace(text)
      text.split(/\s+/).each do |token|
        if !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX) && token.include?('">')
          text = text.gsub(/#{Regexp.escape(token.split('">')[0])}/, ' wslinkword ')
        elsif !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX)
          text = text.gsub(/#{Regexp.escape(token)}/, ' wslinkword ')
        end
      end
      text
    end

    def replace_split_at_period(text)
      text.split(/\s+/).each do |token|
        if !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX) && token.include?('">')
          text.gsub!(/#{Regexp.escape(token.split('">')[0])}/) do |match|
            match.split('.').join(' ')
          end
        elsif !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX)
          text.gsub!(/#{Regexp.escape(token)}/) do |match|
            match.split('.').join(' ')
          end
        end
      end
      text
    end
  end
end
