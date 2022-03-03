require 'pry'
require './lib/sales_engine'

describe SalesEngine do
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
    expect(@se.items).to be_an_instance_of(ItemRepository)
    expect(@se.merchants).to be_an_instance_of(MerchantRepository)
    expect(@se.invoices).to be_an_instance_of(InvoiceRepository)
    expect(@se.customers).to be_an_instance_of(CustomerRepository)
    expect(@se.transactions).to be_an_instance_of(TransactionRepository)
    expect(@se.invoice_items).to be_an_instance_of(InvoiceItemRepository)
  end

  it 'returns an array of all merchant instances' do
    expect(@se.merchants.all.length).to eq 475
  end

  it 'returns an array of all item instances' do
    expect(@se.items.all.length).to eq 1367
  end

  it 'returns an array of all invoice instances' do
    expect(@se.invoices.all.length).to eq 4985
  end

  it 'returns an array of all customer instances' do
    expect(@se.customers.all.length).to eq 1000
  end

  it 'returns an array of all transaction instances' do
    expect(@se.transactions.all.length).to eq 4985
  end

  it 'returns an array of all invoice_item instances' do
    expect(@se.invoice_items.all.length).to eq 21830
  end

end
