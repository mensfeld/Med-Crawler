require File.join(File.dirname(__FILE__), 'config', 'config.rb')


('a'..'z').to_a.each_slice(2).to_a.each do |set|
  threads = []

  set.each do |letter|
    threads << Thread.new do
      @edrugs = MedParser::Source.new("http://www.edrugsearch.com/drug-list/drug-prices-alpha-#{letter}")
      @edrugs.parse! do |product_attrs|
        shop = Shop.insert(product_attrs[:pharmacy])
        product = Product.insert(product_attrs[:name])
        price = Price.insert(product_attrs[:total_cost])

        fact = proc { |id_parameter|
          FactTable.create(
            :id_product => product.id,
            :id_shop => shop.id,
            :id_price => price.id,
            :id_parameter => id_parameter
          )
        }

        # attributes
        quantity = Parameter.insert(:quantity, product_attrs[:quantity])
        fact.call(quantity.id)

        quantity_type = Parameter.insert(:quantity_type, product_attrs[:quantity_type])
        fact.call(quantity_type.id)

        unit_price = Parameter.insert(:unit_price, product_attrs[:unit_price])
        fact.call(unit_price.id)

        url = Parameter.insert(:url, product_attrs[:url])
        fact.call(url.id)
      end
    end
  end

  threads.each { |thr| thr.join }
end
