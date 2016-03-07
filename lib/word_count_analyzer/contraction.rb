module WordCountAnalyzer
  class Contraction
    CONTRACTIONS = {
      "i'm"               => "I am",
      "i'll"              => "I will",
      "i'd"               => "I would",
      "i've"              => "I have",
      "you're"            => "you are",
      "you'll"            => "you will",
      "you'd"             => "you would",
      "you've"            => "you have",
      "he's"              => "he is",
      "he'll"             => "he will",
      "he'd"              => "he would",
      "she's"             => "she is",
      "she'll"            => "she will",
      "she'd"             => "she would",
      "it's"              => "it is",
      "'tis"              => "it is",
      "it'll"             => "it will",
      "it'd"              => "it would",
      "we're"             => "we are",
      "we'll"             => "we will",
      "we'd"              => "we would",
      "we've"             => "we have",
      "they're"           => "they are",
      "they'll"           => "they will",
      "they'd"            => "they would",
      "they've"           => "they have",
      "that's"            => "that is",
      "that'll"           => "that will",
      "that'd"            => "that would",
      "who's"             => "who is",
      "who'll"            => "who will",
      "who'd"             => "who would",
      "what's"            => "what is",
      "what're"           => "what are",
      "what'll"           => "what will",
      "what'd"            => "what would",
      "where's"           => "where is",
      "where'll"          => "where will",
      "where'd"           => "where would",
      "when's"            => "when is",
      "when'll"           => "when will",
      "when'd"            => "when would",
      "why's"             => "why is",
      "why'll"            => "why will",
      "why'd"             => "why would",
      "how's"             => "how is",
      "how'll"            => "how will",
      "how'd"             => "how would",
      "she'd've"          => "she would have",
      "'tisn't"           => "it is not",
      "isn't"             => "is not",
      "aren't"            => "are not",
      "wasn't"            => "was not",
      "weren't"           => "were not",
      "haven't"           => "have not",
      "hasn't"            => "has not",
      "hadn't"            => "had not",
      "won't"             => "will not",
      "wouldn't"          => "would not",
      "don't"             => "do not",
      "doesn't"           => "does not",
      "didn't"            => "did not",
      "can't"             => "cannot",
      "couldn't"          => "could not",
      "shouldn't"         => "should not",
      "mightn't"          => "might not",
      "mustn't"           => "must not",
      "would've"          => "would have",
      "should've"         => "should have",
      "could've"          => "could have",
      "might've"          => "might have",
      "must've"           => "must have",
      "o'"                => "of",
      "o'clock"           => "of the clock",
      "ma'am"             => "madam",
      "ne'er-do-well"     => "never-do-well",
      "cat-o'-nine-tails" => "cat-of-nine-tails",
      "jack-o'-lantern"   => "jack-of-the-lantern",
      "will-o'-the-wisp"  => "will-of-the-wisp",
      "'twas"             => "it was"
    }.freeze

    attr_reader :token, :following_token, :tgr, :hyphen
    def initialize(token:, following_token:, tgr:, **args)
      @token = token
      @following_token = following_token
      @tgr = tgr
      @hyphen = args[:hyphen] || 'count_as_one'
    end

    def contraction?
      common_contraction? ||
      (apostrophe_s_token? &&
        following_is_not_a_noun?)
    end

    def expanded_count
      if self.contraction?
        if common_contraction?
          calculate_contraction_length
        else
          2
        end
      else
        1
      end
    end

    def replace
      if CONTRACTIONS.has_key?(token.downcase)
        CONTRACTIONS[token.downcase]
      elsif apostrophe_s_token? && following_is_not_a_noun?
        ' word word '
      else
        token
      end
    end

    private

    def calculate_contraction_length
      if hyphen.eql?('count_as_one') && hyphen
        contraction_length
      else
        contraction_length_hyphen
      end
    end

    def contraction_length
      CONTRACTIONS[token.downcase].split(' ').length
    end

    def contraction_length_hyphen
      CONTRACTIONS[token.downcase].split(' ').map { |token| token.split('-') }.flatten.length
    end

    def common_contraction?
      CONTRACTIONS.has_key?(token.downcase)
    end

    def following_is_not_a_noun?
      !tgr.add_tags(following_token)[1].downcase.eql?('n')
    end

    def apostrophe_s_token?
      token.include?("'s")
    end
  end
end