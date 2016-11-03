require 'spec_helper'
require 'bitmap_editor/image'

RSpec.describe BitmapEditor::Image do
  subject(:image) { described_class.new }

  describe '#horizontal' do
    let(:x1) { 3 }
    let(:x2) { 5 }
    let(:y)  { 2 }
    let(:c)  { 'Z' }

    subject do
      image.tap do |i|
        i.create(5, 6)
        i.horizontal(x1, x2, y, c)
      end
    end

    it do
      row = subject.canvas[(y - 1)]
      expect(row).to eq(["O", "O", 'Z', 'Z', 'Z'])
    end

    context 'missing canvas' do
      it_behaves_like 'input error' do
        subject { image.horizontal(x1, x2, y, c) }
      end
    end

    context 'invalid x1 coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.horizontal(-1, 2, 2, c)
        end
      end
    end

    context 'invalid x1 coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.horizontal(2, 3, 2, c)
        end
      end
    end

    context 'invalid y coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.horizontal(2, 2, 3, c)
        end
      end
    end

    context 'invalid colour' do
      before { image.create(2, 2) }

      it_behaves_like 'input error' do
        subject { image.horizontal(2, 2, 2, -1) }
      end

      it_behaves_like 'input error' do
        subject { image.horizontal(2, 2, 2, 'a') }
      end

      it_behaves_like 'input error' do
        subject { image.horizontal(2, 2, 2, '~') }
      end
    end
  end
end
