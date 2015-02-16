require 'spec_helper'

RSpec.describe WordCountAnalyzer::Counter do
  context 'ellipsis' do
    it 'handles an invalid ellipsis argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, ellipsis: 'hello')
      expect { ws.count }.to raise_error('The value you specified for ellipsis is not a valid option. Please use either `ignore` or `no_special_treatment`. The default option is `ignore`')
    end

    it 'ignores ellipses in the word count' do
      text = 'hello world ... what day is it.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        ellipsis: 'ignore'
      )
      expect(ws.count).to eq(6)
    end

    it 'does not ignore ellipses in the word count' do
      text = 'hello world ... what day is it.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        ellipsis: 'no_special_treatment'
      )
      expect(ws.count).to eq(7)
    end

    it 'does not ignore ellipses in the word count' do
      text = 'hello world... what day is it.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        ellipsis: 'no_special_treatment'
      )
      expect(ws.count).to eq(6)
    end

    it 'sets ignore as the default option' do
      text = 'hello world ... what day is it.'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(6)
    end
  end

  context 'hyperlink' do
    it 'handles an invalid hyperlink argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, hyperlink: 'hello')
      expect { ws.count }.to raise_error('The value you specified for hyperlink is not a valid option. Please use either `count_as_one`, `split_at_period`, or `no_special_treatment`. The default option is `count_as_one`')
    end

    it 'counts a hyperlink as one word in the word count' do
      text = 'The site address is http://www.example.com she said.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        hyperlink: 'count_as_one'
      )
      expect(ws.count).to eq(7)
    end

    it 'counts a hyperlink as one word in the word count' do
      text = 'The site address is http://www.example.com she said.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        hyperlink: 'split_at_period',
        forward_slash: 'count_as_one'
      )
      expect(ws.count).to eq(9)
    end

    it 'does not search for hyperlinks' do
      text = 'The site address is http://www.example.com she said.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        hyperlink: 'no_special_treatment'
      )
      expect(ws.count).to eq(8)
    end

    it 'sets count_as_one as the default option' do
      text = 'The site address is http://www.example.com she said.'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(7)
    end
  end

  context 'contraction' do
    it 'handles an invalid contraction argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, contraction: 'hello')
      expect { ws.count }.to raise_error('The value you specified for contraction is not a valid option. Please use either `count_as_one` or `count_as_multiple`. The default option is `count_as_one`')
    end

    it 'counts a contraction as one word in the word count' do
      text = "Don't do that."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        contraction: 'count_as_one'
      )
      expect(ws.count).to eq(3)
    end

    it 'splits a contraction into its separate words for the word count' do
      text = "Don't do that."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        contraction: 'count_as_multiple'
      )
      expect(ws.count).to eq(4)
    end

    it 'sets count_as_one as the default option' do
      text = "Don't do that."
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(3)
    end
  end

  context 'hyphenated_word' do
    it 'handles an invalid hyphenated_word argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, hyphenated_word: 'hello')
      expect { ws.count }.to raise_error('The value you specified for hyphenated_word is not a valid option. Please use either `count_as_one` or `count_as_multiple`. The default option is `count_as_one`')
    end

    it 'counts a hyphenated word as one word in the word count' do
      text = 'He has a devil-may-care attitude.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        hyphenated_word: 'count_as_one'
      )
      expect(ws.count).to eq(5)
    end

    it 'splits a hyphenated word into its separate words for the word count' do
      text = 'He has a devil-may-care attitude.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        hyphenated_word: 'count_as_multiple'
      )
      expect(ws.count).to eq(7)
    end

    it 'sets count_as_one as the default option' do
      text = 'He has a devil-may-care attitude.'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(5)
    end
  end

  context 'date' do
    it 'handles an invalid date argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, date: 'hello')
      expect { ws.count }.to raise_error('The value you specified for date is not a valid option. Please use either `count_as_one` or `no_special_treatment`. The default option is `no_special_treatment`')
    end

    it 'ignores date placeables' do
      text = 'Today is Tues. March 3rd, 2011.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        date: 'no_special_treatment'
      )
      expect(ws.count).to eq(6)
    end

    it 'counts a date placeable as one word in the word count' do
      text = 'Today is Tues. March 3rd, 2011.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        date: 'count_as_one'
      )
      expect(ws.count).to eq(3)
    end

    it 'sets count_as_one as the default option' do
      text = 'Today is Tues. March 3rd, 2011.'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(6)
    end
  end

  context 'number' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, number: 'hello')
      expect { ws.count }.to raise_error('The value you specified for number is not a valid option. Please use either `ignore` or `count`. The default option is `count`')
    end

    it 'counts a number as a word' do
      text = 'There is $300 in the safe. The password is 1234.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        number: 'count'
      )
      expect(ws.count).to eq(10)
    end

    it 'ignores numbers in the word count' do
      text = 'There is $300 in the safe. The password is 1234.'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        number: 'ignore'
      )
      expect(ws.count).to eq(8)
    end

    it 'sets count as the default option' do
      text = 'There is $300 in the safe. The password is 1234.'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(10)
    end
  end

  context 'number_list' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, numbered_list: 'hello')
      expect { ws.count }.to raise_error('The value you specified for numbered_list is not a valid option. Please use either `ignore` or `count`. The default option is `count`')
    end

    it 'counts a numbered list number as a word' do
      text = "Number 2. Add a list 1. List item a\n\n2. List item b\n\n3. List item c."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        numbered_list: 'count'
      )
      expect(ws.count).to eq(17)
    end

    it 'ignores numbered list numbers' do
      text = "Number 2. Add a list 1. List item a\n\n2. List item b\n\n3. List item c."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        numbered_list: 'ignore'
      )
      expect(ws.count).to eq(14)
    end

    it 'sets count as the default option' do
      text = "Number 2. Add a list 1. List item a\n\n2. List item b\n\n3. List item c."
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(17)
    end
  end

  context 'xhtml' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, xhtml: 'hello')
      expect { ws.count }.to raise_error('The value you specified for xhtml is not a valid option. Please use either `remove` or `keep`. The default option is `remove`')
    end

    it 'removes all xhtml from the text' do
      text = "<span class='orange-text'>Hello world</span>"
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        xhtml: 'remove'
      )
      expect(ws.count).to eq(2)
    end

    it 'keeps xhtml in the text' do
      text = "<span class='orange-text'>Hello world</span>"
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        xhtml: 'keep',
        forward_slash: 'count_as_one'
      )
      expect(ws.count).to eq(3)
    end

    it 'keeps xhtml in the text' do
      text = "<span class='orange-text'>Hello world</span>"
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        xhtml: 'keep'
      )
      expect(ws.count).to eq(4)
    end

    it 'sets remove as the default option' do
      text = "<span class='orange-text'>Hello world</span>"
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(2)
    end
  end

  context 'forward_slash' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, forward_slash: 'hello')
      expect { ws.count }.to raise_error('The value you specified for forward_slash is not a valid option. Please use either `count_as_one`, `count_as_multiple` or `count_as_multiple_except_dates`. The default option is `count_as_multiple_except_dates`')
    end

    it 'counts a forward slash as multiple words (except dates) #001' do
      text = "She/he/it said hello. 4/22/2013."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        forward_slash: 'count_as_multiple_except_dates'
      )
      expect(ws.count).to eq(6)
    end

    it 'counts a forward slash as multiple words #002' do
      text = "She/he/it said hello. 4/22/2013."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        forward_slash: 'count_as_multiple'
      )
      expect(ws.count).to eq(8)
    end

    it 'counts a forward slash as multiple words #003' do
      text = "She/he/it said hello. 4/22/2013."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        forward_slash: 'count_as_multiple',
        date: 'count_as_one'
      )
      expect(ws.count).to eq(6)
    end

    it 'counts a forward slash as one word' do
      text = "She/he/it said hello."
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        forward_slash: 'count_as_one'
      )
      expect(ws.count).to eq(3)
    end

    it 'sets count_as_multiple_except_dates as the default option' do
      text = "She/he/it said hello. 4/22/2013."
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(6)
    end
  end

  context 'backslash' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, backslash: 'hello')
      expect { ws.count }.to raise_error('The value you specified for backslash is not a valid option. Please use either `count_as_one` or `count_as_multiple`. The default option is `count_as_one`')
    end

    it 'counts a token with backslashes as one word' do
      text = 'The file location is c:\Users\johndoe'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        backslash: 'count_as_one'
      )
      expect(ws.count).to eq(5)
    end

    it 'counts a token with backslashes as multiple words' do
      text = 'The file location is c:\Users\johndoe'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        backslash: 'count_as_multiple'
      )
      expect(ws.count).to eq(7)
    end

    it 'sets count_as_one as the default option' do
      text = 'The file location is c:\Users\johndoe'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(5)
    end
  end

  context 'dotted_line' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, dotted_line: 'hello')
      expect { ws.count }.to raise_error('The value you specified for dotted_line is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`')
    end

    it 'ignores continuous strings of dots in the word count' do
      text = 'Here is one …………………………………………………………………… and another ......'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        dotted_line: 'ignore'
      )
      expect(ws.count).to eq(5)
    end

    it 'counts a continuous string of dots as a word' do
      text = 'Here is one …………………………………………………………………… and another ......'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        dotted_line: 'count'
      )
      expect(ws.count).to eq(7)
    end

    it 'sets ignore as the default option' do
      text = 'Here is one …………………………………………………………………… and another ......'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(5)
    end
  end

  context 'dashed_line' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, dashed_line: 'hello')
      expect { ws.count }.to raise_error('The value you specified for dashed_line is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`')
    end

    it 'ignores continuous strings of dashes in the word count' do
      text = 'Here is one ----- and another -----'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        dashed_line: 'ignore'
      )
      expect(ws.count).to eq(5)
    end

    it 'counts a continuous string of dashes as a word' do
      text = 'Here is one ----- and another -----'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        dashed_line: 'count'
      )
      expect(ws.count).to eq(7)
    end

    it 'sets ignore as the default option' do
      text = 'Here is one ----- and another -----'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(5)
    end
  end

  context 'underscore' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, underscore: 'hello')
      expect { ws.count }.to raise_error('The value you specified for underscore is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`')
    end

    it 'ignores continuous strings of underscores in the word count' do
      text = "Here is one ______ and another ______"
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        underscore: 'ignore'
      )
      expect(ws.count).to eq(5)
    end

    it 'counts a continuous string of underscores as a word' do
      text = 'Here is one ______ and another ______'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        underscore: 'count'
      )
      expect(ws.count).to eq(7)
    end

    it 'sets ignore as the default option' do
      text = 'Here is one ______ and another ______'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(5)
    end
  end

  context 'stray_punctuation' do
    it 'handles an invalid number argument value' do
      text = 'hello world.'
      ws = WordCountAnalyzer::Counter.new(text: text, stray_punctuation: 'hello')
      expect { ws.count }.to raise_error('The value you specified for stray_punctuation is not a valid option. Please use either `ignore` or `count`. The default option is `ignore`')
    end

    it 'ignores continuous strings of underscores in the word count' do
      text = 'Hello world ? This is another - sentence .'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        stray_punctuation: 'ignore'
      )
      expect(ws.count).to eq(6)
    end

    it 'counts a continuous string of underscores as a word' do
      text = 'Hello world ? This is another - sentence .'
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        stray_punctuation: 'count'
      )
      expect(ws.count).to eq(9)
    end

    it 'sets ignore as the default option' do
      text = 'Hello world ? This is another - sentence .'
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.count).to eq(6)
    end
  end

  it 'counts the words in a string #001' do
    text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
    ws = WordCountAnalyzer::Counter.new(
      text: text,
      ellipsis: 'ignore',
      hyperlink: 'count_as_one',
      contraction: 'count_as_one',
      hyphenated_word: 'count_as_one',
      date: 'no_special_treatment',
      number: 'count',
      numbered_list: 'count',
      xhtml: 'remove',
      forward_slash: 'count_as_one',
      backslash: 'count_as_one',
      dotted_line: 'ignore',
      dashed_line: 'ignore',
      underscore: 'ignore',
      stray_punctuation: 'ignore'
    )
    expect(ws.count).to eq(62)
  end

  it 'counts the words in a string #002' do
    text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
    ws = WordCountAnalyzer::Counter.new(
      text: text,
      ellipsis: 'no_special_treatment',
      hyperlink: 'no_special_treatment',
      contraction: 'count_as_multiple',
      hyphenated_word: 'count_as_multiple',
      date: 'count_as_one',
      number: 'ignore',
      numbered_list: 'ignore',
      xhtml: 'keep',
      forward_slash: 'count_as_multiple',
      backslash: 'count_as_multiple',
      dotted_line: 'count',
      dashed_line: 'count',
      underscore: 'count',
      stray_punctuation: 'count'
    )
    expect(ws.count).to eq(77)
  end

  it 'counts the words in a string #003' do
    text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
    ws = WordCountAnalyzer::Counter.new(text: text)
    expect(ws.count).to eq(64)
  end

  it 'counts the words in a string #004' do
    text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
    ws = WordCountAnalyzer::Counter.new(text: text, forward_slash: 'count_as_multiple')
    expect(ws.count).to eq(66)
  end

  it 'counts the words in a string #005' do
    text = "Hello world... 11/22/2013"
    ws = WordCountAnalyzer::Counter.new(text: text)
    expect(ws.count).to eq(3)
  end

  context 'Pages Word Count' do
    it 'reverse engineers Pages word count #001' do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        ellipsis: 'no_special_treatment',
        hyperlink: 'split_at_period',
        contraction: 'count_as_one',
        hyphenated_word: 'count_as_multiple',
        date: 'no_special_treatment',
        number: 'count',
        numbered_list: 'count',
        xhtml: 'keep',
        forward_slash: 'count_as_multiple',
        backslash: 'count_as_multiple',
        dotted_line: 'ignore',
        dashed_line: 'ignore',
        underscore: 'ignore',
        stray_punctuation: 'ignore'
      )
      expect(ws.count).to eq(79)
    end

    it 'reverse engineers Pages word count #002' do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.pages_count).to eq(79)
    end

    it 'reverse engineers Pages word count #003' do
      text = "..."
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.pages_count).to eq(0)
    end
  end

  context 'Microsoft Word Count' do
    it 'reverse engineers the Microsoft Word / wc (Unix) word count #001' do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Counter.new(
        text: text,
        ellipsis: 'no_special_treatment',
        hyperlink: 'count_as_one',
        contraction: 'count_as_one',
        hyphenated_word: 'count_as_one',
        date: 'no_special_treatment',
        number: 'count',
        numbered_list: 'count',
        xhtml: 'keep',
        forward_slash: 'count_as_one',
        backslash: 'count_as_one',
        dotted_line: 'count',
        dashed_line: 'count',
        underscore: 'count',
        stray_punctuation: 'count'
      )
      expect(ws.count).to eq(71)
    end

    it 'reverse engineers the Microsoft Word / wc (Unix) word count #002' do
      text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
      ws = WordCountAnalyzer::Counter.new(text: text)
      expect(ws.mword_count).to eq(71)
    end
  end

  context 'example sentences' do
    it 'String with common words (no edge cases) #001' do
      ws = WordCountAnalyzer::Counter.new(text: 'This sentence contains nothing crazy.')
      expect(ws.count).to eq(5)
    end

    it 'String with a number #002' do
      ws = WordCountAnalyzer::Counter.new(text: 'This sentence contains 1 number.')
      expect(ws.count).to eq(5)
    end

    it 'String with a date #003' do
      ws = WordCountAnalyzer::Counter.new(text: 'Today is Monday, April 4th, 2011.')
      expect(ws.count).to eq(6)
    end

    it 'String #004' do
      ws = WordCountAnalyzer::Counter.new(text: 'hello world ...')
      expect(ws.count).to eq(2)
    end

    it 'does not split on unicode chars' do
      ws = WordCountAnalyzer::Counter.new(text: 'São Paulo')
      expect(ws.count).to eq(2)
    end

    it 'should not count HTML tags' do
      ws = WordCountAnalyzer::Counter.new(text: "<a href=\"http://thefamousfox.com\">the brown fox</a> jumped over the lazy dog")
      expect(ws.count).to eq(8)
    end

    it 'should handle special characters' do
      ws = WordCountAnalyzer::Counter.new(text: "the \"brown\" fox 'jumped' | over \\ the / lazy dog")
      expect(ws.count).to eq(8)
    end
  end
end
