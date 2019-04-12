require 'pry'


# def items
# 	[
# 		{"AVOCADO" => {:price => 3.00, :clearance => true}},
# 		{"KALE" => {:price => 3.00, :clearance => false}},
# 		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
# 		{"ALMONDS" => {:price => 9.00, :clearance => false}},
# 		{"TEMPEH" => {:price => 3.00, :clearance => true}},
# 		{"CHEESE" => {:price => 6.50, :clearance => false}},
# 		{"BEER" => {:price => 13.00, :clearance => false}},
# 		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
# 		{"BEETS" => {:price => 2.50, :clearance => false}}
# 	]
# end
#
# def coupons
# 	[
# 		{:item => "AVOCADO", :num => 2, :cost => 5.00},
# 		{:item => "BEER", :num => 2, :cost => 20.00},
# 		{:item => "CHEESE", :num => 3, :cost => 15.00}
# 	]
# end
#
# def generate_cart
# 	[].tap do |cart|
# 		rand(20).times do
# 			cart.push(items.sample)
# 		end
# 	end
# end
#
# def generate_coupons
# 	[].tap do |c|
# 		rand(2).times do
# 			c.push(coupons.sample)
# 		end
# 	end
# end
#
# cart_list = generate_cart
# coupons_list = generate_coupons

def consolidate_cart(cart)
  #binding.pry
	consolidated_cart = {}

	cart.each {|element|
		element.each {|item, hash|
			if !consolidated_cart.keys.include?(item)
				consolidated_cart[item] = hash
        if consolidated_cart[item][:count].nil?
          consolidated_cart[item][:count] = 1
        end
			elsif consolidated_cart.keys.include?(item)
				consolidated_cart[item][:count] += 1
			end
		}
	}

	consolidated_cart
  #binding.pry
end

def apply_coupons(cart, coupons)
  if coupons == []
    cart
  end

  coupons.each {|coupon|
    cart_item = cart[coupon[:item]]
    coupon_name = "#{coupon[:item]} W/COUPON"

    if cart.keys.include?(coupon[:item]) && cart_item[:count] >= coupon[:num]
      if !cart.keys.include?(coupon_name)
        cart[coupon_name] = {
            price: coupon[:cost],
            clearance: cart_item[:clearance],
            count: 1
          }
      elsif cart.keys.include?(coupon_name)
        cart[coupon_name][:count] += 1
      end

      cart_item[:count] = cart_item[:count] - coupon[:num]
    end
  }
  cart
end

def apply_clearance(cart)
  clearance_cart =
    cart.each {|item, hash|
      if hash[:clearance]
        hash[:price] = (hash[:price] * 0.8).round(1)
      end
    }
end

def checkout(cart, coupons)
  cart_total = 0.00
  checkout_cart = consolidate_cart(cart)
  #binding.pry
  checkout_cart = apply_coupons(checkout_cart, coupons)
  #binding.pry
  checkout_cart = apply_clearance(checkout_cart)
  #binding.pry

  checkout_cart.each {|item, data|
    cart_total += data[:count] * data[:price]
  }
  #binding.pry
  if cart_total > 100
    cart_total *= 0.9
  end
	cart_total
end
