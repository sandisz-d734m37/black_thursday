require 'csv'
require 'bigdecimal'
require 'time'
require './lib/item'

RSpec.describe Item do
  before(:each) do
    @i = Item.new({
    :id          => 1,
    :name        => "Pencil",
    :description => "You can use it to write things",
    :unit_price  => BigDecimal(1099,4),
    :created_at  => Time.new(2002, 10, 29),
    :updated_at  => Time.new(2002, 10, 31),
    :merchant_id => 2
    })
  end

  describe "instantiation" do
    it "creates instance" do
      expect(@i).to be_an_instance_of(Item)
    end


    it "has readable attributes" do
      expect(@i.id).to eq(1)
      expect(@i.name).to eq("Pencil")
      expect(@i.description).to eq("You can use it to write things")
      expect(@i.unit_price).to eq(BigDecimal(10.99,4))
      expect(@i.unit_price.class).to eq BigDecimal
      expect(@i.merchant_id).to eq(2)
      expect(@i.created_at).to eq(Time.new(2002, 10, 29))
      expect(@i.created_at.class).to eq Time
      expect(@i.updated_at).to eq(Time.new(2002, 10, 31))
      expect(@i.updated_at.class).to eq Time
    end
  end

    it "returns price of item in dollars as a float" do
      expect(@i.unit_price_to_dollars).to eq(10.99)
      expect(@i.unit_price_to_dollars.class).to eq Float
    end
end
