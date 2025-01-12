require 'csv'
require'./lib/sales_engine'
# require './lib/sales_module'
require './lib/item'
require './lib/item_repository'

RSpec.describe ItemRepository do
  before (:each) do
    @se = SalesEngine.from_csv({
        :items     => "./data/items.csv",
        :merchants => "./data/merchants.csv",
        :invoices => './data/invoices.csv',
        :customers => './data/customers.csv',
        :transactions => './data/transactions.csv',
        :invoice_items => './data/invoice_items.csv'
                              })
  end

  describe "instantiation" do
    it "exists" do
      expect(@se.items).to be_a(ItemRepository)
    end

    it "has readable attributes" do
      expect(@se.items.all.length).to eq(1367)
    end
  end

  it "can find an item by id" do
    id = 263538760
    expected = @se.items.find_by_id(id)

    expect(expected.id).to eq id
    expect(expected.name).to eq "Puppy blankie"

    id = 1
    expected = @se.items.find_by_id(id)

    expect(expected).to eq nil
  end

  it "finds an item by name" do
    name = "Puppy blankie"
    expected = @se.items.find_by_name(name)

    expect(expected.name).to eq name
    expect(expected.id).to eq 263538760

    name = "Sales Engine"
    expected = @se.items.find_by_name(name)

    expect(expected).to eq nil
  end

  it "can return an array of all items" do
    expect(@se.items.all.class).to be(Array)
  end

  it "can find all items by description" do
    expect(@se.items.find_all_with_description("Acrylique sur toile et collage.")[0].name).to eq("Moyenne toile")
    expect(@se.items.find_all_with_description("Stupid Fart Face.")).to eq([])
  end

  it "can find all items by price" do
    expect(@se.items.find_all_by_price(17.90)).to include(@se.items.find_by_id(263424923))
    expect(@se.items.find_all_by_price(0)).to eq([])
  end

  it "can find all items within a given range" do
    expect(@se.items.find_all_by_price_in_range(100..10000).length).to eq(298)
    expect(@se.items.find_all_by_price_in_range(1000..2000).length).to eq(26)
    expect(@se.items.find_all_by_price_in_range(100000..2000000)).to eq([])
  end

  it "can find all items by merchant id" do
    expect(@se.items.find_all_by_merchant_id(12334213).length).to eq(2)
    expect(@se.items.find_all_by_merchant_id(2)).to eq([])
  end

  it "can create a new instance of item with provided attributes" do
    expect(@se.items.find_all_by_merchant_id(12334213).length).to eq(2)
    @se.items.create({name: "Item name", description: "It's an item", unit_price: 1000, merchant_id: 12334213})
    expect(@se.items.find_all_by_merchant_id(12334213).length).to eq(3)
  end

  it "can update the Item instance to change attributes" do
    expect(@se.items.find_by_id(263416405).name).to eq("Tappeto pon pon")
    @se.items.update(263416405, {name: "nothing", description: "not really an item", unit_price: 160001})
    expect(@se.items.find_by_id(263416405).name).to eq("nothing")
  end

  it "can delete items by id" do
    @se.items.create({name: "Item name", description: "It's an item", unit_price: 1000, merchant_id: 12334213})
    expect(@se.items.find_all_by_merchant_id(12334213).length).to eq(3)
    @se.items.delete(263567475)
    expect(@se.items.find_all_by_merchant_id(12334213).length).to eq(2)
  end

end
