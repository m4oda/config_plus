require 'spec_helper'

RSpec.describe ConfigPlus::Config, '#has_property?' do
  context "define `foo' as property with prop_accessor method" do
    before do
      described_class.instance_eval { prop_accessor :foo }
    end

    let(:instance) { described_class.new }

    context "call with a parameter :foo" do
      it 'returns true' do
        actual = instance.has_property?(:foo)
        expect(actual).to be_truthy
      end
    end

    context "call with a parameter 'foo'" do
      it 'returns true' do
        actual = instance.has_property?("foo")
        expect(actual).to be_truthy
      end
    end

    context "call with a parameter :baa" do
      it 'returns false' do
        actual = instance.has_property?(:baa)
        expect(actual).to be_falsy
      end
    end

    context "call with a parameter 'baa'" do
      it 'returns false' do
        actual = instance.has_property?("baa")
        expect(actual).to be_falsy
      end
    end
  end
end
