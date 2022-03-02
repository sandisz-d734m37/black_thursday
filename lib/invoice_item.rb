require 'pry'
require 'rspec'
require 'csv'
require 'date'
require 'bigdecimal/util'
require_relative 'invoice_item'
require_relative 'sales_module'

class InvoiceItem
  attr_reader :id, :item_id, :invoice_id, :created_at
  attr_accessor :quantity, :unit_price, :updated_at

  def initialize(data)
    @id = data[:id].to_i
    @item_id = data[:item_id].to_i
    @invoice_id = data[:invoice_id].to_i
    @quantity = data[:quantity].to_i
    @unit_price = BigDecimal((data[:unit_price]), 4) / 100
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.read_file(csv)
    rows = CSV.read(csv, headers: true, header_converters: :symbol)
    rows.map do |row|
      new(row)
    end
  end

  def unit_price_to_dollars
    price_to_dollars = @unit_price.to_f
  end

  def find_all_by_date(date)
    all.find_all{|invoice| invoice.created_at == date}

  end

end
