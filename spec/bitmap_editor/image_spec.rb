require 'spec_helper'
require 'bitmap_editor/image'

RSpec.describe BitmapEditor::Image do
  subject(:image) { described_class.new }

  describe '#create' do
    let(:w) { 2 }
    let(:h) { 3 }

    subject do
      image.tap { |i| i.create(w, h) }
    end

    it do
      expect(subject.canvas).to eq([["O", "O"], ["O", "O"], ["O", "O"]])
    end

    context 'negative canvas size' do
      it_behaves_like 'input error' do
        subject { image.create(-1, -1) }
      end
    end

    context 'too large canvas size' do
      it_behaves_like 'input error' do
        subject { image.create(251, 251) }
      end
    end
  end

  describe '#clear' do
    subject do
      image.tap do |i|
        i.create(2, 2)
        i.fill(1, 1, 'C')
      end
    end

    it do
      expect(subject.canvas).to eq([['C', "O"], ["O", "O"]])
      subject.clear
      expect(subject.canvas).to eq([["O", "O"], ["O", "O"]])
    end

    context 'missing canvas' do
      it_behaves_like 'input error' do
        subject { image.clear }
      end
    end
  end

  describe '#to_s' do
    subject { image.to_s }

    it { is_expected.to be_nil }

    context 'canvas created' do
      it do
        image.create(2,2)
        expect(subject).to eq("OO\nOO\n")
      end
    end
  end
end
