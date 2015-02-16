require 'spec_helper'

RSpec.describe WordCountAnalyzer::Hyperlink do
  context '#hyperlink?' do
    it 'returns true if the string is a hyperlink #001' do
      string = "http://www.example.com/this-IS-a_test/hello.html"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.hyperlink?).to eq(true)
    end

    it 'returns true if the string is a hyperlink #002' do
      string = "http://www.google.co.uk"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.hyperlink?).to eq(true)
    end

    it 'returns true if the string is a hyperlink #003' do
      string = "https://google.co.uk"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.hyperlink?).to eq(true)
    end

    it 'returns false if the string is not a hyperlink #004' do
      string = "hello"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.hyperlink?).to eq(false)
    end

    it 'returns false if the string is not a hyperlink #005' do
      string = "john@gmail.com"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.hyperlink?).to eq(false)
    end

    it 'returns false if the string is not a hyperlink #006' do
      string = "date:"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.hyperlink?).to eq(false)
    end

    it 'returns false if the string is not a hyperlink #007' do
      string = 'The file location is c:\Users\johndoe.'
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.hyperlink?).to eq(false)
    end
  end

  context '#occurences' do
    it 'returns the occurences of hyperlink tokens in a string #001' do
      string = "Today the date is: Jan 1. Visit https://www.example.com/hello or http://www.google.co.uk"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.occurences).to eq(2)
    end
  end

  context '#replace' do
    it 'replaces the hyperlinks in a string with regular tokens #001' do
      string = "Today the date is: Jan 1. Visit https://www.example.com/hello or http://www.google.co.uk"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.replace).to eq("Today the date is: Jan 1. Visit  wslinkword  or  wslinkword ")
    end

    it 'replaces the hyperlinks in a string with regular tokens #002' do
      string = 'The file location is c:\Users\johndoe or d:\Users\john\www'
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.replace).to eq('The file location is c:\Users\johndoe or d:\Users\john\www')
    end
  end

  context '#replace_split_at_period' do
    it 'replaces the hyperlinks in a string with regular tokens, split at periods #001' do
      string = "http://www.google.co.uk"
      ws = WordCountAnalyzer::Hyperlink.new(string: string)
      expect(ws.replace_split_at_period).to eq("http://www google co uk")
    end
  end
end
