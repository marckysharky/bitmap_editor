require 'bitmap_editor/cli'
require 'bitmap_editor/image'
require 'bitmap_editor/instructions'
require 'bitmap_editor/interaction'

class BitmapEditor
  attr_reader :args, :output

  def initialize(args: , output: )
    @args   = args
    @output = output
  end

  def cli
    @cli ||= Cli.new(args: args, output: output)
  end

  def instructions
    @instructions ||= Instructions.new(output: output)
  end

  def image
    @image ||= Image.new
  end

  def interaction
    @interaction ||= Interaction.new(cli: cli, instructions: instructions, image: image)
  end

  def run!
    return unless cli.call
    interaction.call
  end
end
