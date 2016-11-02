$LOAD_PATH.unshift File.expand_path('./lib', __dir__)
require 'bitmap_editor'

BitmapEditor.new(args: ARGV, output: STDOUT).run!
