def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item_hash|
    count = cart.count(item_hash)
    item_hash.each do |item, data|
      consolidated_cart[item] = data
      consolidated_cart[item][:count] = count
    end 
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_item = coupon[:item]
    if cart[coupon_item] && cart[coupon_item][:count] >= coupon[:num]
      cart[coupon_item][:count] -= coupon[:num]
      if cart["#{coupon_item} W/COUPON"]
        cart["#{coupon_item} W/COUPON"][:count] += 1 
      else  
      cart["#{coupon_item} W/COUPON"] = {:price => coupon[:cost], :count => 1, :clearance => cart[coupon_item][:clearance]}
      end 
    end 
  end
  cart 
end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance] == true 
      clearance_price = details[:price] *0.80 
      details[:price] = clearance_price.round(2)
    end
  end 
end

def checkout(cart, coupons)
  final_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0 
  final_cart.each do |item, data|
    total += data[:price]*data[:count]
  end
  if total > 100 
    total *= 0.90
  end
  total 
end
