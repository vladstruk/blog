class ArticlesController < ApplicationController
	
    load_resource only: [:show, :edit, :update, :destroy]
    authorize_resource only: [:edit, :update, :destroy]

	def index
	  @article = Article.new
      @articles = Article.order_by(params)
	end

	def create
	  @article = Article.new(articles_params)
	  @article.user_id = current_user.id
	  if @article.save
	  	flash[:notice] = "New article added."
	  	redirect_to articles_path
	  else
	  	flash[:error] = "None of article fields can be blank!"
	  	render :index
	  end
	end

	def show
	  @comment = Comment.new
	end

	def update
	  if @article.update_attributes(articles_params)
	  	flash[:notice] = "Article #{@article.title} has been just edited."
	  	redirect_to articles_path
	  else
	  	flash[:error] = "None of article fields can be blank!"
	  	render :edit
	  end
	end

	def destroy
       @article.destroy
       flash[:notice] = "Article #{@article.title} has been just deleted."
       redirect_to articles_path
	end


	private

	def articles_params
	  params.require(:article).permit(:title, :content, :user_id)
	end

end
