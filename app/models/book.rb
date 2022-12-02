class Book < ApplicationRecord
  belongs_to :user

  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  #has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  has_many :view_counts, dependent: :destroy
  has_many :bookmarks, dependent: :destroy #ブックマーク機能

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

  def bookmarked_by?(user)
    bookmarks.where(user_id: user).exists?
  end
  #bookmarked_by?(user)を追加することで既にブックマークしているかを検証

end
