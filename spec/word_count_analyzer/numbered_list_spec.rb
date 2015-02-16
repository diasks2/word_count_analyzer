require 'spec_helper'

RSpec.describe WordCountAnalyzer::NumberedList do
  context '#includes_numbered_list?' do
    it 'returns true if the string includes a numbered list #001' do
      string = "1. List item a\n\n2. List item b\n\n3. List item c."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.includes_numbered_list?).to eq(true)
    end

    it 'returns false if the string does not include a numbered list #002' do
      string = "I have 1.00 dollar and 2 cents."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.includes_numbered_list?).to eq(false)
    end

    it 'returns false if the string does not include at least 2 list items #003' do
      string = "I have 2."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.includes_numbered_list?).to eq(false)
    end
  end

  context '#replace' do
    it 'replaces any numbered list numbers with an empty string' do
      string = "1. List item a\n\n2. List item b\n\n3. List item c."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.replace).to eq(" List item a\n\n List item b\n\n List item c.")
    end

    it 'replaces any numbered list numbers with an empty string' do
      string = "It also shouldn't have too many contractions, maybe 2. Let's add a list 1. List item a\n\n2. List item b\n\n3. List item c."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.replace).to eq("It also shouldn't have too many contractions, maybe 2. Let's add a list  List item a\n\n List item b\n\n List item c.")
    end
  end

  context '#occurences' do
    it 'counts the occurences of numbered lists #001' do
      string = "1. List item a\n\n2. List item b\n\n3. List item c."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.occurences).to eq(3)
    end

    it 'counts the occurences of numbered lists #002' do
      string = "I have 2."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.occurences).to eq(0)
    end

    it 'counts the occurences of numbered lists #003' do
      string = "1. List item a\n\n2. List item b\n\n3. List item c. Then more text. Ok start a new list. 1. item a 2. item b."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.occurences).to eq(5)
    end

    it 'counts the occurences of numbered lists #004' do
      string = "1. List item a\n\n2. List item b\n\n3. List item c. Then more text. Ok start a new non-list. I have 2."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.occurences).to eq(3)
    end

    it 'counts the occurences of numbered lists #005' do
      string = "It also shouldn't have too many contractions, maybe 2. Let's add a list 1. item a 2. item b 3. item c."
      ws = WordCountAnalyzer::NumberedList.new(string: string)
      expect(ws.occurences).to eq(3)
    end
  end
end
