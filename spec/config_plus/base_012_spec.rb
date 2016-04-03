require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do

  context 'with setting to load sample-4' do
    include_context 'when loading sample-4'
    before { described_class.configure &configuration_of_sample4 }

    context "when there is `SettingB' module that includes `ConfigPlus'" do
      include_context "when a module includes ConfigPlus", :SettingA
      include_context "when a module includes ConfigPlus", :SettingB

      context "when there is SettingC class that includes SettingA and SettingB" do
        before do
          Object.const_set(:SettingC, Class.new).
            include(SettingA).include(SettingB).
            include(ConfigPlus)
        end

        after { Object.class_eval { remove_const :SettingC } }

        let(:expected_hash) do
          setting_a_hash.merge(setting_b_hash).merge(setting_c_hash)
        end

        describe "SettingC.config" do
          subject { SettingC.config }

          it "returns a hash into which `SettingA,' `SettingB' and `SettingC' are merged" do
            expect(SettingC.config).to eq expected_hash
          end

          it_behaves_like 'configuration of SettingA'
          it_behaves_like 'configuration of SettingB'
          it_behaves_like 'configuration of SettingC'
        end

        describe "SettingC.new.config" do
          subject { SettingC.new.config }

          it "returns a hash into which `SettingA,' `SettingB' and `SettingC' are merged" do
            expect(SettingC.config).to eq expected_hash
          end

          it_behaves_like 'configuration of SettingA'
          it_behaves_like 'configuration of SettingB'
          it_behaves_like 'configuration of SettingC'
        end
      end
    end
  end
end
