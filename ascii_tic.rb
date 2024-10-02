# encoding: UTF-8
# from the code dating back to 2009: https://github.com/tomash/ascii_tic

# Removes HTML tags from a string. Allows you to specify some tags to be kept.
module AsciiTic
  def strip_html( allowed = [] )
    re = if allowed.any?
      Regexp.new(
        %(<(?!(\\s|\\/)*(#{
          allowed.map {|tag| Regexp.escape( tag )}.join( "|" )
        })( |>|\\/|'|"|<|\\s*\\z))[^>]*(>+|\\s*\\z)),
        ##'
        Regexp::IGNORECASE | Regexp::MULTILINE, 'u'
      )
    else
      /<[^>]*(>+|\s*\z)/m
    end
    gsub(re,'')
  end

  def capitalize_every_word
    split(/\s+/).each{ |word| word.capitalize! }.join(' ')
  end

  def to_ascii_brutal
   #foo = self.downcase.strip
   foo = String.new(self)
   #foo = self.clone #.downcase.strip
   foo.gsub!(/[ĄÀ�?ÂÃ]/,'A')
   foo.gsub!(/[âäàãáäå�?ăąǎǟǡǻ�?ȃȧẵặ]/,'a')
   foo.gsub!(/[Ę]/,'E')
   foo.gsub!(/[ëêéèẽēĕėẻȅȇẹȩęḙḛ�?ếễểḕḗệ�?]/,'e')
   foo.gsub!(/[Ì�?ÎĨ]/,'I')
   foo.gsub!(/[�?iìíîĩīĭïỉ�?ịįȉȋḭɨḯ]/,'i')
   foo.gsub!(/[ÒÓÔÕÖ]/,'O')
   foo.gsub!(/[òóôõ�?�?ȯö�?őǒ�?�?ơǫ�?ɵøồốỗổȱȫȭ�?�?ṑṓ�?ớỡởợǭộǿ]/,'o')
   foo.gsub!(/[ÙÚÛŨÜ]/,'U')
   foo.gsub!(/[ùúûũūŭüủůűǔȕȗưụṳųṷṵṹṻǖǜǘǖǚừứữửự]/,'u')
   foo.gsub!(/[ỳýŷỹȳ�?ÿỷẙƴỵ]/,'y')
   foo.gsub!(/[œ]/,'oe')
   foo.gsub!(/[ÆǼǢæ]/,'ae')
   foo.gsub!(/[Ń]/,'N')
   foo.gsub!(/[ñǹń]/,'n')
   foo.gsub!(/[ÇĆČ]/,'C')
   foo.gsub!(/[çćč]/,'c')
   foo.gsub!(/[ß]/,'ss')
   foo.gsub!(/[œ]/,'oe')
   foo.gsub!(/[ĳ]/,'ij')
   foo.gsub!(/[Ł]/,'L')
   foo.gsub!(/[�?ł]/,'l')
   foo.gsub!(/[ŚŠ]/,'S')
   foo.gsub!(/[śš]/,'s')
   foo.gsub!(/[Ț]/,'T')
   foo.gsub!(/[ț]/,'t')
   foo.gsub!(/[ŹŻ]/,'Z')
   foo.gsub!(/[źż]/,'z')
   #foo.sub!(/[\s\'\"\\\/\?\.\=\+\&\%]$/,'')
   #foo.gsub!(/[\s\'\"\\\/\?\.\=\+\&\%]/,'_')
   #foo.gsub!(/_+/,'_')

   # also remove characters that Windows doesn't like
   foo.gsub!(/[&]/, 'and')
   foo.gsub!(/[\\:*?"<>|]/, '')

   foo
  end

  def to_permalink(separator = '-')
    permalink = self.to_ascii_brutal
    #permalink = string.to_ascii_brutal
    # all down
    permalink.downcase!

    # preserve alphanumerics, everything else becomes a separator
    permalink.gsub!(/[^a-z0-9]+/, separator)

    # enforce the maximum component length and return it
    #permalink = permalink.to(max_size)

    # trim any leading or trailing separators
    return permalink.gsub(/^\#{separator}+|\#{separator}+$/, '')
  end

end
