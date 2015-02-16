require 'spec_helper'

RSpec.describe WordCountAnalyzer::Contraction do
  before do
    @tgr = EngTagger.new
  end
  context '#contraction?' do
    it 'returns true if the token is a contraction' do
      token = "when'd"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.contraction?).to eq(true)
    end

    it 'returns true if the token is an irregular contraction' do
      token = "o'clock"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.contraction?).to eq(true)
    end

    it 'returns false if the token is a possesive and not a contraction' do
      token = "Bob's"
      following_token = "car"
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.contraction?).to eq(false)
    end

    it 'returns true if the token is a contraction' do
      token = "Bob's"
      following_token = "the"
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.contraction?).to eq(true)
    end

    it 'returns true if the token is a contraction' do
      token = "Bob's"
      following_token = "open"
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.contraction?).to eq(true)
    end

    it 'returns true if the token is a contraction' do
      token = "Don't"
      following_token = "count"
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.contraction?).to eq(true)
    end
  end

  context '#expanded_count' do
    it 'returns the count of the contraction expanded #001' do
      token = "when'd"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.expanded_count).to eq(2)
    end

    it 'returns the count of the contraction expanded #002' do
      token = "o'clock"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.expanded_count).to eq(3)
    end

    it 'returns the count of the contraction expanded #003' do
      token = "Bob's"
      following_token = "car"
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.expanded_count).to eq(1)
    end

    it 'returns the count of the contraction expanded #004' do
      token = "Bob's"
      following_token = "the"
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: nil)
      expect(ws.expanded_count).to eq(2)
    end

    it 'returns the count of the contraction expanded #005' do
      token = "cat-o'-nine-tails"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: 'count_as_one')
      expect(ws.expanded_count).to eq(1)
    end

    it 'returns the count of the contraction expanded #006' do
      token = "cat-o'-nine-tails"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr, hyphen: 'count_as_multiple')
      expect(ws.expanded_count).to eq(4)
    end
  end

  context '#replace' do
    it 'replaces the token with the contraction expanded #001' do
      token = "cat-o'-nine-tails"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr)
      expect(ws.replace).to eq("cat-of-nine-tails")
    end

    it 'replaces the token with the contraction expanded #002' do
      token = "Bob's"
      following_token = "the"
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr)
      expect(ws.replace).to eq(" word word ")
    end

    it 'replaces the token with the contraction expanded #003' do
      token = "don't"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr)
      expect(ws.replace).to eq("do not")
    end

    it 'replaces the token with the contraction expanded #004' do
      token = "hello"
      following_token = nil
      ws = WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: @tgr)
      expect(ws.replace).to eq("hello")
    end
  end
end
