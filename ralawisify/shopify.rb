class Ralawisify
  class Shopify
    def initialize(rows)
      @rows = rows
    end

    def self.headers
      new(nil).mapping.keys
    end

    def mapping
      {
        'Handle' => :formatted_handle,
        'Title' => 'Name',
        'Body (HTML)' => 'Description',
        'Vendor' => 'Brand Name',
        'Type' => nil,
        'Tags' => :tags,
        'Published' => :published?,
        'Option1 Name' => nil,
        'Option1 Value' => nil,
        'Option2 Name' => nil,
        'Option2 Value' => nil,
        'Option3 Name' => nil,
        'Option3 Value' => nil,
        'Variant SKU' => 'SKU',
        'Variant Grams' => nil,
        'Variant Inventory Tracker' => nil,
        'Variant Inventory Qty' => :inventory_quantity,
        'Variant Inventory Policy' => :inventory_policy,
        'Variant Fulfillment Service' => :fulfillment,
        'Variant Price' => 'Singleprice',
        'Variant Compare At Price' => 'Singleprice',
        'Variant Requires Shipping' => :shipping?,
        'Variant Taxable' => :taxable?,
        'Variant Barcode' => nil,
        'Image Src' => :image,
        'Image Alt Text' => :image_alt
      }
    end

    def as_array
      as_hash.values
    end

    def as_hash
      mapping.inject({}, &row)
    end

    private

    def formatted_handle
      title.map(&:downcase).join('-').gsub(' ', '-')
    end

    def image_alt
      title.join(' ')
    end

    def title
      [ @rows.first['Brand Name'], @rows.first['Name'] ]
    end

    def published?
      'FALSE'
    end

    def shipping?
      'TRUE'
    end

    def taxable?
      'TRUE'
    end

    def fulfillment
      'manual'
    end

    def inventory_policy
      'deny'
    end

    def inventory_quantity
      1
    end

    def image
      'http://www.promotional-store.com/images/thumbs/' + @rows.first['LifeStylePic']
    end

    def tags
      @rows.map { |x| x['Subcategory'] }.uniq.join(', ')
    end

    def row
      ->(acc, (k,v)) { acc.merge({ k => value_for(v) }) }
    end

    def value_for(value)
      send(value)
    rescue NoMethodError, TypeError
      @rows.first[value]
    end
  end
end
