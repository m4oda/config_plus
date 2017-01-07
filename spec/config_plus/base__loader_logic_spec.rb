require 'spec_helper'

RSpec.describe ConfigPlus, '.included' do
  let(:root_dir) { File.expand_path('../../..', __FILE__) }

  context 'with setting to load erb-sample-1 and erb_yaml to loader_logic' do
    let(:configuration) do
      lambda do |config|
        config.root_dir = root_dir
        config.loader_logic = :erb_yaml
        config.source = 'spec/fixtures/erb-sample-1.yml'
      end
    end

    before { described_class.configure &configuration }

    context "when there is Spam class that includes ConfigPlus" do
      before { Object.const_set(:Spam, Class.new).instance_eval { include ConfigPlus } }
      after { Object.class_eval { remove_const :Spam } }

      specify "Spam class has a `config' method" do
        expect(Spam).to respond_to :config
      end

      describe 'Spam.config' do
        subject { Spam.config }

        let(:expected) do
          {
            "ham" => {
              "egg" => {
                "foo" => 55,
                "baa" => 110,
                "baz" => 165,
              }
            }
          }
        end

        it "returns a `ham' hash" do
          is_expected.to eq expected
        end
      end
    end

    context "when there is Spam::Ham class that includes ConfigPlus" do
      before do
        mod = Object.const_set(:Spam, Module.new)
        mod.const_set(:Ham, Class.new).instance_eval { include ConfigPlus }
      end

      after { Object.class_eval { remove_const :Spam } }

      specify "Spam::Ham class has a `config' method" do
        expect(Spam::Ham).to respond_to :config
      end

      describe 'Spam::Ham.config' do
        subject { Spam::Ham.config }

        let(:expected) do
          {
            "egg" => {
              "foo" => 55,
              "baa" => 110,
              "baz" => 165,
            }
          }
        end

        it "returns a `egg' hash" do
          is_expected.to eq expected
        end
      end
    end
  end
end
