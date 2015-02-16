require 'spec_helper'

RSpec.describe WordCountAnalyzer::Xhtml do
  context '#includes_xhtml?' do
    it 'returns true if the string includes XML or HTML #001' do
      string = '<span class="cool-text">Hello world</span>'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.includes_xhtml?).to eq(true)
    end

    it 'returns true if the string includes XML or HTML #002' do
      string = 'Hello there. Another sentence <tuv>Sentence</tuv> here.'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.includes_xhtml?).to eq(true)
    end

    it "returns false if the string doesn't include XML or HTML #003" do
      string = 'Hello world.'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.includes_xhtml?).to eq(false)
    end
  end

  context '#replace' do
    it 'replaces XML or HTML with an empty string #001' do
      string = '<span class="cool-text">Hello world</span>'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.replace).to eq(" Hello world ")
    end

    it 'replaces XML or HTML with an empty string #002' do
      string = 'Hello there. Another sentence <tuv>Sentence</tuv> here.'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.replace).to eq("Hello there. Another sentence  Sentence  here.")
    end
  end

  context '#count_difference_word_boundary' do
    it 'counts the difference in word count between with xhtml and without #001' do
      string = '<span class="cool-text">Hello world</span>'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.count_difference_word_boundary).to eq(1)
    end

    it 'counts the difference in word count between with xhtml and without #002' do
      string = 'Hello there. Another sentence <tuv>Sentence</tuv> here.'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.count_difference_word_boundary).to eq(0)
    end

    it 'counts the difference in word count between with xhtml and without #003' do
      string = '<span class=”cool-text”>Hello world</span> Hello there. Another sentence <tuv>Sentence</tuv> here. Hello world.'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.count_difference_word_boundary).to eq(1)
    end
  end

  context '#occurences' do
    it 'counts the number of tags (1 opening set and 1 closing set of tags counts as 1)' do
      string = '<span class=”cool-text”>Hello world</span> Hello there. Another sentence <tuv>Sentence</tuv> here. Hello world.'
      ws = WordCountAnalyzer::Xhtml.new(string: string)
      expect(ws.occurences).to eq(2)
    end
  end
end
