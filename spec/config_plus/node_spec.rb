require 'spec_helper'

RSpec.describe ConfigPlus::Node, '#[]' do
  context 'When the node is initialized with a string keyed hash' do
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

  context 'When the node is initialized with a integer keyed hash' do
    let(:node) { described_class.new(1 => {2 => 123}) }

    context 'with the key typed as String' do
      it 'returns a value associated with the key' do
        actual = node['1']
        expect(actual).to eq 2 => 123
      end
    end
  end

  context 'When the node is initialized with a string array' do
    let(:array) { ['foo', 'baa', 'baz'] }
    let(:node) { described_class.new(array) }

    context 'with an index number' do
      it 'returns a value picked up from the array' do
        expect(node[0]).to eq array[0]
        expect(node[1]).to eq array[1]
        expect(node[2]).to eq array[2]
      end
    end

    context 'with a number over its index' do
      it 'returns nil' do
        expect(node[3]).to be_nil
      end
    end
  end

  context 'When the node is initialized with a hash array' do
    let(:array) do
      [
        {
          'author' => 'Lewis Carroll',
          'language' => 'English',
          'title' => "Alice's Adventures in Wonderland",
        },
        {
          'author' => 'L. Frank Baum',
          'language' => 'English',
          'title' => 'The Wonderful Wizard of Oz',
        },
      ]
    end

    let(:node) { described_class.new(array) }

    context 'with an index number' do
      it 'returns a value equals with data picked up from the array' do
        expect(node[0]).to eq array[0]
        expect(node[1]).to eq array[1]
      end

      describe 'Data that is returned by specification of an index number' do
        context 'with the hash keys' do
          it 'returns a value' do
            expect(node[0][:author]).to eq 'Lewis Carroll'
            expect(node[0][:language]).to eq 'English'
            expect(node[0][:title]).to eq "Alice's Adventures in Wonderland"

            expect(node[1]['author']).to eq 'L. Frank Baum'
            expect(node[1]['language']).to eq 'English'
            expect(node[1]['title']).to eq 'The Wonderful Wizard of Oz'
          end
        end
      end
    end

    context 'with an index number as a string' do
      it 'returns a value equals with data picked up from the array' do
        expect(node['0']).to eq array[0]
        expect(node['1']).to eq array[1]
      end
    end
  end

  context 'When the node is initialized with an array of an array' do
    let(:array) do
      [
        [
          {
            'author' => 'Lewis Carroll',
            'language' => 'English',
            'title' => "Alice's Adventures in Wonderland",
          },
          {
            'author' => 'L. Frank Baum',
            'language' => 'English',
            'title' => 'The Wonderful Wizard of Oz',
          },
        ],
        [
          {
            'director' => ['Ben Sharpsteen'],
            'language' => 'English',
            'title' => 'Dumbo',
          },
          {
            'director' => ['Ben Sharpsteen', 'Hamilton Luske'],
            'language' => 'English',
            'title' => 'Pinocchio',
          },
        ],
      ]
    end

    let(:node) { described_class.new(array) }

    context 'with an index number' do
      it 'returns a value equals with data picked up from the array' do
        expect(node[0]).to eq array[0]
        expect(node[1]).to eq array[1]
      end

      describe 'The nested array' do
        it 'returns a value equals with data picked up from the array' do
          expect(node[0][0]).to eq array[0][0]
          expect(node[0][1]).to eq array[0][1]
          expect(node[1][0]).to eq array[1][0]
          expect(node[1][1]).to eq array[1][1]
        end

        describe 'Data that is returned by specification of an index number' do
          context 'with the hash keys' do
            it 'returns a value' do
              expect(node[0][0]['author']).to eq 'Lewis Carroll'
              expect(node[0][0]['language']).to eq 'English'
              expect(node[0][0]['title']).to eq "Alice's Adventures in Wonderland"

              expect(node[0][1][:author]).to eq 'L. Frank Baum'
              expect(node[0][1][:language]).to eq 'English'
              expect(node[0][1][:title]).to eq 'The Wonderful Wizard of Oz'

              expect(node[1][0][:director]).to eq ['Ben Sharpsteen']
              expect(node[1][0][:language]).to eq 'English'
              expect(node[1][0][:title]).to eq 'Dumbo'

              expect(node[1][1]['director']).to eq ['Ben Sharpsteen', 'Hamilton Luske']
              expect(node[1][1]['language']).to eq 'English'
              expect(node[1][1]['title']).to eq 'Pinocchio'
            end
          end
        end
      end
    end

    context 'with an index number as a string' do
      it 'returns a value equals with data picked up from the array' do
        expect(node['0']).to eq array[0]
        expect(node['1']).to eq array[1]
      end

      describe 'The nested array' do
        it 'returns a value equals with data picked up from the array' do
          expect(node['0']['0']).to eq array[0][0]
          expect(node['0']['1']).to eq array[0][1]
          expect(node['1']['0']).to eq array[1][0]
          expect(node['1']['1']).to eq array[1][1]
        end
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
  context 'When the node is initialized with a string keyed hash' do
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

  context 'When the node is initialized with a hash array' do
    let(:array) do
      [
        {
          'name' => 'Jon Doe',
          'job' => 'actor',
        },
        {
          'name' => 'Jack Doe',
          'job' => 'doctor',
        },
      ]
    end

    let(:node) { described_class.new(array) }

    context 'with a dot-notation key path' do
      it 'returns a value specified the key path' do
        expect(node.get('0.name')).to eq 'Jon Doe'
        expect(node.get('0.job')).to eq 'actor'

        expect(node.get('1.name')).to eq 'Jack Doe'
        expect(node.get('1.job')).to eq 'doctor'
      end
    end
  end
end

RSpec.describe ConfigPlus::Node, '#merge' do
  context 'When the node is initialized with a hash' do
    let(:hash) { {'foo' => 'abc'} }
    let(:node) { described_class.new(hash) }

    context 'with another hash' do
      let(:another_hash) { {'baa' => 'xyz'} }

      it 'returns a new merged node object' do
        actual = node.merge(another_hash)
        expect(actual).to eq Hash('foo' => 'abc', 'baa' => 'xyz')
      end

      it 'does not alter the node itself' do
        node.merge(another_hash)
        expect(node).to eq hash
      end

      it 'does not have new methods whose names are the merged keys' do
        node.merge(another_hash)
        expect(node).to respond_to :foo
        expect(node).not_to respond_to :baa
      end

      describe 'the object returned' do
        it 'has new methods whose names are the merged keys' do
          actual = node.merge(another_hash)
          expect(actual).to respond_to :foo
          expect(actual).to respond_to :baa
        end
      end
    end

    context 'with an array' do
      let(:array) { [{'foo' => 'abc'}] }

      it 'raises a TypeError' do
        expect{ node.merge(array) }.to raise_error(TypeError)
      end
    end
  end

  context 'WHen the node is initialized with an array' do
    let(:array) { [{'foo' => 'abc', 'baa' => 'xyz'}] }
    let(:node) { described_class.new(array) }

    context 'with another array' do
      let(:another_array) { [{'pee' => 'one', 'kaa' => 'two', 'boo' => 'three'}] }

      it 'returns a new concatinated node object' do
        actual = node.merge(another_array)
        expected = array + another_array
        expect(actual).to eq expected
      end

      it 'does not alter the node itself' do
        node.merge(another_array)
        expect(node).to eq array
      end
    end

    context 'with a hash' do
      let(:hash) { {'baz' => '123'} }

      it 'raises a TypeError' do
        expect{ node.merge(hash) }.to raise_error(TypeError)
      end
    end
  end
end
