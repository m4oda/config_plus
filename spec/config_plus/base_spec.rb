require 'spec_helper'
require 'support/support_for_sample_4'

RSpec.describe ConfigPlus, '.included' do
  let(:root_dir) { File.expand_path('../../..', __FILE__) }

  shared_context "when SettingA class includes ConfigPlus" do
    before { Object.const_set(:SettingA, Class.new).include ConfigPlus }
    after { Object.class_eval { remove_const :SettingA } }
  end

  shared_context "when a module includes ConfigPlus" do |mod|
    before { Object.const_set(mod, Module.new).include ConfigPlus }
    after { Object.class_eval { remove_const mod } }
  end

  shared_context "when Class A that inherits Class B includes ConfigPlus" do |class_a, class_b|
    before do
      parent = Object.const_get(class_b)
      klass = Class.new(parent)
      Object.const_set(class_a, klass).include ConfigPlus
    end

    after { Object.class_eval { remove_const class_a } }
  end

  shared_context "when Class A that includes Module B includes ConfigPlus" do |class_a, module_b|
    before do
      mod = Object.const_get(module_b)
      klass = Class.new
      klass.include(mod)
      Object.const_set(class_a, klass).include ConfigPlus
    end

    after { Object.class_eval { remove_const class_a } }
  end

  context 'with setting to load sample-4' do
    before do
      described_class.configure do |config|
        config.root_dir = root_dir
        config.source = 'spec/fixtures/sample-4.yml'
      end
    end

    include_context 'when loading sample-4'

    context "when there is SettingA class that includes ConfigPlus" do
      include_context "when SettingA class includes ConfigPlus"

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

    context "when there is SettingB class that inherits SettingA" do
      include_context "when SettingA class includes ConfigPlus"
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

    context "when there is SettingC class that inherits SettingB" do
      include_context "when SettingA class includes ConfigPlus"
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

    context "when there is SettingD class that inherits SettingA" do
      include_context "when SettingA class includes ConfigPlus"
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
    end

    context "when there is `Foo' class that inherits SettingA" do
      include_context "when SettingA class includes ConfigPlus"
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
    end

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

    context "when there is SettingB class that includes SettingA" do
      include_context "when a module includes ConfigPlus", :SettingA
      include_context "when Class A that includes Module B includes ConfigPlus", :SettingB, :SettingA

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

