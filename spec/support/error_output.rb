shared_examples 'error output' do |msg|
  it do
    msg ||= 'Unable to process command with given args'
    expect(subject.output.string).to include(msg)
  end
end
