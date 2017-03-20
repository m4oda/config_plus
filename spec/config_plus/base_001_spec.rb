require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do
  context "with setting to load `sample-4'" do
    include_context 'when loading sample-4'
    before { described_class.configure &configuration_of_sample4 }

    context "when included by SettingB class that inherits SettingA" do
      include_context "when a class includes ConfigPlus", :SettingA
      include_context "when Class A that inherits Class B includes ConfigPlus", :SettingB, :SettingA

      let(:expected_hash) { setting_a_hash.merge(setting_b_hash) }

      specify "SettingB class has a `config' method" do
        expect(SettingB).to respond_to :config
      end

      describe 'SettingB.config' do
        subject { SettingB.config }

        it "returns a `SettingB' hash mixed with a `SettingA' hash" do
          is_expected.to eq expected_hash
        end

        it_behaves_like 'configuration of SettingA'
        it_behaves_like 'configuration of SettingB'
      end

      specify "An instance of SettingB class has a `config' method" do
        expect(SettingB.new).to respond_to :config
      end

      describe 'SettingB.new.config' do
        subject { SettingB.new.config }

        it "returns a `SettingB' hash mixed with a `SettingA' hash" do
          is_expected.to eq expected_hash
        end

        it_behaves_like 'configuration of SettingA'
        it_behaves_like 'configuration of SettingB'
      end
    end
  end
end
