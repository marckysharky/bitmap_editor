require 'bitmap_editor/argument_error'

class BitmapEditor
  class Image
    attr_reader :canvas

    def create(*args)
      w, h = validate_args(args, size: 2)

      validate_canvas_create(w, h)
      @canvas = (1..h.to_i).map { Array.new(w.to_i, 'O') }
    end

    def clear(*args)
      check_canvas
      create(@canvas[0].size, @canvas.size)
    end

    def fetch(x, y)
      get(x, y) { |arr, i| arr[i] }
    end

    def fill(*args)
      x, y, c = validate_args(args, size: 3)
      check_colour(c)

      get(x, y) { |arr, i| arr[i] = c }
    end

    def vertical(*args)
      x, y1, y2, c = validate_args(args, size: 4)

      (y1..y2).to_a.each do |y|
        block_given? ? yield(x, y, c) : fill(x, y, c)
      end
    end

    def horizontal(*args)
      x1, x2, y, c = validate_args(args, size: 4)

      (x1..x2).to_a.each do |x|
        block_given? ? yield(x, y, c) : fill(x, y, c)
      end
    end

    def flood(*args)
      a, b, c = validate_args(args, size: 3)
      a, b = a.to_i, b.to_i

      check_colour(c)
      check_canvas
      check_x_coordinate(a)
      check_y_coordinate(b)

      flood_fill(a, b, fetch(a, b), c)
    end

    def to_s
      return unless canvas
      canvas.each_with_object('') do |row, s|
        s << row.join('')
        s << "\n"
      end
    end

    private

    def flood_fill(x, y, _c, c)
      check_x_coordinate(x)
      check_y_coordinate(y)

      return false unless fetch(x, y) == _c

      fill(x, y, c)

      flood_fill(x - 1, y, _c, c)
      flood_fill(x + 1, y, _c, c)
      flood_fill(x, y - 1, _c, c)
      flood_fill(x, y + 1, _c, c)

      true
    rescue BitmapEditor::ArgumentError
      false
    end

    def get(*args)
      x, y = validate_args(args, size: 2)

      check_canvas
      check_x_coordinate(x)
      check_y_coordinate(y)

      x, y = normalize(x, y)

      yield(canvas[y], x)
    end

    def normalize(*args)
      args.map { |i| i.to_i - 1 }
    end

    def check_canvas
      raise ArgumentError, 'Image requires creation' unless canvas
    end

    def validate_canvas_create(w, h)
      w, h = w.to_i, h.to_i

      raise ArgumentError, 'Image width invalid' unless valid_dimension?(w)
      raise ArgumentError, 'Image height invalid' unless valid_dimension?(h)
    end

    def valid_dimension?(n)
      n.to_i >= 1 && n.to_i <= 250
    end

    def check_x_coordinate(*ns)
      Array(ns).each do |n|
        i = n.to_i
        raise ArgumentError, 'Coordinate invalid' if i < 1
        raise ArgumentError, 'Coordinate invalid' if i > canvas[0].size
      end
    end

    def check_y_coordinate(*ns)
      Array(ns).each do |n|
        i = n.to_i
        raise ArgumentError, 'Coordinate invalid' if i < 1
        raise ArgumentError, 'Coordinate invalid' if i > canvas.size
      end
    end

    def check_colour(c)
      s = c.to_s.codepoints
      raise ArgumentError, 'Colour invalid' unless s.size == 1
      raise ArgumentError, 'Colour invalid' unless s.first >= 65 && s.first <= 90
    end

    def validate_args(args, size: )
      raise ArgumentError, 'Unable to process command with given args' unless args.size == size
      args
    end
  end
end
