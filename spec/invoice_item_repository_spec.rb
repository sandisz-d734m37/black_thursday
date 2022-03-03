require 'pry'
require 'rspec'
require 'csv'
require 'date'
require 'bigdecimal/util'
require './lib/invoice_item_repository'
require './lib/sales_engine'

RSpec.describe InvoiceItemRepository do

  before(:each) do
    @se = SalesEngine.from_csv({
        :items     => "./data/items.csv",
        :merchants => "./data/merchants.csv",
        :invoices => './data/invoices.csv',
        :customers => './data/customers.csv',
        :transactions => './data/transactions.csv',
        :invoice_items => './data/invoice_items.csv'
                              })
  end


  it 'exists' do
    expect(@se.invoice_items).to be_a(InvoiceItemRepository)
  end

  it 'has retreivable attributes' do
    expect(@se.invoice_items.all).to be_a(Array)
    expect(@se.invoice_items.all[1]).to be_a(InvoiceItem)
  end

  it "has access to Invoice Items with readable attributes" do
    invoice_item = @se.invoice_items.find_by_id(2345)
    expect(invoice_item.id).to eq 2345
    expect(invoice_item.id.class).to eq Fixnum
    expect(invoice_item.item_id).to eq 263562118
    expect(invoice_item.item_id.class).to eq Fixnum
    expect(invoice_item.invoice_id).to eq 522
    expect(invoice_item.invoice_id.class).to eq Fixnum
    expect(invoice_item.unit_price).to eq 847.87
    expect(invoice_item.unit_price.class).to eq BigDecimal
    expect(invoice_item.created_at).to eq Time.parse("2012-03-27 14:54:35 UTC")
    expect(invoice_item.created_at.class).to eq Time
    expect(invoice_item.updated_at).to eq Time.parse("2012-03-27 14:54:35 UTC")
    expect(invoice_item.updated_at.class).to eq Time
  end

  it 'can find by the item id' do
    id = 10
    expected = @se.invoice_items.find_by_id(id)
    expect(expected.id).to eq id
    expect(expected.item_id).to eq 263523644
    expect(expected.invoice_id).to eq 2
  end

  it 'can find all item invoices by the item id' do
    item_id = 263408101
    expected = @se.invoice_items.find_all_by_item_id(item_id)
    expect(expected.first.item_id).to eq 263408101
    expect(expected.length).to eq 11
    expect(expected.first).to be_a(InvoiceItem)
  end

  it 'can find all item invoices by the invoice id' do
    invoice_id = 100
    expected = @se.invoice_items.find_all_by_invoice_id(invoice_id)
    expect(expected.first.invoice_id).to eq 100
    expect(expected.length).to eq 3
    expect(expected.first).to be_a(InvoiceItem)
  end

  it 'creates a new invoice item' do
    attributes = {
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now.to_s,
        :updated_at => Time.now.to_s
      }
      @se.invoice_items.create(attributes)
      expected = @se.invoice_items.find_by_id(21831)
      expect(expected.item_id).to eq 7
  end

  it 'updates an existing invoice item in the repository' do
    attributes = {
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now.to_s,
        :updated_at => Time.now.to_s
      }
      @se.invoice_items.create(attributes)
    original_time = @se.invoice_items.find_by_id(21831).updated_at
      attributes = {
        quantity: 13
      }
      @se.invoice_items.update(21831, attributes)
      expected = @se.invoice_items.find_by_id(21831)
      expect(expected.quantity).to eq 13
      expect(expected.item_id).to eq 7
      expect(expected.updated_at).to be > original_time
  end

  it 'can delete an invoice item instance by the id number' do
    attributes = {
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
      }
    @se.invoice_items.create(attributes)
    expected = @se.invoice_items.find_by_id(21831)
    expect(expected.id).to eq 21831
    @se.invoice_items.delete(21831)
    expected = @se.invoice_items.find_by_id(21831)
    expect(expected).to eq nil
  end

  it "can find all by date" do
    expect(@se.invoice_items.find_all_by_date("2014-02-13").length).to eq 1
  end
end
