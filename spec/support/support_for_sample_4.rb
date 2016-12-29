RSpec.shared_context 'when loading sample-4' do
  let(:root_dir) { File.expand_path('../../..', __FILE__) }

  let(:configuration_of_sample4) do
    lambda do |config|
      config.root_dir = root_dir
      config.source = 'spec/fixtures/sample-4.yml'
    end
  end

  let(:setting_a_hash) do
    {
      'foo' => 123,
      'baa' => 234,
      'baz' => {
        'spam' => 'zzz',
        'ham' => 'xxx',
      }
    }
  end

  let(:setting_b_hash) do
    {
      'toto' => 'aaa',
      'titi' => 'bbb',
      'tata' => {
        'xyzzy' => '000',
        'zzyzx' => '999',
      }
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
      'baz' => {
        'toto' => 'piyo',
        'titi' => 'payo',
        'tata' => 'poyo',
      }
    }
  end
end


RSpec.shared_examples 'configuration of SettingA' do
  it "has methods named `foo,' `baa' and `baz'" do
    expect(subject.foo).to be 123
    expect(subject.baa).to be 234
    is_expected.to respond_to :baz
  end

  describe '#baz' do
    subject { super().baz }

    it "has methods named `spam' and `ham'" do
      expect(subject.spam).to eq 'zzz'
      expect(subject.ham).to eq 'xxx'
    end
  end
end

RSpec.shared_examples 'configuration of SettingB' do
  it "has methods named `toto,' `titi' and `tata'" do
    expect(subject.toto).to eq 'aaa'
    expect(subject.titi).to eq 'bbb'
    is_expected.to respond_to :tata
  end

  describe '#tata' do
    subject { super().tata }

    it "has methods named `xyzzy' and `zzyzx'" do
      expect(subject.xyzzy).to eq '000'
      expect(subject.zzyzx).to eq '999'
    end
  end
end

RSpec.shared_examples 'configuration of SettingC' do
  it "has methods named `pee,' `kaa' and `boo'" do
    expect(subject.pee).to eq '?'
    expect(subject.kaa).to eq '??'
    expect(subject.boo).to eq '??!'
  end
end

RSpec.shared_examples 'configuration of SettingD' do
  it "has methods named `foo,' `baa' and `baz'" do
    expect(subject.foo).to be 987
    expect(subject.baa).to be 876
    is_expected.to respond_to :baz
  end

  describe '#baz' do
    subject { super().baz }

    it "has methods named `toto,' `titi' and `tata'" do
      expect(subject.toto).to eq 'piyo'
      expect(subject.titi).to eq 'payo'
      expect(subject.tata).to eq 'poyo'
    end
  end
end

RSpec.shared_context "when a class includes ConfigPlus" do |klass|
  before { Object.const_set(klass, Class.new).instance_eval { include ConfigPlus } }
  after { Object.class_eval { remove_const klass } }
end

RSpec.shared_context "when a module includes ConfigPlus" do |mod|
  before { Object.const_set(mod, Module.new).instance_eval { include ConfigPlus } }
  after { Object.class_eval { remove_const mod } }
end

RSpec.shared_context "when Class A that inherits Class B includes ConfigPlus" do |class_a, class_b|
  before do
    parent = Object.const_get(class_b)
    klass = Class.new(parent)
    Object.const_set(class_a, klass).instance_eval { include ConfigPlus }
  end

  after { Object.class_eval { remove_const class_a } }
end

RSpec.shared_context "when Class A that includes Module B includes ConfigPlus" do |class_a, module_b|
  before do
    mod = Object.const_get(module_b)
    klass = Class.new
    klass.instance_eval { include(mod) }
    Object.const_set(class_a, klass).instance_eval { include ConfigPlus }
  end

  after { Object.class_eval { remove_const class_a } }
end
