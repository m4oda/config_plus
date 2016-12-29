require 'spec_helper'

RSpec.describe ConfigPlus::Node, '#[]' do
  context 'initialized with a string keyed hash' do
    let(:node) { described_class.new('foo' => 123) }

    context 'with the key typed as String' do
      it 'returns a value associated with the key' do
        actual = node['foo']
        expect(actual).to be 123
      end
    end

    context 'with the key typed as Symbol' do
      it 'returns a value associated with the key' do
        actual = node[:foo]
        expect(actual).to be 123
      end
    end
  end

  context 'initialized with a integer keyed hash' do
    let(:node) { described_class.new(1 => {2 => 123}) }

    context 'with the key typed as String' do
      it 'returns a value associated with the key' do
        actual = node['1']
        expect(actual).to eq 2 => 123
      end
    end
  end

  context 'accessing an element of nested node' do
    let(:node) { described_class.new('foo' => {'baa' => 'baz'}) }

    it 'returns a hash typed as this class' do
      actual = node[:foo]
      expect(actual).to be_instance_of described_class
    end

    describe 'the nested hash' do
      context 'with the key typed as String' do
        it 'returns a value associated with the key' do
          actual = node['foo']['baa']
          expect(actual).to eq 'baz'
        end
      end

      context 'with the key typed as Symbol' do
        it 'returns a value associated with the key' do
          actual = node[:foo][:baa]
          expect(actual).to eq 'baz'
        end
      end
    end
  end
end


RSpec.describe ConfigPlus::Node, '#get' do
  let(:node) do
    hash = {
      'a' => {'foo' => {'baa' => {'baz' => 'xyz'} } },
      'b' => {'spam' => {'ham' => 'abc'} },
    }

    described_class.new(hash)
  end

  context 'with a dot-notation key path' do
    it 'returns a value specified the key path' do
      actual = node.get('a.foo.baa.baz')
      expect(actual).to eq 'xyz'
    end
  end

  context 'with a key path that does not exist' do
    it 'returns a nil' do
      actual = node.get('a.spam.ham')
      expect(actual).to be_nil
    end
  end
end
