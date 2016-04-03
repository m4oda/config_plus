require 'spec_helper'

RSpec.describe ConfigPlus, '.included' do
  let(:root_dir) { File.expand_path('../../..', __FILE__) }

  context 'with setting to load sample-4' do
    before do
      described_class.configure do |config|
        config.root_dir = root_dir
        config.source = 'spec/fixtures/sample-4.yml'
      end
    end

    let(:setting_a_hash) do
      {
        'foo' => 123,
        'baa' => 234,
        'baz' => 345,
      }
    end

    let(:setting_b_hash) do
      {
        'toto' => 'aaa',
        'titi' => 'bbb',
        'tata' => 'ccc',
      }
    end

    let(:setting_c_hash) do
      {
        'pee' => '?',
        'kaa' => '??',
        'boo' => '??!',
      }
    end

    let(:setting_d_hash) do
      {
        'foo' => 987,
        'baa' => 876,
        'baz' => 765,
      }
    end

    context "when there is `SettingA' class that includes `ConfigPlus'" do
      let(:setting_a) do
        obj = Object.const_set(:SettingA, Class.new)
        obj.include ConfigPlus
        obj
      end

      after do
        Object.class_eval { remove_const :SettingA }
      end

      describe 'SettingA' do
        it "has a `config' method" do
          expect(setting_a).to respond_to :config
        end

        describe '.config' do
          it "returns a `SettingA' hash" do
            expect(setting_a.config).to eq setting_a_hash
          end
        end

        describe '#config' do
          it "returns a `SettingA' hash" do
            expect(setting_a.new.config).to eq setting_a_hash
          end
        end
      end

      context "when there is `SettingB' class that inherits `SettingA'" do
        let(:setting_b) do
          klass = Class.new(setting_a)
          obj = Object.const_set(:SettingB, klass)
          obj.include ConfigPlus
          obj
        end

        after do
          Object.class_eval { remove_const :SettingB }
        end

        describe 'SettingB' do
          let(:expected_hash) { setting_a_hash.merge(setting_b_hash) }

          describe '.config' do
            it "returns a `SettingB' hash mixed with a `SettingA' hash" do
              expect(setting_b.config).to eq expected_hash
            end
          end

          describe '#config' do
            it "returns a `SettingB' hash mixed with a `SettingA' hash" do
              expect(setting_b.new.config).to eq expected_hash
            end
          end
        end

        context "when there is `SettingC' class that inherits `SettingB'" do
          let(:setting_c) do
            klass = Class.new(setting_b)
            obj = Object.const_set(:SettingC, klass)
            obj.include ConfigPlus
            obj
          end

          after do
            Object.class_eval { remove_const :SettingC }
          end

          describe 'SettingC' do
            let(:expected_hash) do
              setting_a_hash.merge(setting_b_hash).merge(setting_c_hash)
            end

            describe '.config' do
              it "returns a hash into which `SettingA,' `SettingB' and `SettingC' are merged" do
                expect(setting_c.config).to eq expected_hash
              end
            end

            describe '#config' do
              it "returns a hash into which `SettingA,' `SettingB' and `SettingC' are merged" do
                expect(setting_c.new.config).to eq expected_hash
              end
            end
          end
        end
      end

      context "when there is `SettingD' class that inherits `SettingA'" do
        let(:setting_d) do
          klass = Class.new(setting_a)
          obj = Object.const_set(:SettingD, klass)
          obj.include ConfigPlus
          obj
        end

        after do
          Object.class_eval { remove_const :SettingD }
        end

        describe 'SettingD' do
          describe '.config' do
            it "returns a `SettingD' hash" do
              expect(setting_d.config).to eq setting_d_hash
            end
          end

          describe '#config' do
            it "returns a `SettingD' hash" do
              expect(setting_d.new.config).to eq setting_d_hash
            end
          end
        end
      end

      context "when there is `Foo' class that inherits `SettingA'" do
        let(:foo) do
          klass = Class.new(setting_a)
          obj = Object.const_set(:Foo, klass)
          obj.include ConfigPlus
          obj
        end

        after do
          Object.class_eval { remove_const :Foo }
        end

        describe 'Foo' do
          it "has `config' method" do
            expect(foo).to respond_to :config
          end
        end
      end
    end

    context "when there is `SettingA' module that includes `ConfigPlus'" do
      let(:setting_a) do
        obj = Object.const_set(:SettingA, Module.new)
        obj.include ConfigPlus
        obj
      end

      after do
        Object.class_eval { remove_const :SettingA }
      end

      describe 'SettingA' do
        it "has a `config' method" do
          expect(setting_a).to respond_to :config
        end

        describe '.config' do
          it "returns a `SettingA' hash" do
            expect(setting_a.config).to eq setting_a_hash
          end
        end
      end

      context "when there is `SettingB' class that includes `SettingA'" do
        let(:setting_b) do
          klass = Class.new
          klass.include(setting_a)
          obj = Object.const_set(:SettingB, klass)
          obj.include ConfigPlus
          obj
        end

        after do
          Object.class_eval { remove_const :SettingB }
        end

        describe 'SettingB' do
          let(:expected_hash) { setting_a_hash.merge(setting_b_hash) }

          describe '.config' do
            it "returns a `SettingB' hash mixed with a `SettingA' hash" do
              expect(setting_b.config).to eq expected_hash
            end
          end

          describe '#config' do
            it "returns a `SettingB' hash mixed with a `SettingA' hash" do
              expect(setting_b.new.config).to eq expected_hash
            end
          end
        end
      end

      context "when there is `SettingB' module that includes `ConfigPlus'" do
        let(:setting_b) do
          obj = Object.const_set(:SettingB, Module.new)
          obj.include ConfigPlus
          obj
        end

        after do
          Object.class_eval { remove_const :SettingB }
        end

        context "when there is `SettingC class that includes `SettingA' and `SettingB'" do
          let(:setting_c) do
            obj = Object.const_set(:SettingC, Class.new)
            obj.include setting_a
            obj.include setting_b
            obj.include ConfigPlus
            obj
          end

          after do
            Object.class_eval { remove_const :SettingC }
          end

          describe 'SettingC' do
            let(:expected_hash) do
              setting_a_hash.merge(setting_b_hash).merge(setting_c_hash)
            end

            describe '.config' do
              it "returns a hash into which `SettingA,' `SettingB' and `SettingC' are merged" do
                expect(setting_c.config).to eq expected_hash
              end
            end
          end
        end
      end
    end
  end
end
