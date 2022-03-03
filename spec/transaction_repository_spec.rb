require 'pry'
require 'rspec'
require 'csv'
require 'date'
require './lib/transaction'
require './lib/transaction_repository'
require './lib/sales_module'

RSpec.describe TransactionRepository do
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



  it 'exists' do
    expect(@se.transactions).to be_a TransactionRepository
  end

  it 'has readable attributes' do
    expect(@se.transactions.all.count).to eq(4985)
  end

  it 'has access to transactions with readable attributes' do
    transaction = @se.transactions.find_by_id(1)
    expect(transaction.id).to eq 1
    expect(transaction.id.class).to eq Fixnum
    expect(transaction.invoice_id).to eq 2179
    expect(transaction.invoice_id.class).to eq Fixnum
    expect(transaction.credit_card_number).to eq "4068631943231473"
    expect(transaction.credit_card_number.class).to eq String
    expect(transaction.credit_card_expiration_date).to eq "0217"
    expect(transaction.credit_card_expiration_date.class).to eq String
    expect(transaction.result).to eq :success
    expect(transaction.result.class).to eq Symbol
  end

  it 'can look up transactions by id' do
    # binding.pry
    test = @se.transactions.find_by_id(1)
    expect(test).to be_an_instance_of(Transaction)
    expect(test.id).to be 1
  end

  it 'can find all the transactions by their invoice id' do
    id = 2179
    test = @se.transactions.find_all_by_invoice_id(id)

    expect(test.length).to eq 2
    expect(test.first.invoice_id).to eq id
    expect(test.first.class).to eq Transaction

    id = 14560
    test = @se.transactions.find_all_by_invoice_id(id)
    expect(test.empty?).to eq true
  end

  it 'can find all the transactions by the credit card number' do
    credit_card_number = "4848466917766329"
    expected = @se.transactions.find_all_by_credit_card_number(credit_card_number)

    expect(expected.length).to eq 1
    expect(expected.first.class).to eq Transaction
    expect(expected.first.credit_card_number).to eq credit_card_number

    credit_card_number = "4848466917766328"
    expected = @se.transactions.find_all_by_credit_card_number(credit_card_number)

    expect(expected.empty?).to eq true
  end

  it 'can find all the transactions by their result' do
    result = :success
    expected = @se.transactions.find_all_by_result(result)

    expect(expected.length).to eq 4158
    expect(expected.first.class).to eq Transaction
    expect(expected.first.result).to eq result

    result = :failed
    expected = @se.transactions.find_all_by_result(result)

    expect(expected.length).to eq 827
    expect(expected.first.class).to eq Transaction
    expect(expected.first.result).to eq result
  end

  it 'creates a new transaction object' do
    attributes = {
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => :success,
        :created_at => Time.now,
        :updated_at => Time.now
      }
      @se.transactions.create(attributes)
      expected = @se.transactions.find_by_id(4986)
      expect(expected.invoice_id).to eq 8
  end

  it 'updates a current transaction object' do
    attributes = {
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => :success,
        :created_at => Time.now,
        :updated_at => Time.now
      }
    @se.transactions.create(attributes)

    original_time = @se.transactions.find_by_id(4986).updated_at
    attributes = {
      result: :failed
    }
    @se.transactions.update(4986, attributes)

    expected = @se.transactions.find_by_id(4986)

    expect(expected.result).to eq :failed
    expect(expected.credit_card_expiration_date).to eq "0220"
    expect(expected.updated_at).to be > original_time
  end

  it 'can delete transactions by id number' do
    attributes = {
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => :success,
        :created_at => Time.now,
        :updated_at => Time.now
      }
    @se.transactions.create(attributes)

    @se.transactions.delete(4986)
    expected = @se.transactions.find_by_id(4986)
    expect(expected).to eq nil
  end

end
