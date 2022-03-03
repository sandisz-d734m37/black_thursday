module SalesModule
  def find_by_id(id)
    @all.find{|individual| individual.id == id}
  end

  def find_by_name(name)
    @all.find{|individual| individual.name.downcase == name.downcase}
  end

  def find_all_by_name(name)
    found = []
    found << @all.select {|individual| individual.name.downcase.include?(name.downcase)}
    found.flatten
  end

  def delete(id)
    @all.delete(find_by_id(id))
  end
end
