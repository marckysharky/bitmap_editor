class BitmapEditor
  class Instructions
    MAPS = {
      'I' => { action: :create,
               help: "%s M N - Create a new M x N image with all pixels coloured white (O)" },
      'C' => { action: :clear,
               help: "%s - Clears the table, setting all pixels to white (O)" },
      'L' => { action: :fill,
               help: "%s X Y C - Colours the pixel (X,Y) with colour C" },
      'V' => { action: :vertical,
               help: "%s X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive)"  },
      'H' => { action: :horizontal,
               help: "%s X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive)"  },
      'S' => { action: :show,
               help: "%s - Show the contents of the current image"  },
      '?' => { action: :help },
      'X' => { action: :quit,
               help: "%s - Terminate the session"  }
    }

    attr_reader :output

    def initialize(output: )
      @output = output
    end

    def create(image, input)
      image.create(*input)
      true
    end

    def clear(image, _input)
      image.clear
      true
    end

    def fill(image, input)
      image.fill(*input)
      true
    end

    def vertical(image, input)
      image.vertical(*input)
      true
    end

    def horizontal(image, input)
      image.horizontal(*input)
      true
    end

    def show(image, _input)
      output.print image
      true
    end

    def error(e)
      output.print "#{e.message}\n"
    end

    def help(_image, _input)
      output.print instructions.join("\n") << "\n"
      true
    end

    def quit(_image, input)
      output.print "\n" unless input
      output.print "Goodbye!\n"
      false
    end

    def not_implemented
      output.print "I'm sorry, I did not recognise the command\n"
      true
    end

    def call(i, image)
      return quit(image, i) if i.nil?

      input        = i.split(' ')
      input_action = (input.first || '').strip
      action       = action_for(input_action)

      return not_implemented unless action

      send(action, image, input[1..-1])
    rescue BitmapEditor::InputError => e
      error e
      true
    end

    def action_for(a)
      (MAPS[a] || {})[:action]
    end

    def instructions
      MAPS.map { |k, v| sprintf(v[:help], k) if v[:help] }
          .compact
    end
  end
end
