require 'spec_helper'
require 'bitmap_editor/image'

RSpec.describe BitmapEditor::Image do
  subject(:image) { described_class.new }

  describe '#flood' do

    context 'basic' do
      let(:x) { 2 }
      let(:y) { 1 }
      let(:c) { 'W' }

      subject do
        image.tap do |i|
          i.create(3, 3)
          i.flood(x, x, c)
        end
      end

      it do
        expect(subject.canvas).to eq([[c, c, c], [c, c, c], [c, c, c]])
      end
    end

    context 'boundary' do
      let(:c) { 'W' }

      subject do
        image.tap do |i|
          i.create(3, 3)
          i.fill(1, 1, 'A')
          i.fill(2, 2, 'A')
          i.flood(2, 1, c)
        end
      end

      it do
        expect(subject.canvas).to eq([['A', 'W', 'W'],
                                      ['W', 'A', 'W'],
                                      ['W', 'W', 'W']])
      end
    end
  end
end
