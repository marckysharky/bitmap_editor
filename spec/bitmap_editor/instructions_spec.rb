require 'bitmap_editor/instructions'

RSpec.describe BitmapEditor::Instructions do
  let(:output) { StringIO.new }
  let(:image)  { double(:image) }

  subject(:instruction) do
    described_class.new(output: output)
  end

  describe '#call' do
    subject { instruction.call(input, image) }

    context 'I' do
      let(:input) { 'I x y' }

      it do
        expect(image).to receive(:create).with('x', 'y')
        subject
      end
    end

    context 'C' do
      let(:input) { 'C' }

      it do
        expect(image).to receive(:clear)
        subject
      end
    end

    context 'L' do
      let(:input) { 'L a b c' }

      it do
        expect(image).to receive(:fill).with('a', 'b', 'c')
        subject
      end
    end

    context 'V' do
      let(:input) { 'V a b c d' }

      it do
        expect(image).to receive(:vertical).with('a', 'b', 'c', 'd')
        subject
      end
    end

    context 'H' do
      let(:input) { 'H a b c d' }

      it do
        expect(image).to receive(:horizontal).with('a', 'b', 'c', 'd')
        subject
      end
    end

    context 'S' do
      let(:input) { 'S' }

      it do
        expect(image).to receive(:to_s)
        subject
      end
    end

    context '?' do
      let(:input) { '?' }

      it { is_expected.to eq(true) }

      it do
        subject
        expect(output.string).to include("I M N -")
        expect(output.string).to include("C -")
        expect(output.string).to include("L X Y C -")
        expect(output.string).to include("V X Y1 Y2 C -")
        expect(output.string).to include("H X1 X2 Y C -")
        expect(output.string).to include("S -")
        expect(output.string).to include("X -")
      end
    end

    context 'X' do
      let(:input) { 'X' }

      it { is_expected.to eq(false) }

      it do
        subject
        expect(output.string).to eq("Goodbye!\n")
      end
    end

    context '-' do
      let(:input) { '-' }

      it { is_expected.to eq(true) }

      it do
        subject
        expect(output.string).to eq("I'm sorry, I did not recognise the command\n")
      end
    end

    context 'input error' do
      let(:input) { 'C 1 1' }

      before do
        allow(image).to receive(:clear) { raise BitmapEditor::ArgumentError, 'test-input-error' }
      end

      it { is_expected.to eq(true) }

      it do
        subject
        expect(output.string).to include('test-input-error')
      end
    end
  end
end
