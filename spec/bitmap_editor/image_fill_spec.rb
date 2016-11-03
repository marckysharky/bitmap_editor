require 'spec_helper'
require 'bitmap_editor/image'

RSpec.describe BitmapEditor::Image do
  subject(:image) { described_class.new }

  describe '#fill' do
    let(:x) { 2 }
    let(:y) { 1 }
    let(:c) { 'C' }

    subject do
      image.tap do |i|
        i.create(2, 2)
        i.fill(x, y, c)
      end
    end

    it { expect(subject.fetch(x, y)).to eq(c) }

    context 'missing canvas' do
      it_behaves_like 'input error' do
        subject { image.fill(x, y, c) }
      end
    end

    context 'negative coordinates' do
      it_behaves_like 'input error' do
        subject do
          image.create(1, 1)
          image.fill(-1, -2, c)
        end
      end
    end

    context 'invalid x coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.fill(3, 2, c)
        end
      end
    end

    context 'invalid y coordinate' do
      it_behaves_like 'input error' do
        subject do
          image.create(2, 2)
          image.fill(2, 3, c)
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
