require 'spec_helper'

RSpec.describe WordCountAnalyzer::Punctuation do
  context '#dotted_line_ocurrances' do
    it 'returns the number of dotted line occurences #001' do
      string = "Here is one …………………………………………………………………… and another ......"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.dotted_line_ocurrances).to eq(2)
    end

    it 'returns the number of dotted line occurences #002' do
      string = "Hello world"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.dotted_line_ocurrances).to eq(0)
    end
  end

  context '#dashed_line_ocurrances' do
    it 'returns the number of dotted line occurences #001' do
      string = "Here is one ----- and another -----"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.dashed_line_ocurrances).to eq(2)
    end

    it 'returns the number of dotted line occurences #002' do
      string = "Hello world"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.dashed_line_ocurrances).to eq(0)
    end
  end

  context '#underscore_ocurrances' do
    it 'returns the number of undescore occurences #001' do
      string = "Here is one ______ and another ______"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.underscore_ocurrances).to eq(2)
    end

    it 'returns the number of undescore occurences #002' do
      string = "Hello world"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.underscore_ocurrances).to eq(0)
    end
  end

  context '#stray_punctuation_occurences' do
    it 'returns the number of stray punctuation occurences #001' do
      string = "Hello world ? This is another - sentence ."
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.stray_punctuation_occurences).to eq(3)
    end

    it 'returns the number of stray punctuation occurences #002' do
      string = "Hello world. Great?"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.stray_punctuation_occurences).to eq(0)
    end
  end

  context '#replace_dotted_line' do
    it 'replaces the dotted lines' do
      string = "Here is one …………………………………………………………………… and another ......"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.replace_dotted_line).to eq("Here is one  and another ")
    end
  end

  context '#replace_dashed_line' do
    it 'replaces the dashed lines' do
      string = "Here is one ----- and another -----"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.replace_dashed_line).to eq("Here is one and another ")
    end
  end

  context '#replace_underscore' do
    it 'replaces the underscores' do
      string = "Here is one ______ and another ______"
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.replace_underscore).to eq("Here is one and another ")
    end
  end

  context '#replace_stray_punctuation' do
    it 'replaces any stray punctutation' do
      string = "Hello world ? This is another - sentence ."
      ws = WordCountAnalyzer::Punctuation.new(string: string)
      expect(ws.replace_stray_punctuation).to eq("Hello world  This is another  sentence ")
    end
  end
end
