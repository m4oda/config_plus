require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do

  context 'with setting to load sample-4' do
    include_context 'when loading sample-4'
    before { described_class.configure &configuration_of_sample4 }

    context "when there is SettingD class that inherits SettingA" do
      include_context "when a class includes ConfigPlus", :SettingA
      include_context "when Class A that inherits Class B includes ConfigPlus", :SettingD, :SettingA

      let(:expected_hash) do
        baz = setting_a_hash['baz'].merge(setting_d_hash['baz'])
        setting_d_hash.merge('baz' => baz)
      end

      specify "SettingD class has a `config' method" do
        expect(SettingD).to respond_to :config
      end

      describe 'SettingD.config' do
        subject { SettingD.config }

        it "returns a `SettingD' hash mixed with a `SettingA' hash" do
          is_expected.to eq expected_hash
        end

        it_behaves_like 'configuration of SettingD'
      end

      specify "An instance of SettingD class has a `config' method" do
        expect(SettingD.new).to respond_to :config
      end

      describe 'SettingD.new.config' do
        subject { SettingD.new.config }

        it "returns a `SettingD' hash mixed with a `SettingA' hash" do
          is_expected.to eq expected_hash
        end

        it_behaves_like 'configuration of SettingD'
      end

      specify "SettingA.config return a `SettingA' hash" do
        expect(SettingA.config).to eq setting_a_hash
      end
    end
  end
end
