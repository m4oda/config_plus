require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do
  context "with setting to load `sample-4'" do
    include_context 'when loading sample-4'
    before { described_class.configure &configuration_of_sample4 }

    context "when included by SettingA class" do
      include_context "when a class includes ConfigPlus", :SettingA

      specify "SettingA class has a `config' method" do
        expect(SettingA).to respond_to :config
      end

      describe 'SettingA.config' do
        subject { SettingA.config }

        it "returns a `SettingA' hash" do
          is_expected.to eq setting_a_hash
        end

        it_behaves_like 'configuration of SettingA'
      end

      specify "An instance of SettingA class has a `config' method" do
        expect(SettingA.new).to respond_to :config
      end

      describe 'SettingA.new.config' do
        subject { SettingA.new.config }

        it "returns a `SettingA' hash" do
          is_expected.to eq setting_a_hash
        end

        it_behaves_like 'configuration of SettingA'
      end
    end
  end
end
