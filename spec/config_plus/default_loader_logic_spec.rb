require 'spec_helper'

RSpec.describe ConfigPlus::DefaultLoaderLogic, '#load_from' do
  let(:instance) { described_class.new(nil) }

  context "called with a path to `sample-1.yml' file" do
    let(:path) { "spec/fixtures/sample-1.yml" }

    let(:expected_hash) do
      {
        "setting_a" => {
          "foo" => "Lorem ipsum",
          "baa" => "dolor sit amet",
          "baz" => "consectetur adipiscing elit",
        },
        "setting_b" => {
          "toto" => "sed do eiusmod",
          "titi" => "tempor incididunt",
          "tata" => "labore et dolore",
        },
      }
    end

    it "returns a hash equal with `sample-1.yml'" do
      expect(instance.load_from(path)).to eq expected_hash
    end
  end

  context "called with a path to `sample-2' directory" do
    let(:path) { "spec/fixtures/sample-2" }

    let(:expected_hash) do
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

    it "returns a hash merged `sample-2/sample-a.yml' and `sample-2/sample-b.yml' into" do
      expect(instance.load_from(path)).to eq expected_hash
    end
  end
end
