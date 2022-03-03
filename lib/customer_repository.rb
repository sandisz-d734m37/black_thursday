require 'csv'
require 'date'
require_relative 'customer'
require_relative 'sales_module'

class CustomerRepository
  attr_reader :all, :customers
  def initialize(csv)
    @all = Customer.read_file(csv)
  end

  include SalesModule

  def find_by_id(id)
    @all.find{|customer| customer.id == id}
  end

  def find_all_by_first_name(first_name)
    @all.find_all{|customer| customer.first_name.downcase.include?(first_name.downcase)}
  end

  def find_all_by_last_name(last_name)
    @all.find_all{|customer| customer.last_name.downcase.include?(last_name.downcase)}
  end

  def create(data)
    new_customer = Customer.new({
      id: (@all[-1].id + 1),
      first_name: data[:first_name],
      last_name: data[:last_name],
      created_at: Time.now.to_s,
      updated_at: Time.now.to_s})
      @all << new_customer
  end

  def update(id, data)
    updated_customer = find_by_id(id)
    return nil if updated_customer.nil?
    updated_customer.first_name = data[:first_name] unless data[:first_name].nil?
    updated_customer.last_name = data[:last_name] unless data[:last_name].nil?
    updated_customer.updated_at = Time.now
  end


end
