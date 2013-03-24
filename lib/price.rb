class Price < ActiveRecord::Base

  self.primary_key = :id_price

  def self.insert(price)
    date = Time.now.strftime("%Y-%m-%d")
    el = find_by_value_and_date(price, date)
    el ||  create!(:value => price, :date => date)
  end

end
