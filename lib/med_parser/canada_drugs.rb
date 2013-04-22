module MedParser

  class CanadaDrugs

    attr_reader :current_page

    def initialize(start_url)
      uri = URI.parse(start_url)
      @host = "#{uri.scheme}://#{uri.host.downcase}"
      @current_page = nil
      load(@start_url = start_url)
    end

    def parse!
      product_links = @current_page.
        search('.ListHeader li a.dotted').
        collect{ |a| "#{@host}#{a['href']}" }
      product_links.uniq!

      product_links.each do |product_link|
        load(product_link)
        @current_page.search('#filter_results .ListBg').each do |row|
          attrs = {}
          row.search('.Floatleft').each_with_index do |cell, index|
            case index
            when 0 then
              attrs[:pharmacy] = cell.search('img').first['src']
            when 1 then
              attrs[:name] = @current_page.search('.activeOne').first.content
            when 2 then
              # Skip this cell
            when 3 then
              attrs[:quantity] = cell.search('p').first.content.to_i
              attrs[:quantity_type] = cell.search('p').first.content.split(' ')[1..-1].join(' ')
            when 4 then
              attrs[:total_cost] = cell.search('p').first.content.gsub('$', '').to_f
            when 5 then
              attrs[:unit_price] = cell.search('p').first.content.gsub('$', '').to_f
            end
          end

          attrs[:url] = "#{@host}#{row.search('.Floatright a').first['href']}"

          # Yield only if there is a valid product
          yield(attrs) if attrs[:name] && attrs[:name] != ''
        end
      end
    end

    private

    def load(url)
      MedParser.logger.debug { "Loading url #{url}" }
      begin
        @current_page = Nokogiri::HTML(open(url))
      rescue => e
        p e
        retry
      end
    end

  end

end
