require './lib/sales_engine'
require './lib/item_repository'
require './lib/merchant_repository'
require './lib/sales_analyst'
require './lib/invoice_repository'
require './lib/invoice_item_repository'
require 'date'
require 'pry'

describe SalesAnalyst do
  before(:each) do
    sales_engine = SalesEngine.from_csv({
        :merchants => "./data/merchants.csv",
        :items     => "./data/items.csv",
        :invoices => './data/invoices.csv',
        :customers => './data/customers.csv',
        :transactions => './data/transactions.csv',
        :invoice_items => './data/invoice_items.csv'
                              })
    @sales_analyst = sales_engine.analyst
  end

  it "exists" do
    expect(@sales_analyst).to be_an_instance_of(SalesAnalyst)
  end

  it "can list all items by merchant ID" do
    expect(@sales_analyst.list_all_items_by_merchant.length).to eq(475)
    expect(@sales_analyst.list_all_items_by_merchant[3].length).to eq(20)
    expect(@sales_analyst.list_all_items_by_merchant[1].length).to eq(6)
    expect(@sales_analyst.list_all_items_by_merchant[5].length).to eq(1)
  end

  it "can determine the average items per merchant" do
    expect(@sales_analyst.average_items_per_merchant).to eq(2.88)

  end

  it "can determine the standard deviation of items per merchant" do
    expect(@sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
  end

  it "can determine merchants with high item counts" do
    expect(@sales_analyst.merchants_with_high_item_count[0].name).to eq("FlavienCouche")
    expect(@sales_analyst.merchants_with_high_item_count[2].name).to eq("BowlsByChris")
    expect(@sales_analyst.merchants_with_high_item_count[35].name).to eq("BoDaisyClothing")
  end

  it "can determine average item price for merchant" do
    expect(@sales_analyst.average_item_price_for_merchant(12334105)).to eq(16.66)
    expect(@sales_analyst.average_item_price_for_merchant(12334105)).to be_a(BigDecimal)
  end

  it 'can determine the average of the average item price by merchant' do
    a = @sales_analyst.average_average_price_per_merchant
    expect(a).to eq 350.29
    expect(a.class).to eq BigDecimal
  end

  it 'gets the average price of all items' do
    a = @sales_analyst.average_item_price
    expect(a).to eq 251.06
    expect(a.class).to eq BigDecimal
  end

  it 'gets the total item price standard deviation' do
    a = @sales_analyst.item_price_standard_deviation
    expect(a).to eq 2900.99
  end

  it 'gets the golden items' do
    a = @sales_analyst.golden_items
    expect(a.length).to eq 5
    expect(a[0].class).to eq Item
  end

  it 'can list all invoices by merchant' do
    a = @sales_analyst.list_all_invoices_by_merchant
    expect(a.length).to eq(475)
  end

  it "can find the average invoices per merchant" do
    a = @sales_analyst.average_invoices_per_merchant
    expect(a).to eq(10.49)
  end

  it "can find the average invoices per merchant standard deviation" do
    a = @sales_analyst.average_invoices_per_merchant_standard_deviation
    expect(a).to eq(3.29)
  end

  it "can find the top merchants by invoice count" do
    a = @sales_analyst.top_merchants_by_invoice_count
    expect(a.length).to eq(12)
    expect(a.first.class).to eq(Merchant)
  end

  it "can find the lowest performing merchants" do
    a = @sales_analyst.bottom_merchants_by_invoice_count
    expect(a.count).to eq(4)
    expect(a.first.class).to eq(Merchant)
  end

  it "can determine the invoices by the day of the week" do
    expect(@sales_analyst.invoices_by_days_of_the_week[0].length).to eq(708)
  end

  it "can determine the average invoices per day of week" do
    expect(@sales_analyst.average_invoices_per_day_of_week).to eq(712)
  end

  it "can determine the standard deviation of invoices per day of week" do
    expect(@sales_analyst.invoices_per_day_of_week_std_deviation).to eq(18)
  end

  it "can convert numbers into days" do
    expect(@sales_analyst.day_converter(3)).to eq("Wednesday")
  end

  it "can determine the top days by invoice count" do
    expect(@sales_analyst.top_days_by_invoice_count).to eq(["Wednesday"])
    expect(@sales_analyst.top_days_by_invoice_count.length).to eq(1)
  end

  it "can determine the percentage of invoices by status" do
    expect(@sales_analyst.invoice_status(:pending)).to eq(29.55)
    expect(@sales_analyst.invoice_status(:shipped)).to eq(56.95)
    expect(@sales_analyst.invoice_status(:returned)).to eq(13.5)
  end

  it "SalesAnalyst is_paid_in_full? returns true if the invoice is paid in full" do
    expected = @sales_analyst.invoice_paid_in_full?(1)
    expect(expected).to eq true

    expected = @sales_analyst.invoice_paid_in_full?(200)
    expect(expected).to eq true

    expected = @sales_analyst.invoice_paid_in_full?(203)
    expect(expected).to eq false

    expected = @sales_analyst.invoice_paid_in_full?(204)
    expect(expected).to eq false
  end

  it "SalesAnalyst total returns the total dollar amount if the invoice is paid in full" do
    expected = @sales_analyst.invoice_total(1)

    expect(expected).to eq 21067.77
    expect(expected.class).to eq BigDecimal
  end

  it "can give total revenue for a given date" do
    date = "2009-02-07"
    expected = @sales_analyst.total_revenue_by_date(date)
    expect(expected).to eq(21067.77)
    expect(expected.class).to eq(BigDecimal)
  end

  it "can return the top merchants ranked by revenue" do
    expect(@sales_analyst.top_revenue_earners(10).first.id).to eq(12334634)
    expect(@sales_analyst.top_revenue_earners(10).last.id).to eq(12335747)
    expect(@sales_analyst.top_revenue_earners(10).length).to eq(10)
    expect(@sales_analyst.top_revenue_earners(10).last.class).to eq(Merchant)
  end

  it "will return the top 20 merchants by default" do
    expect(@sales_analyst.top_revenue_earners.first.id).to eq(12334634)
    expect(@sales_analyst.top_revenue_earners.last.id).to eq(12334159)
    expect(@sales_analyst.top_revenue_earners.length).to eq(20)
  end
end
