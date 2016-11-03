require 'optparse'

class BitmapEditor
  class Cli
    attr_reader :args, :options, :output

    def initialize(args: [], output: STDOUT)
      @args    = args.dup
      @output  = output
      @options = { interactive: true }
    end

    def call
      command = (args[0] || '').to_s.strip

      if command != 'start'
        output.puts optparse
        return false
      end

      optparse.parse!(args)

      true
    end

    def get_input
      STDIN.gets.chomp.strip
    rescue Interrupt
      nil
    end

    def close_input
      STDIN.close
    end

    private

    def optparse
      OptionParser.new do |opts|
        opts.banner = 'Usage: bitmap_editor start|help'

        opts.on("--[no-]interaction", "Run interactively") do |v|
          options[:interactive] = v
        end

        opts.on("-i=INSTRUCTION", "--instruction=INSTRUCTION", "Perform instruction") do |n|
          options[:instructions] ||= []
          options[:instructions] << n.strip
        end
      end
    end
  end
end
