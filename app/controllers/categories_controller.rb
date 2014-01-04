class CategoriesController < ApplicationController
	load_and_authorize_resource

	def index
		@categories = Category.order('display_order').paginate(:page => params[:page], :per_page => @per_page)
		@sortable_url = sort_categories_url
		@index = @categories
		@category = Category.new
		@span = 6
		@is_table = true
	end
	
	def create
		if params[:commit] != 'Cancel'
			@category = Category.new(params[:category])
			order = (params[:category][:display_order]).to_i
			@category.reorder(order)
			if @category.save
				flash[:success] = "Category added"
				redirect_to categories_path
			end
		else
			redirect_to categories_path
		end
	end

  def edit
		@is_edit_form = true
	end
	
	def update
		@is_edit_form = true
		if params[:commit] != 'Cancel'
			@category = Category.find(params[:id])
			order = (params[:category][:display_order]).to_i
			@category.reorder(order)
			if @category.update_attributes(params[:category])
				flash[:success] = "Category updated"
				redirect_to categories_path				
			else
				render :action => :edit
			end
		else
			redirect_to categories_path
		end		
	end

	def destroy
		if Category.find(params[:id]).destroy		
			flash[:success] = 'Category deleted'
			redirect_to categories_path
		end
	end

	def sort
		params[:category].each_with_index do |id, index|
			Category.update_all({display_order: index + 1}, {id: id})
		end
		render nothing: true
	end

end
