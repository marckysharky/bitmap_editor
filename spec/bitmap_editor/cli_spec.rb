require 'bitmap_editor/cli'

RSpec.describe BitmapEditor::Cli do
  let(:args)   { %w() }
  let(:output) { StringIO.new }

  subject(:cli) { described_class.new(args: args, output: output) }

  describe '#call' do
    subject { cli.call }

    context 'empty command' do
      it { is_expected.to eq(false) }

      it 'shows banner' do
        subject
        expect(output.string).to include('Usage:')
      end
    end

    context 'help command' do
      let(:args) { %w(help) }

      it { is_expected.to eq(false) }

      it 'shows banner' do
        subject
        expect(output.string).to include('Usage: bitmap_editor start|help')
      end
    end

    context 'start' do
      let(:args) { %w(start) }

      before { subject }

      it { is_expected.to eq(true) }

      context '--no-interaction' do
        let(:args) { %w(start --no-interaction) }

        it { is_expected.to eq(true) }
        it { expect(cli.options[:interactive]).to eq(false) }
      end

      context '--instruction' do
        let(:args) { ['start', '--instruction=FOO BAR', '--instruction=BAR CAR'] }

        it { is_expected.to eq(true) }
        it { expect(cli.options[:instructions]).to eq(['FOO BAR', 'BAR CAR']) }
      end
    end
  end
end
