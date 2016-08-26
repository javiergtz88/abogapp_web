module AppLeyes
  def self.version
    VERSION::STRING
  end

  module VERSION
    MAJOR = 1
    MINOR = 2
    TINY  = 3
    PRE   = ''

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end