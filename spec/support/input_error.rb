shared_examples 'input error' do
  it do
    expect { subject }.to raise_error(BitmapEditor::ArgumentError)
  end
end
