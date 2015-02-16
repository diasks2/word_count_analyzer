require 'spec_helper'

RSpec.describe WordCountAnalyzer::Number do
  context '#includes_number?' do
    it 'returns true if the string includes a number #001' do
      string = 'It cost $10,000 dollars.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.includes_number?).to eq(true)
    end

    it 'returns true if the string includes a number #002' do
      string = 'It cost 500 dollars.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.includes_number?).to eq(true)
    end

    it 'returns true if the string includes a number #003' do
      string = 'It was only 50% of the total.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.includes_number?).to eq(true)
    end

    it 'returns true if the string includes a number #004' do
      string = 'It was only 50 % of the total.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.includes_number?).to eq(true)
    end

    it "returns false if the string doesn't includes a number #005" do
      string = 'Hello world.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.includes_number?).to eq(false)
    end

    it "returns false if the string doesn't includes a number #006" do
      string = 'Today is 2/18/2014.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.includes_number?).to eq(false)
    end
  end

  context '#replace' do
    it 'returns the string with number and unit substituted as one token #001' do
      string = 'It was only 50 % of the total. 500 total $300.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.replace).to eq("It was only  wsnumword % of the total.  wsnumword total  wsnumword ")
    end
  end

  context '#occurences' do
    it 'returns the number of occurences of a number in the string #001' do
      string = 'It was only 50 % of the total. 500 total. That costs $300 and is 50% off.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.occurences).to eq(4)
    end

    it 'ignores dates #002' do
      string = 'It was only 50 % of the total on Wednesday, June 4 2015. 500 total. That costs $300 and is 50% off only on Apr 5th 1999.'
      ws = WordCountAnalyzer::Number.new(string: string)
      expect(ws.occurences).to eq(4)
    end
  end
end
