require 'spec_helper'
require 'bitmap_editor/image'

RSpec.describe BitmapEditor::Image do
  subject(:image) { described_class.new }

  describe '#vertical' do
    let(:x)  { 2 }
    let(:y1) { 3 }
    let(:y2) { 6 }
    let(:c)  { 'W' }

    subject do
      image.tap do |i|
        i.create(5, 6)
        i.vertical(x, y1, y2, c)
      end
    end

    it do
      subject.canvas[(y1 - 1)..(y2 - 1)].each do |row|
        expect(row).to eq(["O", 'W', "O", "O", "O"])
      end
    end

    context 'missing canvas' do
      it_behaves_like 'input error' do
        subject { image.vertical(x, y1, y2, c) }
      end
    end

    context 'invalid x coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.vertical(3, 2, 2, c)
        end
      end
    end

    context 'invalid y1 coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.vertical(2, -1, 2, c)
        end
      end
    end

    context 'invalid y2 coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.vertical(2, 2, 3, c)
        end
      end
    end

    context 'invalid colour' do
      before { image.create(2, 2) }

      it_behaves_like 'input error' do
        subject { image.vertical(2, 2, 2, -1) }
      end

      it_behaves_like 'input error' do
        subject { image.vertical(2, 2, 2, 'a') }
      end

      it_behaves_like 'input error' do
        subject { image.vertical(2, 2, 2, '~') }
      end
    end
  end
end
