require 'rails_helper'

describe Box do
  it { should validate_presence_of(:params) }
  it { should_not allow_value('<test').for(:vm_name) }

  describe 'secure_id' do
    before { allow(SecureIdGenerator).to receive(:generate) { 'abc123' } }

    it 'does not allows non-unique secure id' do
      described_class.create!(params: {databases: []})
      expect(described_class.create(params: {databases: []})).not_to be_valid
    end

    it 'generates unique secure id' do
      box = described_class.create!(params: {databases: []})
      expect(box.secure_id).to eq 'abc123'
    end
  end

  describe '.default_configuration' do
    subject { described_class.default_configuration }

    it 'has 1024Mb RAM' do
      expect(subject[:vm_memory]).to eq '1024'
    end

    it 'has myapp name' do
      expect(subject[:vm_name]).to eq 'myapp'
    end
  end

  describe '#to_param' do
    it 'returns secure_id' do
      box = Box.new secure_id: 'abc123'
      expect(box.to_param).to eq 'abc123'
    end
  end

  describe '#vm_name' do
    it 'will extract name from params' do
      box = Box.new params: { vm_name: 'myapp' }
      expect(box.vm_name).to eq 'myapp'
    end
  end
end