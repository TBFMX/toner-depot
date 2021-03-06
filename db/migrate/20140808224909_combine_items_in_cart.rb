class CombineItemsInCart < ActiveRecord::Migration
  def change
  end

  def up
	# replace multiple items for a single product in a cart with a single item
	Cart.all.each do |cart|
		# count the number of each product in the cart
		sums = cart.line_items.group(:cartucho_id).sum(:quantity)
		sums.each do |cartucho_id, quantity|
			if quantity > 1
				# remove individual items
				cart.line_items.where(cartucho_id: cartucho_id).delete_all
				# replace with a single item
				item = cart.line_items.build(cartucho_id: cartucho_id)
				item.quantity = quantity
				item.save!
			end
		end
	end
  end

  def down
	# split items with quantity>1 into multiple items
	LineItem.where("quantity>1").each do |line_item|
		# add individual items
		line_item.quantity.times do
			LineItem.create cart_id: line_item.cart_id,
				cartucho_id: line_item.cartucho_id, quantity: 1
		end
		# remove original item
		line_item.destroy
	end
  end

end
