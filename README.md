# Word Count Analyzer

See what word count [gray areas](#gray-area-details) might be affecting your word count.

Word Count Analyzer is a Ruby gem that analyzes a string for potential areas of the text that might cause word count discrepancies depending on the tool used. It also provides comprehensive configuration options so you can easily customize how different gray areas should be counted and find the right word count for your purposes.

If you prioritize speed over accuracy, then I recommend not using this gem. There are most definitely faster gems for getting a word count. However, if accuracy is important, and you want control over the gray areas that affect word count, then this gem is for you.

##Install  

**Ruby**  
*Supports Ruby 2.1.0 and above*  
```
gem install word_count_analyzer
```

**Ruby on Rails**  
Add this line to your application’s Gemfile:  
```ruby 
gem 'word_count_analyzer'
```

## Usage

### Analyze the word count gray areas of a string

Common word count gray areas include (*[more details below](#gray-area-details)*):
- Ellipses
- Hyperlinks
- Contractions
- Hyphenated Words
- Dates
- Numbers
- Numbered Lists
- XML and HTML tags
- Forward slashes and backslashes
- Punctuation

Other gray areas not covered by this gem:
- Headers
- Footers
- Hidden Text (*specific to Microsoft Word*)

```ruby
text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 4. <html> Some HTML and a hyphenated-word</html>. Don't count stray punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"
WordCountAnalyzer::Analyzer.new(text: text).analyze

# =>   {
#        "ellipsis": 1,
#        "hyperlink": 2,
#        "contraction": 4,
#        "hyphenated_word": 2, 
#        "date": 2,
#        "number": 1,
#        "numbered_list": 3,
#        "xhtml": 1,
#        "forward_slash": 1,
#        "backslash": 1,
#        "dotted_line": 1,
#        "dashed_line": 1,
#        "underscore": 1,
#        "stray_punctuation": 5
#      }
```

### Count the words in a string

```ruby
text = "This string has a date: Monday, November 3rd, 2011. I was thinking... it also shouldn't have too many contractions, maybe 2. <html> Some HTML and a hyphenated-word</html>. Don't count punctuation ? ? ? Please visit the ____________ ------------ ........ go-to site: https://www.example-site.com today. Let's add a list 1. item a 2. item b 3. item c. Now let's add he/she/it or a c:\\Users\\john. 2/15/2012 is the date! { HYPERLINK 'http://www.hello.com' }"

WordCountAnalyzer::Counter.new(text: text).count
# => 64

# Overrides all settings to match the way Pages handles word count. 
# N.B. The developers of Pages may change the algorithm at any time so this should just be as an approximation.
WordCountAnalyzer::Counter.new(text: text).pages_count
# => 79

# Overrides all settings to match the way Microsoft Word and wc (Unix) handle word count. 
# N.B. The developers of these tools may change the algorithm at any time so this should just be as an approximation.

WordCountAnalyzer::Counter.new(text: text).mword_count
# => 71

# Highly configurable (see all options below)
WordCountAnalyzer::Counter.new(
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
).count

# => 77
```

#### Counter `options`

##### `ellipsis`
  **default** = `'ignore'`
- `'ignore'`  
  Ignores all ellipses in the word count total.
- `'no_special_treatment'`   
  Ellipses will not be searched for in the string.

<hr>

##### `hyperlink`
  **default** = `'count_as_one'`
- `'count_as_one'`  
  Counts a hyperlink as one word.
- `'no_special_treatment'`   
  Hyperlinks will not be searched for in the string. Therefore, how a hyperlink is handled in the word count will depend on other settings (mainly slashes).
- `'split_at_period'`   
  Pages will split hyperlinks at a period and count each token as a separate word.  

<hr>

##### `contraction`
  **default** = `'count_as_one'`
- `'count_as_one'`  
  Counts a contraction as one word.
- `'count_as_multiple'`   
  Splits a contraction into the words that make it up. Examples:
  - `don't` => `do not` (2 words)
  - `o'clock` => `of the clock` (3 words)  

<hr>

##### `hyphenated_word`
  **default** = `'count_as_one'`
- `'count_as_one'`  
  Counts a hyphenated word as one word.
- `'count_as_multiple'`   
  Breaks a hyphenated word at each hyphen and counts each word separately. Example:
  - `devil-may-care` (3 words)

<hr>

##### `date`
  **default** = `'no_special_treatment'`
- `'count_as_one'`  
  Counts a date as one word. This is more commonly seen in translation CAT tools where a date is thought of as a *placeable* that can usually be automatically translated. Examples:
  - Monday, April 4th, 2011 (1 word)
  - April 4th, 2011 (1 word)
  - 04/04/2011 (1 word)
  - 04.04.2011 (1 word)
  - 2011/04/04 (1 word)
  - 2011-04-04 (1 word)
  - 2003Nov9 (1 word)
  - 2003 November 9 (1 word)
  - 2003-Nov-9 (1 word)
  - and others...
- `'no_special_treatment'`   
  Dates will not be searched for in the string. Therefore, how a date is handled in the word count will depend on other settings.

<hr>

##### `number`
  **default** = `'count'`
- `'count'`  
  Counts a number as one word.
- `'ignore'`   
  Ignores any numbers in the string (with the exception of `dates` and `numbered_lists`) and does not count them towards the word count.

<hr>

##### `numbered_list`
  **default** = `'count'`
- `'count'`  
  Counts a number in a numbered list as one word.
- `'ignore'`   
  Ignores any numbers that are part of a numbered list and does not count them towards the word count.

<hr>

##### `xhtml`
  **default** = `'remove'`
- `'remove'`  
  Removes any XML or HTML opening and closing tags from the string.
- `'keep'`   
  Ignores any XML or HTML in the string.  

<hr>

##### `forward_slash`
  **default** = `'count_as_multiple_except_dates'`
- `'count_as_one'`  
  Counts any tokens that include a forward slash as one word. Example:
  - she/he/it (1 word)
- `'count_as_multiple'`   
  Separates any tokens that include a forward slash at the slash(s) and counts each token individually. Whether dates, hyperlinks and xhtml are included depends on what is set for those options. Example:
  - she/he/it (3 words)
- `'count_as_multiple_except_dates'`   
  Separates any tokens that include a forward slash (except dates) at the slash(s) and counts each token individually. Example:
  - she/he/it 4/25/2014 (4 words)  

<hr>

##### `backslash`
  **default** = `'count_as_one'`
- `'count_as_one'`  
  Counts any tokens that include a backslash as one word. Example:
  - c:\Users\johndoe (1 word)
- `'count_as_multiple'`   
  Separates any tokens that include a backslash at the slash(s) and counts each token individually. Example:
  - c:\Users\johndoe (3 words)

<hr>

##### `dotted_line`
  **default** = `'ignore'`
- `'count'`  
  Counts a dotted line as one word.
- `'ignore'`   
  Ignores any dotted lines in the string and does not count them towards the word count.

<hr>

##### `dashed_line`
  **default** = `'ignore'`
- `'count'`  
  Counts a dashed line as one word.
- `'ignore'`   
  Ignores any dashed lines in the string and does not count them towards the word count.

<hr>

##### `underscore`
  **default** = `'ignore'`
- `'count'`  
  Counts a series of underscores as one word.
- `'ignore'`   
  Ignores any series of underscores in the string and does not count them towards the word count.      

<hr>

##### `stray_punctuation`
  **default** = `'ignore'`
- `'count'`  
  Counts a punctuation mark surrounded on both sides by a whitespace as one word.
- `'ignore'`   
  Ignores any punctuation marks surrounded on both sides by a whitespace in the string and does not count them towards the word count.     

### Gray Area Details

#### Ellipsis

Checks for any occurrences of ellipses in your text. Writers tend to use different formats for ellipsis, and although there are [style guides](http://www.thepunctuationguide.com/ellipses.html), it is rare that these rules are followed.

##### Three Consecutive Periods
```
...
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

##### Four Consecutive Periods
```
....
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

##### Three Periods With Spaces
```
 . . .
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 3
Pages          | 0
wc (Unix)      | 3

##### Four Periods With Spaces
```
 . . . .
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 4
Pages          | 0
wc (Unix)      | 4

##### Horizontal Ellipsis
```
…
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

#### Hyperlink

```
http://www.example.com
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 4
wc (Unix)      | 1

#### Contraction

Most tools count contractions as one word. [Some might argue](http://english.stackexchange.com/questions/80635/counting-contractions-as-one-or-two-words) a contraction is technically more than one word.

```
can't
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 1
wc (Unix)      | 1

#### Hyphenated Word

```
devil-may-care
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 3
wc (Unix)      | 1

#### Date

Most word processing tools do not do recognize dates, but translation CAT tools tend to recognize dates as one word or [placeable](http://www.wordfast.net/wiki/Placeables). This gem checks for many date formats including those that include day or month abbreviations. A few examples are listed below (*not an exhaustive list*).

##### Date (example A)
```
Monday, April 4th, 2011
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 4
Pages          | 4
wc (Unix)      | 4

##### Date (example B)
```
04/04/2011
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 3
wc (Unix)      | 1

##### Date (example C)
```
04.04.2011
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 1
wc (Unix)      | 1

#### Number

##### Simple number
```
200
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 1
wc (Unix)      | 1

##### Number with preceding unit
```
$200
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 1
wc (Unix)      | 1


##### Number with unit following
```
50%
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 1
wc (Unix)      | 1

#### Numbered List

```
1. List item a 
2. List item b
3. List item c
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 12
Pages          | 9
wc (Unix)      | 12

#### XML and HTML Tags

```html
<span class="large-text">Hello world</span> <new-tag>Hello</new-tag>
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 4
Pages          | 12
wc (Unix)      | 4

#### Slashes

##### Forward slash
```
she/he/it
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 3
wc (Unix)      | 1

##### Backslash
```
c:\Users\johndoe
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 3
wc (Unix)      | 1

#### Punctuation

##### Dotted line
```
.........
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

```
………………………
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

##### Dashed line
```
-----------
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

##### Underscore
```
____________
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

##### Punctuation mark surrounded by spaces
```
 : 
```
Tool           | Word Count 
-------------- | ----------
Microsoft Word | 1
Pages          | 0
wc (Unix)      | 1

## Research

- *[So how many words do you think it is?](http://multifarious.filkin.com/2012/11/13/wordcount)* - Paul Filkin
- [Word Count](http://en.wikipedia.org/wiki/Word_count) - Wikipedia
- [Words Counted Ruby Gem](https://github.com/abitdodgy/words_counted) - Mohamad El-Husseini

## Contributing

1. Fork it ( https://github.com/diasks2/word_count_analyzer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2015 Kevin S. Dias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.