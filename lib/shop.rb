class Shop < ActiveRecord::Base

  self.primary_key = :id_shop

  def self.insert(name)
    find_or_initialize_by_name(name).tap{ |el| el.save }
  end

end
