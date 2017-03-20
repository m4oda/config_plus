require 'spec_helper'

RSpec.describe ConfigPlus::ErbYamlLoaderLogic, '#load_from' do
  let(:instance) { described_class.new(nil) }

  context "called with a path to `erb-sample-1.yml' file" do
    let(:path) { "spec/fixtures/erb-sample-1.yml" }

    let(:expected_hash) do
      {
        "spam" => {
          "ham" => {
            "egg" => {
              "foo" => 55,
              "baa" => 110,
              "baz" => 165,
            }
          }
        }
      }
    end

    it "returns a hash equal with `erb-sample.yml'" do
      expect(instance.load_from(path)).to eq expected_hash
    end
  end
end
