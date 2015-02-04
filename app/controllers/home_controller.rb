class HomeController < ApplicationController
	before_action :authenticate_user!, :except => [:catalog, :index, :item]
	
	def index
		if current_user != nil
			if current_user.cart_id==nil
				current_user.update(cart_id:Cart.create(user_id:current_user.id).id)
			end
			reloadVariables
		else
			@top_items = Item.order(qty_sold: :desc).where("qty>0").limit(10)
			@all_items = Item.all
			render :index
		end
	end

	def carthistory
		reloadVariables
		render 'app/views/home/cart_history.html.erb'
	end

	def cart
		# default is current cart_id
		# show all query_cart_items of that
		# mkae sure to have the variable @query_cart_id checkout will appear here
		reloadVariables
		@cart = Cart.find_by(id:current_user.cart_id)
		if params[:cart_id]!=nil
			@cart = Cart.find_by(id:params[:cart_id].to_i)
		end
		@cart_items = CartItem.where(cart_id:@cart.id);
		@cart_total_qty=0
		@cart_total_price=0
		@items = Array.new(@cart_items.size)
		for i in 0..@cart_items.size-1
			@items[i] = Item.find_by(id:@cart_items[i].item_id)
			@cart_total_qty+=@cart_items[i].item_qty
			@cart_total_price+=(@items[i].unit_price*@cart_items[i].item_qty)
		end
		if @cart.id!=current_user.cart_id
			@cart_total_price=@cart.total_price
		end		
		render 'app/views/home/cart.html.erb'
	end

	def item
		if current_user != nil
			reloadVariables
		end
		item_id=params[:id]
		@item = Item.find_by(id:item_id)
		render 'app/views/home/item.html.erb'
	end

	def catalog
		if current_user != nil
			reloadVariables
		else
			@all_items = Item.all
		end

		render 'app/views/home/catalog.html.erb'
	end

	def addtocart
		item_id=params[:item_id].to_i
		item_qty=params[:item_qty].to_i
		
		additem(item_id, item_qty)		
	end

	def adjustorder
		item_qty = params[:item_qty].to_i
		cart_item = CartItem.find_by(id:params[:cart_item_id])
		if item_qty < cart_item.item_qty
			removeitem(cart_item.id, cart_item.item_qty-item_qty)
		elsif item_qty > cart_item.item_qty
			additem(cart_item.item_id, item_qty-cart_item.item_qty)
		else
			redirect_to :back
		end
	end

	def removefromcart
		cart_item_id = params[:cart_item_id].to_i
		item_qty = params[:item_qty].to_i
		
		removeitem( cart_item_id, item_qty )
	end

	def checkoutcart
		if params[:payment] != 'A'
			redirect_to '/cart', alert:"Please give Char an A..." and return
		end

		cart_items = CartItem.where(cart_id:current_user.cart_id)
		items = Array.new(cart_items.size)
		total_price = 0
		for i in 0..cart_items.size-1
			items[i] = Item.find_by(id:cart_items[i].item_id)
			items[i].update(qty_sold:items[i].qty_sold+cart_items[i].item_qty)
			cart_items[i].update(item_unit_price:items[i].unit_price)
			total_price += (items[i].unit_price*cart_items[i].item_qty)
		end	
		
		Cart.find_by(id:current_user.cart_id).update(checkout_date:Time.now.getutc, total_price:total_price)
		current_user.update(cart_id:Cart.create(user_id:current_user.id).id)
			
		redirect_to :back # render 'app/views/home/index.html.erb' # render :index
	end

	def clearcart
		cart_items = CartItem.where(cart_id:current_user.cart_id)
		if cart_items == nil || cart_items.size < 1
			redirect_to :back, alert: "Cart is already empty." and return
		end		

		cart_items.each do |c|
			item = Item.find_by(id:c.item_id)
			item.update(qty:item.qty+c.item_qty)
			c.destroy		
		end
		
		redirect_to :back
	end

private

	def additem( item_id, item_qty )
		item = Item.find_by(id:item_id)
		if item.qty < item_qty
			redirect_to :back, alert: "Item out of stock." and return
		end
		item.update(qty:item.qty-item_qty)
		
		cart_item = CartItem.find_by(cart_id:current_user.cart_id, item_id:item_id)
		if cart_item==nil
			cart_item = CartItem.create(cart_id:current_user.cart_id, item_id:item_id, item_qty:0) 
		end
		cart_item.update(item_qty:cart_item.item_qty+item_qty)	
		
		redirect_to :back # render 'app/views/home/index.html.erb' # render :index
	end

	def removeitem( cart_item_id, item_qty )
		cart_item = CartItem.find_by(id:cart_item_id)
		if cart_item.item_qty < item_qty
			redirect_to :back, alert: "Cart doesn't contain item(s)." and return
		end

		cart_item.update(item_qty:cart_item.item_qty-item_qty) 

		item = Item.find_by(id:cart_item.item_id)
		item.update(qty:item.qty+item_qty)
		
		if cart_item.item_qty<=0
			cart_item.destroy
		end
		
		redirect_to :back # render 'app/views/home/index.html.erb' # render :index
	end

	def reloadVariables
		# get checkout details of all_items
		@top_items = Item.order(qty_sold: :desc).where("qty>0").limit(10)
		@all_items = Item.all

		@current_cart_items = CartItem.where(cart_id:current_user.cart_id)
		@current_items = Array.new(@current_cart_items.size)
		@current_total_price = 0
		@current_total_qty = 0
		for i in 0..@current_cart_items.size-1
			@current_items[i]=Item.find_by(id:@current_cart_items[i].item_id)
			@current_total_price+=(@current_cart_items[i].item_qty)*(@current_items[i].unit_price)
			@current_total_qty+=@current_cart_items[i].item_qty
		end
		
		@past_carts = Cart.where(user_id:current_user.id).where.not(id:current_user.cart_id)
		@past_cart_items = Array.new(@past_carts.size)
		@past_items = Array.new(@past_carts.size)
		for i in 0..@past_carts.size-1
			@past_cart_items[i] = CartItem.where(cart_id:@past_carts[i].id)
			@past_items[i]=Array.new(@past_cart_items[i].size)
			for j in 0..@past_cart_items[i].size-1
				@past_items[i][j]=Item.find_by(id:@past_cart_items[i][j].item_id)
			end
		end
	end
	
end
