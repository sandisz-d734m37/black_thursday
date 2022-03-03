Creating the "most_sold_item_for_merchant(merchant_id)" method : 
The first step was to build a helper method. After multiple attempts, we decided that trying to fit everything into one method was going to yield an unwieldy and hard-to-test method. Not to mention it would be about 12 lines long.
This helper method would accomplish two things: it would shorten the most sold item method, and it would provide the same starting blocks we would need to build the last method in Iteration 4. It looks like this:

```ruby
  def successful_invoices_by_merchant(merchant_id)
    all_success_trans = @transactions.find_all_by_result("success")
    all_success_trans = all_success_trans.map {|trans| trans.invoice_id}
    all_invoices_of_merch = @invoices.find_all_by_merchant_id(merchant_id)
    all_success_invoices = all_invoices_of_merch.select {|invoice| all_success_trans.include?(invoice.id)}
    all_success_invoices = all_success_invoices.reject {|invoice| invoice.status == :returned}
    all_success_invoices.map {|invoice| @invoice_items.find_all_by_invoice_id(invoice.id)}
  end
 ```
 
 So, you can see that we have made a method that connects Transactions to Invoices, Invoices to Merchants, and filters out Invoices that have a status of "returned", as they don't reflect a complete sale.
 
 Now that we have a list of all successful invoices by any specific merchant, we move on to the next method.
 The first thing we do is take the result from the helper method and set it equal to a new variable.
 
 ```ruby 
    def most_sold_item_for_merchant(merchant_id)
    ii_by_merch = successful_invoices_by_merchant(merchant_id)
  ```
  Invoice items by merchant is our new variable. Now, we want to feed it into a process that will create a new Hash that will have keys of item id and values of item quantity: 
  
  ```ruby 
     items_hash = Hash.new(0)
     ii_by_merch.flatten.each {|ii| items_hash[ii.item_id] += ii.quantity}
  ```  
  In doing so, every time an duplicate item id goes into the hash, we make sure that the quantities are aggregated   to achieve a total quantity. 
  
  The next step is to sort the items_hash by values (item quantities), reverse it because it defaults to low-to-     high, and return it to a hash because sort_by creates an array.
  
  ```ruby 
  items_hash = items_hash.sort_by {|k, v| v}.reverse!.to_h
  ```
  
  Now that we can iterate through our hash of item quantities by key-value pairs, and in doing so we create a new     hash with keys set to instances of Item, and the values set to item invoice quantities.
  
  ```ruby
  test = Hash.new(0)
  items_hash.each {|k, v| test[@items.find_by_id(k)] = v}
  ```
  Our final step is to call a filter map on this final hash, which will produce an array of the keys (instances of   Item) and set the values to the item quantities. Basically, we want to create an array of just the keys, and the   only keys that we want are the ones whose values are the same as the first item instance, because that is the top   selling item.
  
  Creating the "best_item_for_merchant(merchant_id)" method 
  
  Here again we will make use of our helper method to find successful invoices. We flatten and use it in an each loop where we make a new Hash.We populate the Hash with all of the item invoices by merchant as keys, and set their values to an aggregate count of the total quantity of those items. 
  ```ruby
  def best_item_for_merchant(merchant_id)
    ii_by_merch = successful_invoices_by_merchant(merchant_id)
    items_hash = Hash.new(0)
    ii_by_merch.flatten.each {|ii| items_hash[ii] += ii.quantity}
  ```
  
  Then we'll feed that into a new Hash whose keys are the invoice items and the values are the quantity of the invoice items multiplied by the unit price. This gives us the total amount of revenue generated for those invoice items. 
  ```ruby 
  prices_hash = Hash.new(0)
    items_hash = items_hash.each {|k, v| prices_hash[k] = v * k.unit_price}
  ```
  
  Next we'll sort it by the value (total value) which generates an array, and reverse it to get the highest revenues first, and convert it back into a hash. 
  ```ruby
  prices_hash = prices_hash.sort_by {|k, v| v}.reverse!.to_h
  ```
 
  Last, we use the now-sorted hash of invoice items that are associate with the total revenue, and match the item ids on the invoice items to instances of Item.
  ```ruby
  @items.find_by_id(prices_hash.keys.first.item_id)
  end
  ```
