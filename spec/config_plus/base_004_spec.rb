require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do

  context 'with setting to load sample-4' do
    include_context 'when loading sample-4'
    before { described_class.configure &configuration_of_sample4 }

    context "when there is `Foo' class that inherits SettingA" do
      include_context "when a class includes ConfigPlus", :SettingA
      include_context "when Class A that inherits Class B includes ConfigPlus", :Foo, :SettingA

      specify "Foo class has a `config' method" do
        expect(Foo).to respond_to :config
      end

      describe 'Foo.config' do
        subject { Foo.config }

        it "returns a `SettingA' hash" do
          is_expected.to eq setting_a_hash
        end

        it_behaves_like 'configuration of SettingA'
      end

      specify "An instance of Foo class has a `config' method" do
        expect(Foo.new).to respond_to :config
      end

      describe 'Foo.new.config' do
        subject { Foo.new.config }

        it "returns a `SettingA' hash" do
          is_expected.to eq setting_a_hash
        end

        it_behaves_like 'configuration of SettingA'
      end

      specify "SettingA.config returns a `SettingA' hash" do
        expect(SettingA.config).to eq setting_a_hash
      end
    end
  end
end
