require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do

  context 'with setting to load sample-4' do
    include_context 'when loading sample-4'
    before { described_class.configure &configuration_of_sample4 }

    context "when there is SettingA module that includes ConfigPlus" do
      include_context "when a module includes ConfigPlus", :SettingA

      specify "SettingA module has a `config' method" do
        expect(SettingA).to respond_to :config
      end

      describe 'SettingA.config' do
        subject { SettingA.config }

        it "returns a `SettingA' hash" do
          is_expected.to eq setting_a_hash
        end

        it_behaves_like 'configuration of SettingA'
      end
    end
  end
end
