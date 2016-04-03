require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do

  context 'with setting to load sample-4' do
    include_context 'when loading sample-4'
    before { described_class.configure &configuration_of_sample4 }

    context "when there is SettingC class that inherits SettingB" do
      include_context "when a class includes ConfigPlus", :SettingA
      include_context "when Class A that inherits Class B includes ConfigPlus", :SettingB, :SettingA
      include_context "when Class A that inherits Class B includes ConfigPlus", :SettingC, :SettingB

      let(:expected_hash) do
        setting_a_hash.merge(setting_b_hash).merge(setting_c_hash)
      end

      specify "SettingC class has a `config' method" do
        expect(SettingC).to respond_to :config
      end

      describe 'SettingC.config' do
        subject { SettingC.config }

        it "returns a hash into which `SettingA,' `SettingB' and `SettingC' are merged" do
          is_expected.to eq expected_hash
        end

        it_behaves_like 'configuration of SettingA'
        it_behaves_like 'configuration of SettingB'
        it_behaves_like 'configuration of SettingC'
      end

      specify "An instance of SettingC class has a `config' method" do
        expect(SettingC.new).to respond_to :config
      end

      describe 'SettingC.new.config' do
        subject { SettingC.new.config }

        it "returns a hash into which `SettingA,' `SettingB' and `SettingC' are merged" do
          is_expected.to eq expected_hash
        end

        it_behaves_like 'configuration of SettingA'
        it_behaves_like 'configuration of SettingB'
        it_behaves_like 'configuration of SettingC'
      end
    end
  end
end
