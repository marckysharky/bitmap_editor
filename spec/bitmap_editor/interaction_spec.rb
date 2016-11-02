require 'spec_helper'
require 'bitmap_editor/interaction'

RSpec.describe BitmapEditor::Interaction do
  let(:options)       { { instructions: [], interactive: false } }
  let(:cli)           { double(output: StringIO.new, options: options) }
  let(:instructions)  { double }
  let(:image)         { double }

  subject(:interaction) do
    described_class.new(cli: cli, instructions: instructions, image: image)
  end

  describe '#call' do
    subject { interaction.call }

    it 'shows start' do
      subject
      expect(cli.output.string).to include('Starting')
    end

    context 'instructions from CLI' do
      let(:instruction) { '~ foo bar' }

      it do
        allow(options).to receive(:[]).with(:interactive) { false }
        expect(options).to receive(:[]).with(:instructions) { [instruction] }
        expect(instructions).to receive(:call).with(instruction, image)
        subject
      end
    end

    context 'instructions from input' do
      let(:instruction) { 'X' }

      it do
        allow(options).to receive(:[]).with(:instructions) { [] }
        allow(options).to receive(:[]).with(:interactive) { true }
        expect(cli).to receive(:get_input) { instruction }
        expect(instructions).to receive(:call).with(instruction, image)
        subject
      end
    end
  end
end
