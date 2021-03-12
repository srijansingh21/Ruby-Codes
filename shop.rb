require 'byebug'

# TODO: 1. Add Cart class
#       2.Add Calculator class

class Shop
  # List Products
  def self.list_products
    products = Product.new.instance_variables
    p "List of Products available:"
    products.each { |product| p product.to_s.gsub('@', '') }
  end
  # cart = Cart.new
  # details of product_details
  # product_details.price
  # product_details.units
  # cart_item = CartItem.new(product_detail, 3)
  # cart.add(cart_item)
  # View Cart
  # cart.products
end
class Product
  def initialize
    products = Seeder.seed
    products.each do |product_name, details|
      self.class.__send__(:attr_accessor, product_name)
      instance_variable_set("@#{product_name}", ProductDetails.new(details))
    end
  end

  class ProductDetails
    attr_accessor :per_gm_price, :units
    def initialize details
      @per_gm_price = Price.new(details[:per_gm_price], details[:units])
      @units = UnitType.new(details[:units])
    end
    # utility function_1 - to get all the details of a product
    def details
      @details = "per_gm_price: #{@per_gm_price.to_s}, Units_available (in gm): #{@units.units_available}"
    end
    # utility function_2 - calculate price according to unit provided by the user
    def calc_price(unit)
      raise "Unit Not available" unless @units.validate(unit)
      per_gm_price.price * unit
    end

    class Price
      attr_accessor :price, :units
      def initialize price, units
        @price = price
        @units = UnitType.new(units)
      end
      def inspect
        price
      end
      def to_s
        "#{price}"
      end
      def per_gm
        price.to_f / units.per_gm
      end
    end
    class UnitType
      attr_accessor :units_available
      def initialize units
        @units_available = units
      end

      def to_s
        "#{units_available}"
      end

      def validate(unit)
        # see if queried unit is available or not and of the correct format
        @units_available.include?(unit)
      end

      alias inspect to_s
    end
  end

  class History
  end

  class Cart
    class CartItem
      attr_accessor :product_detail, :quantity
      def item_cost
      end
    end
  end
  class Seeder
    def self.seed
      {
        paneer: { per_gm_price: 1, units: [50, 100, 500] },
        cheese: { per_gm_price: 1, units: [30, 50] }
      }
    end
  end
end

# list all products
# p Shop.list_products

# get all details of a product
# p Product.new.paneer.details

# get available units of a product
# p Product.new.paneer.units.units_available

# get per_gm price of a product
# p Product.new.paneer.per_gm_price

# get price of a particular unit in gm
# p Product.new.cheese.calc_price(50)
