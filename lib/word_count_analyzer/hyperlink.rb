require 'uri'

module WordCountAnalyzer
  class Hyperlink
    NON_HYPERLINK_REGEX = /\A\w+:$/

    # Rubular: http://rubular.com/r/fXa4lp0gfS
    HYPERLINK_REGEX = /(http|https|www)(\.|:)/

    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def hyperlink?
      !(string !~ URI.regexp) && string !~ NON_HYPERLINK_REGEX && !(string !~ HYPERLINK_REGEX)
    end

    def occurences
      counter = 0
      string.scan(URI.regexp).each do |link|
        counter += 1 if link.compact.size > 1
      end
      counter
    end

    def replace
      new_string = string.dup
      string.split(/\s+/).each do |token|
        if !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX) && token.include?('">')
          new_string = new_string.gsub(/#{Regexp.escape(token.split('">')[0])}/, ' wslinkword ')
        elsif !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX)
          new_string = new_string.gsub(/#{Regexp.escape(token)}/, ' wslinkword ')
        end
      end
      new_string
    end

    def replace_split_at_period
      new_string = string.dup
      string.split(/\s+/).each do |token|
        if !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX) && token.include?('">')
          new_string.gsub!(/#{Regexp.escape(token.split('">')[0])}/) do |match|
            match.split('.').join(' ')
          end
        elsif !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX)
          new_string.gsub!(/#{Regexp.escape(token)}/) do |match|
            match.split('.').join(' ')
          end
        end
      end
      new_string
    end
  end
end
