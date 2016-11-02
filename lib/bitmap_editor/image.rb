require 'bitmap_editor/input_error'

class BitmapEditor
  class Image
    attr_reader :canvas

    def create(w, h)
      validate_canvas_create(w, h)
      @canvas = (1..h.to_i).map { Array.new(w.to_i, 'O') }
    end

    def clear
      check_canvas
      create(@canvas[0].size, @canvas.size)
    end

    def fetch(x, y)
      check_canvas
      check_x_coordinate(x)
      check_y_coordinate(y)

      x, y = normalize(x, y)
      canvas[y][x]
    end

    def fill(x, y, c)
      check_canvas
      check_x_coordinate(x)
      check_y_coordinate(y)
      check_colour(c)

      x, y = normalize(x, y)
      canvas[y][x] = c
    end

    def vertical(x, y1, y2, c)
      (y1..y2).to_a.each do |y|
        fill(x, y, c)
      end
    end

    def horizontal(x1, x2, y, c)
      (x1..x2).to_a.each do |x|
        fill(x, y, c)
      end
    end

    def to_s
      return unless canvas
      canvas.each_with_object('') do |row, s|
        s << row.join('')
        s << "\n"
      end
    end

    def normalize(*args)
      args.map { |i| i.to_i - 1 }
    end

    def check_canvas
      raise InputError, 'Image requires creation' unless canvas
    end

    def validate_canvas_create(w, h)
      w, h = w.to_i, h.to_i

      raise InputError, 'Image width invalid' unless valid_dimension?(w)
      raise InputError, 'Image height invalid' unless valid_dimension?(h)
    end

    def valid_dimension?(n)
      n.to_i >= 1 && n.to_i <= 250
    end

    def check_x_coordinate(*ns)
      Array(ns).each do |n|
        i = n.to_i
        raise InputError, 'Coordinate invalid' if i < 1
        raise InputError, 'Coordinate invalid' if i > canvas[0].size
      end
    end

    def check_y_coordinate(*ns)
      Array(ns).each do |n|
        i = n.to_i
        raise InputError, 'Coordinate invalid' if i < 1
        raise InputError, 'Coordinate invalid' if i > canvas.size
      end
    end

    def check_colour(c)
      s = c.to_s.codepoints
      raise InputError, 'Colour invalid' unless s.size == 1
      raise InputError, 'Colour invalid' unless s.first >= 65 && s.first <= 90
    end
  end
end
