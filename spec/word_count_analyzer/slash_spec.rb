require 'spec_helper'

RSpec.describe WordCountAnalyzer::Slash do
  context '#includes_forward_slash?' do
    it 'returns true if the string includes a token with a forward slash #001' do
      string = "Using the solidus for he/she/it is often discouraged, except in this case."
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.includes_forward_slash?).to eq(true)
    end

    it 'returns false if the string does not includes a token with a forward slash #002' do
      string = "Hello world."
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.includes_forward_slash?).to eq(false)
    end

    it 'ignores hyperlinks #003' do
      string = "http://www.google.com/google"
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.includes_forward_slash?).to eq(false)
    end

    it 'ignores dates #004' do
      string = "Today is 2/15/2013"
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.includes_forward_slash?).to eq(false)
    end
  end

  context '#includes_backslash?' do
    it 'returns true if the string includes a token with a backslash #001' do
      string = 'The file location is c:\Users\johndoe.'
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.includes_backslash?).to eq(true)
    end

    it 'returns false if the string does not includes a token with a backslash #002' do
      string = "Hello world."
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.includes_backslash?).to eq(false)
    end
  end

  context '#forward_slash_occurences' do
    it 'returns the number of occurrences of tokens with a forward slash #001' do
      string = "Using the solidus for he/she/it is often discouraged, except in this case she/he said."
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.forward_slash_occurences).to eq(2)
    end

    it 'returns the number of occurrences of tokens with a forward slash #002' do
      string = "Hello world."
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.forward_slash_occurences).to eq(0)
    end
  end

  context '#backslash_occurences' do
    it 'returns the number of occurrences of tokens with a backslash #001' do
      string = 'The file location is c:\Users\johndoe or d:\Users\john\www'
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.backslash_occurences).to eq(2)
    end

    it 'returns the number of occurrences of tokens with a backslash #002' do
      string = "Hello world."
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.backslash_occurences).to eq(0)
    end

    it 'returns the number of occurrences of tokens with a backslash #003' do
      string = "<span>Hello world.</span>"
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.backslash_occurences).to eq(0)
    end
  end

  context '#replace_forward_slashes_multiple' do
    it 'replaces forward slashes with multiple tokens #001' do
      string = "he/she/it"
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.replace_forward_slashes).to eq("he she it")
    end

    it 'replaces forward slashes with multiple tokens #002' do
      string = "hello//world"
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.replace_forward_slashes).to eq("hello world")
    end
  end

  context '#replace_forward_slashes_except_dates' do
    it 'replaces forward slashes with multiple tokens #001' do
      string = "he/she/it 4/28/2013"
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.replace_forward_slashes).to eq("he she it  wsdateword ")
    end

    it 'replaces forward slashes with multiple tokens #002' do
      string = "hello//world 4/28/2013"
      ws = WordCountAnalyzer::Slash.new(string: string)
      expect(ws.replace_forward_slashes).to eq("hello world  wsdateword ")
    end
  end
end
