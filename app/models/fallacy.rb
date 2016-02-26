class Fallacy < ActiveRecord::Base
  extend FriendlyId
  include Randomizable

  translates :name, :description, :example, fallbacks_for_empty_translations: true

  has_attached_file    :picture, styles: { original: '200x200>', thumbnail: '64x64' }
  validates_attachment :picture, content_type: { content_type: /\Aimage\// },
                                 size: { in: 0..10.kilobytes }

  delegate :url, to: :picture, prefix: true, allow_nil: true

  def thumbnail_url
    picture_url :thumbnail
  end
end
