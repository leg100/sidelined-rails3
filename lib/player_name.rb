class PlayerName
  attr_reader :tokens
  def initialize(wiki_title)
    without_brackets = wiki_title.strip.gsub(/\s?\([^\)]+\)/, '')
    @tokens = without_brackets.strip.split(/ /)
  end
  
  def to_s
    tokens.join(' ')
  end

  def surname
    surname_tokens.join(" ")
  end
  
  def forename
    forename_tokens.join(" ")
  end
  
  def surname_tokens
    if stupid_brazilian_name?
      return tokens
    elsif van?
      return tokens[1..-1].to_a
    else
      return tokens.last.to_a
    end
  end

  def forename_tokens
    if stupid_brazilian_name?
      return []
    elsif van?
      return tokens[0].to_a
    else
      return tokens[0...-1].to_a
    end
  end

  def stupid_brazilian_name?
    tokens.length == 1
  end
  
  def double_barrel?
    surname_tokens.last =~ /\-/
  end
  
  def double_barrel_components
    surname_tokens.last.split(/\-/)
  end

  def van?
    tokens[1] =~ /^van$/i
  end

  def mick?
    surname_tokens.last =~ /^O'/ 
  end
  
  def dune_coon?
    surname_tokens.last =~ /^Al'/ 
  end

  def is_it_coz_i_is_from_africa?
    surname_tokens.last =~ /^N'/ 
  end
 
  def apostrophe?
    mick? || dune_coon? || is_it_coz_i_is_from_africa?
  end
 
  def apostrophe_components
    surname_tokens.last.split(/\'/)
  end
  
  def family_of?
    (surname_tokens.length > 1) and surname_tokens.grep(/^[a-z]/)
  end

  def self.tla(name)
    if name.is_a?(String)
      name[0..2].parameterize.upcase
    elsif name.is_a?(Array)
      name.map{|n| n[0] }[0...3].join.parameterize.upcase
    else
      nil
    end
  end

  def trkref
    if stupid_brazilian_name?
      PlayerName.tla(surname)
    elsif double_barrel?
      PlayerName.tla([forename_tokens.first, double_barrel_components].flatten)
    elsif apostrophe?
      PlayerName.tla([forename_tokens.first, apostrophe_components].flatten)
    elsif family_of?
      PlayerName.tla([forename_tokens.first, surname_tokens[-2..-1]].flatten)
    elsif surname_tokens.length > 2
      PlayerName.tla(surname_tokens)
    elsif forename_tokens.length > 2
      PlayerName.tla(forename_tokens)
    else
      PlayerName.tla(surname)
    end 
  end
end


