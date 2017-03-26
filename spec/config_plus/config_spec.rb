require 'spec_helper'

RSpec.describe ConfigPlus::Config, '#loader_logic' do
  let(:instance) { described_class.new }

  context "when property `loader_logic' is set :default" do
    before { instance.loader_logic = :default }

    it 'returns ConfigPlus::DefaultLoaderLogic' do
      actual = instance.loader_logic
      expect(actual).to be ConfigPlus::DefaultLoaderLogic
    end
  end

  context "when property `loader_logic' is set :erb_yaml" do
    before { instance.loader_logic = :erb_yaml }

    it 'returns ConfigPlus::ErbYamlLoaderLogic' do
      actual = instance.loader_logic
      expect(actual).to be ConfigPlus::ErbYamlLoaderLogic
    end
  end
end

RSpec.describe ConfigPlus::Config, '#has_property?' do
  context "when an instance has property `foo'" do
    before do
      allow(described_class).to receive(:default_properties).and_return(foo: nil)
    end

    let(:instance) { described_class.new }

    context "called with a parameter :foo" do
      it 'returns true' do
        actual = instance.has_property?(:foo)
        expect(actual).to be_truthy
      end
    end

    context "called with a parameter 'foo'" do
      it 'returns true' do
        actual = instance.has_property?("foo")
        expect(actual).to be_truthy
      end
    end

    context "called with a parameter :baa" do
      it 'returns false' do
        actual = instance.has_property?(:baa)
        expect(actual).to be_falsy
      end
    end

    context "called with a parameter 'baa'" do
      it 'returns false' do
        actual = instance.has_property?("baa")
        expect(actual).to be_falsy
      end
    end
  end
end
