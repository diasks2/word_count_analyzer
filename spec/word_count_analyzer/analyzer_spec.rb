require 'spec_helper'

RSpec.describe WordCountAnalyzer::Analyzer do
  context '#analysis' do
    it 'should analyze the gray areas' do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Analyzer.new(text: text)
      expect(ws.analyze).to eq({"ellipsis"=>1, "hyperlink"=>2, "contraction"=>4, "hyphenated_word"=>2, "date"=>2, "number"=>1, "numbered_list"=>3, "xhtml"=>1, "forward_slash"=>1, "backslash"=>1, "dotted_line"=>1, "dashed_line"=>1, "underscore"=>1, "stray_punctuation"=>5})
    end
  end
end
