require 'spec_helper'

RSpec.describe ConfigPlus::Config, '#load_source' do
  let(:config) { described_class.new }

  let(:hash_1) do
    {
      'setting_a' => {
        'foo' => 'Lorem ipsum',
        'baa' => 'dolor sit amet',
        'baz' => 'consectetur adipiscing elit',
      },
      'setting_b' => {
        'toto' => 'sed do eiusmod',
        'titi' => 'tempor incididunt',
        'tata' => 'labore et dolore',
      },
    }
  end

  let(:hash_2) do
    {
      'setting_a' => {
        'spam' => 'Ut enim ad minim veniam',
        'ham' => 'quis nostrud exercitation',
        'foo' => 'Lorem ipsum',
        'baa' => 'dolor sit amet',
      },
      'setting_b' => {
        'bazz' => 'ullamco laboris',
        'fizz' => 'aliquip ex ea commodo',
        'toto' => 'commodo consequat',
        'titi' => 'duis aute irure',
      },
    }
  end

  context "with settings of no `source' and no `root_dir'" do
    it 'raises RuntimeError' do
      expect { config.load_source }.
        to raise_error("No specified `source'")
    end
  end

  context "with a setting of `source' specified a YAML file" do
    before do
      config.root_dir = File.expand_path('../../..', __FILE__)
      config.source = 'spec/fixtures/sample-1.yml'
    end

    it 'returns the expected hash' do
      actual = config.load_source
      expect(actual).to eq hash_1
    end

    context "with a setting of `namespace'" do
      before do
        config.namespace = 'setting_a'
      end

      it "returns a hash associated with the namespace key" do
        actual = config.load_source
        expect(actual).to eq hash_1['setting_a']
      end
    end
  end

  context "with a setting of `source' specified a directory" do
    before do
      config.root_dir = File.expand_path('../../..', __FILE__)
      config.source = 'spec/fixtures/sample-2'
    end

    it 'returns the expected hash' do
      actual = config.load_source
      expect(actual).to eq hash_2
    end

    context "with a setting of `namespace'" do
      before do
        config.namespace = 'setting_b'
      end

      it "returns a hash associated with the namespace key" do
        actual = config.load_source
        expect(actual).to eq hash_2['setting_b']
      end
    end
  end
end
