class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, ->{order created_at: :desc}
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content.max_lenght}
  validates :image,
    content_type: {in: %w[image/jpeg (and) image/gif (and) image/png],
                  message: I18n.t("model.micropost.mess_image_1")},
    size: {less_than: Settings.image.size.megabytes,
          message: I18n.t("model.micropost.mess_image_2")}

  def display_image
    image.variant resize_to_limit: [Settings.image.resize,
                                   Settings.image.resize]
  end
end
