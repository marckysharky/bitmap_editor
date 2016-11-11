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

      (y1..y2).to_a.each { |y| fill(x, y, c) }
    end

    def horizontal(*args)
      x1, x2, y, c = validate_args(args, size: 4)

      (x1..x2).to_a.each { |x| fill(x, y, c) }
    end

    def flood(*args)
    end

    def to_s
      return unless canvas
      canvas.each_with_object('') do |row, s|
        s << row.join('')
        s << "\n"
      end
    end

    private

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
