# -*- encoding : utf-8 -*-
require 'benchmark'
require 'spec_helper'
require 'stackprof'

RSpec.describe WordCountAnalyzer::Analyzer do
  it 'is fast?' do
    benchmark do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Analyzer.new(text: text).analyze
    end
  end

  it 'is analyzed' do
    data = StackProf.run(mode: :cpu, interval: 1000) do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Analyzer.new(text: text).analyze
    end
    puts StackProf::Report.new(data).print_text
  end

  it 'is analyzed 2' do
    data = StackProf.run(mode: :cpu, interval: 1000) do
      token = "when'd"
      following_token = nil
      WordCountAnalyzer::Contraction.new(token: token, following_token: following_token, tgr: EngTagger.new, hyphen: nil).contraction?
    end
    puts StackProf::Report.new(data).print_text
  end

  it 'is analyzed 3' do
    benchmark do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Counter.new(forward_slash: 'count_as_multiple')
      300.times do
        ws.count(text)
      end
    end
  end
end

def benchmark
  yield
  time = Benchmark.realtime { yield }
  puts "RUNTIME: #{time}"
end
