class HomeController < ApplicationController
	before_action :authenticate_user!
	
	def index
		if current_user.cart_id==nil
			@active_cart = Cart.create(user_id:current_user.id)
			current_user.update(cart_id:@active_cart.id)
		end
		@aaa= 'bbb'
		
		reloadVariables
	end

	def addtocart
		cart_item = CartItem.find_by(cart_id:current_user.cart_id, item_id:params[:item_id])
		if cart_item==nil
			cart_item = CartItem.create(cart_id:current_user.cart_id, item_id:params[:item_id], item_qty:0) 
		end	
		cart_item.update(item_qty:cart_item.item_qty+params[:item_qty].to_i)	
		
		item = Item.find_by(id:params[:item_id])
		item.update(qty:item.qty-params[:item_qty].to_i)
		
		reloadVariables
	end

	def removefromcart
		cart_item = CartItem.find_by(id:params[:cart_item_id])
		item = Item.find_by(id:cart_item.item_id)
		item.update(qty:item.qty+cart_item.item_qty)
		cart_item.destroy
		
		reloadVariables
	end

	def checkout
		
		#items_queue = Item.find_by(id:).joins('LEFT JOIN items ON cart_items.item_id=items.id') # Items in active cart
		@cart_itemm = CartItem.where(cart_id:current_user.cart_id)
		if @cart_itemm == nil || @cart_itemm.size < 1
			reloadVariables
			return
		end

		@item_price = Array.new(@cart_itemm.size)
		@total_price = 0
		for i in 0..@cart_itemm.size-1
			@item_price[i] = Item.find_by(id:@cart_itemm[i].item_id)
			@aaa=@item_price[i].unit_price+200
			if @item_price[i]==nil
				@aaa='ffff'
			end
			@cart_itemm[i].update(item_unit_price:@item_price[i].unit_price)
			@total_price += (@item_price[i].unit_price*@cart_itemm[i].item_qty)
		end	
		#@aaa=@total_price
		current_user.update(cart_id:Cart.create(user_id:current_user.id).id)
		
		reloadVariables
	end



private

	def reloadVariables
		@all_items = Item.all # Item browsing
		
		@cart_items = CartItem.where(cart_id:current_user.cart_id)
		# .joins('LEFT OUTER JOIN items ON cart_items.item_id=items.id') 
		# Items in active cart
		
		# History
		@user_carts = Cart.where(user_id:current_user.id).where.not(id:current_user.cart_id)
		# @aaa = @cart_items[0].attribute_names;
		@orders = Array.new(@user_carts.size)
		@order_items = Array.new(@orders.size)
		for i in 0..@user_carts.size-1
			@orders[i] = CartItem.where(cart_id:@user_carts[i].id)
			@order_items[i]=Array.new(@orders[i].size)
			for j in 0..@orders[i].size-1
				@order_items[i][j]=Item.find_by(id:@orders[i][j].item_id)
			end
		end
		
		render 'app/views/home/index.html.erb' # Go to home page
	end

end
