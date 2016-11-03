class BitmapEditor
  class Interaction
    attr_reader :cli, :instructions, :image, :running

    def initialize(cli: , instructions: , image: )
      @cli = cli
      @instructions = instructions
      @image = image
    end

    def call
      @running = true

      cli.output.puts 'Starting...'

      (cli.options[:instructions] || []).each do |i|
        perform_instruction(i)
      end

      return unless cli.options[:interactive]

      while running
        @running = perform_instruction
      end
    end

    private

    def perform_instruction(instruction = nil)
      if instruction
        cli.output.puts "> #{instruction}"
      else
        cli.output.print '> '
      end

      instruction ||= cli.get_input

      instructions.call(instruction, image)
    end
  end
end
