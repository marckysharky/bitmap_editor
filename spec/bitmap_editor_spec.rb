require 'bitmap_editor'

RSpec.describe BitmapEditor do
  let(:args)   { double }
  let(:output) { double }

  subject(:editor) do
    described_class.new(args: args, output: output)
  end

  describe '#run!' do
    subject { editor.run! }

    it do
      expect(editor.cli).to receive(:call)
      subject
    end

    context 'start' do
      it do
        allow(editor.cli).to receive(:call) { true }
        expect(editor.interaction).to receive(:call)
        subject
      end
    end
  end
end
