require 'spec_helper'

RSpec.describe WordCountAnalyzer::Ellipsis do
  context '#includes_ellipsis?' do
    it 'returns true if the string includes an ellipsis #001' do
      string = 'Using an ellipsis … causes different counts.'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #002' do
      string = 'Using an ellipsis causes different counts…depending on the style that you use.'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #003' do
      string = 'Using an ellipsis causes different counts depending on the style . . . that you use.'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #004' do
      string = 'Using an ellipsis causes different counts depending on the style . . . . that you use.'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #005' do
      string = 'Using an ellipsis causes different counts depending on the style.... that you use.'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #006' do
      string = 'hello world ...'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #007' do
      string = '...'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #008' do
      string = '....'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #009' do
      string = ' . . . '
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #010' do
      string = ' . . . . '
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it 'returns true if the string includes an ellipsis #011' do
      string = '…'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(true)
    end

    it "returns false if the string doesn't include an ellipsis #012" do
      string = 'Hello world.'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(false)
    end

    it "returns false if the string includes a dotted_line #0013" do
      string = '.....'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(false)
    end

    it "returns false if the string includes a dotted_line #0014" do
      string = "Here is one …………………………………………………………………… and another ......"
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.includes_ellipsis?).to eq(false)
    end
  end

  context '#replace' do
    it 'returns a string with the ellipsis replaced #001' do
      string = 'Using an ellipsis … causes different counts…depending on the style . . . that you use. I never meant that.... She left the store. The practice was not abandoned. . . .'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.replace).to eq("Using an ellipsis  wseword  causes different counts wseword depending on the style wseword that you use. I never meant that wseword  She left the store. The practice was not abandoned wseword ")
    end
  end

  context '#occurences' do
    it 'returns a string with the ellipsis replaced #001' do
      string = 'Using an ellipsis … causes different counts…depending on the style . . . that you use. I never meant that.... She left the store. The practice was not abandoned. . . .'
      ws = WordCountAnalyzer::Ellipsis.new(string: string)
      expect(ws.occurences).to eq(5)
    end
  end
end