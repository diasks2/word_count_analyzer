require 'spec_helper'

RSpec.describe WordCountAnalyzer::HyphenatedWord do
  context '#hyphenated_word?' do
    it 'returns true if the token is a hyphenated word #001' do
      token = 'devil-may-care'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.hyphenated_word?).to eq(true)
    end

    it 'returns true if the token is a hyphenated word #002' do
      token = '(2R)-2-methylsulfanyl-3-hydroxybutanedioate'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.hyphenated_word?).to eq(true)
    end

    it 'returns false if the token is not a hyphenated word' do
      token = 'hello'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.hyphenated_word?).to eq(false)
    end

    it 'returns false if the token is a hyperlink' do
      token = 'https://www.example-one.com'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.hyphenated_word?).to eq(false)
    end

    it 'returns false if the token is long string of dashes' do
      token = '------------'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.hyphenated_word?).to eq(false)
    end

    it 'returns true if the token is a hyphenated word (small em dashes)' do
      token = 'devil﹘may﹘care'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.hyphenated_word?).to eq(true)
    end
  end

  context '#count_as_multiple' do
    it 'returns the count of the individual words that are separated by the hyphen' do
      token = 'devil-may-care'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.count_as_multiple).to eq(3)
    end

    it 'handles small em dashes' do
      token = 'devil﹘may﹘care'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.count_as_multiple).to eq(3)
    end

    it 'returns the count of the individual words that are separated by the hyphen #002' do
      token = '(2R)-2-methylsulfanyl-3-hydroxybutanedioate'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.count_as_multiple).to eq(5)
    end
  end

  context '#replace' do
    it 'splits hyphenated words #001' do
      token = 'devil-may-care'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.replace).to eq('devil may care')
    end

    it 'splits hyphenated words #002' do
      token = 'devil﹘may﹘care'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.replace).to eq('devil may care')
    end

    it 'splits hyphenated words #003' do
      token = '(2R)-2-methylsulfanyl-3-hydroxybutanedioate'
      ws = WordCountAnalyzer::HyphenatedWord.new(token: token)
      expect(ws.replace).to eq('(2R) 2 methylsulfanyl 3 hydroxybutanedioate')
    end
  end
end
