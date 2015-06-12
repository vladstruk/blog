class Article < ActiveRecord::Base

  belongs_to :user
  has_many :comments

  validates :title, presence: true
  validates :content, presence: true

  def self.order_by params
	sql = sanitize_sql_array(["%s %s", params[:field], params[:direction]])
  	Article.order(sql)
  end

  def self.search_by params
  	articles = Article.all if params[:title].present? || params[:content].present?
  	articles = articles.where("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
  	articles = articles.where("content LIKE ?", "%#{params[:content]}%") if params[:content].present?
  	articles
  end

end
