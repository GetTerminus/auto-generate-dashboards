#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "./assets/lexer.rex".
#++


class HCLLexer
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/\s+/))
        ;

      when (text = @ss.scan(/\#.*|\/\/.*$/))
        ;

      when (text = @ss.scan(/\n|\r/))
        ;

      when (text = @ss.scan(/\/\*/))
         action { consume_comment(text) }

      when (text = @ss.scan(/true|false/))
         action { [:BOOL,         to_boolean(text)]}

      when (text = @ss.scan(/\-?\d+\.\d+/))
         action { [:FLOAT,        text.to_f] }

      when (text = @ss.scan(/-?\d+/))
         action { [:NUMBER,       text.to_i] }

      when (text = @ss.scan(/\"/))
         action { [:STRING,       consume_string(text)] }

      when (text = @ss.scan(/\<<-/))
         action { [:STRING,       consume_heredoc] }

      when (text = @ss.scan(/\{/))
         action { [:LEFTBRACE,    text]}

      when (text = @ss.scan(/\}/))
         action { [:RIGHTBRACE,   text]}

      when (text = @ss.scan(/\[/))
         action { [:LEFTBRACKET,  text]}

      when (text = @ss.scan(/\]/))
         action { [:RIGHTBRACKET, text]}

      when (text = @ss.scan(/\,/))
         action { [:COMMA,        text]}

      when (text = @ss.scan(/[a-zA-Z_][a-zA-Z0-9_\-\.]*/))
         action { [:IDENTIFIER,   text]}

      when (text = @ss.scan(/\=/))
         action { [:EQUAL,        text]}

      when (text = @ss.scan(/\-/))
         action { [:MINUS,        text]}

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

  def lex(input)
    scan_setup(input)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
  def to_boolean(input)
    input =
      if input =~ /true/
        true
      elsif input =~ /false/
        false
      end
    return input
  end
  def consume_comment(input)
    nested = 1
    until nested.zero?
      case(text = @ss.scan_until(%r{/\*|\*/|\z}) )
      when %r{/\*\z}
        nested =+ 1
      when %r{\*/\z}
        nested -= 1
      else
        break
      end
    end
  end
  def consume_string(input)
    result = ''
    nested = 0
    begin
      case(text = @ss.scan_until(%r{\"|\$\{|\}|\\}))
      when %r{\$\{\z}
        nested += 1
      when %r{\}\z}
        nested -= 1 if nested > 0
      when %r{\\\z}
        result += text.chop + @ss.getch
        next
      end
      result += text.to_s
    end until nested == 0 && text =~ %r{\"\z}
    result.chop
  end
  def consume_heredoc
      token = Regexp.new @ss.scan_until(%r{\n})
      document = @ss.scan_until(token)
      document.chop
  end
end # class