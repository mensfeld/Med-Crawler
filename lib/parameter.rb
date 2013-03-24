class Parameter < ActiveRecord::Base

  self.primary_key = :id_parameter
  self.inheritance_column = nil


  def self.insert(type, value)
    create!(:type => type, :value => value)
  end

end
