require 'spec_helper'

RSpec.describe ConfigPlus::Helper, '#underscore' do
  context "with string `Foo'" do
    it "returns `foo'" do
      actual = described_class.underscore('Foo')
      expect(actual).to eq 'foo'
    end
  end

  context "with string `FooBaa'" do
    it "returns `foo_baa'" do
      actual = described_class.underscore('FooBaa')
      expect(actual).to eq 'foo_baa'
    end
  end

  context "with string `RESTful'" do
    it "returns `restful'" do
      actual = described_class.underscore('RESTful')
      expect(actual).to eq 'restful'
    end
  end

  context "with string `FooBaa::BazzFizz'" do
    it "returns `foo_baa.bazz_fizz'" do
      actual = described_class.underscore('FooBaa::BazzFizz')
      expect(actual).to eq 'foo_baa.bazz_fizz'
    end
  end
end


RSpec.describe ConfigPlus::Helper, '#config_for' do
  context "with a class and a Node has the class named key" do
    let(:klass) { Object::Foo = Class.new }
    let(:node) { ConfigPlus::Node.new('foo' => {'a' => 123}) }

    it 'returns a value associated with the class named key' do
      actual = described_class.config_for(klass, node)
      expect(actual).to eq Hash('a' => 123)
    end
  end

  context "with a nested class and a Node" do
    let(:klass) do
      Object::FooBaa = Module.new
      Object::FooBaa::Baz = Class.new
    end

    let(:node) do
      hash = {
        'foo_baa' => {'baz' => {'toto' => 1, 'titi' => 2} }
      }

      ConfigPlus::Node.new(hash)
    end

    it 'returns a value associated with the class named key' do
      actual = described_class.config_for(klass, node)
      expect(actual).to eq Hash('toto' => 1, 'titi' => 2)
    end
  end
end
