require 'bitmap_editor'

describe BitmapEditor do
  let(:default_args) { %w(--no-interaction) }

  subject(:editor) { described_class.new }

  describe '.run!' do
    let(:output) { StringIO.new }

    subject { described_class.run!(args: runtime_args, output: output) }

    context 'help' do
      let(:runtime_args) { %w(help) + default_args }

      it 'shows help' do
        subject
        expect(output.string).to include('Usage: bitmap_editor help|start')
      end

      it 'shows instructions' do
        subject
        expect(output.string).to include('Instructions:')
      end
    end

    context 'start' do
      let(:runtime_args) { %w(start) + default_args }

      it 'starts' do
        subject
        expect(output.string).to include('Starting')
      end

      context 'with instructions' do
        let(:runtime_args) do
          ['start', '--instruction=X', '--instruction=Y', '--instruction=Z'] + default_args
        end

        it 'performs instructions' do
          instructions = []
          described_class.run!(args: runtime_args, output: output) do |i|
            instructions.push(i)
          end

          expect(instructions).to eq(%w(X Y Z))
        end
      end
    end
  end
end
