class ImageUpload < ApplicationRecord
  MAX_FILE_SIZE = 10.megabytes
  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze

  has_one_attached :file

  validates :title, length: { maximum: 80 }, allow_blank: true
  validates :file, presence: true
  validate :file_must_be_supported_image
  validate :file_must_fit_size_limit

  def display_name
    title.presence || (file.filename.to_s if file.attached?) || "Imagen"
  end

  private

  def file_must_be_supported_image
    return unless file.attached?
    return if ALLOWED_CONTENT_TYPES.include?(file.content_type)

    errors.add(:file, "debe ser JPG, PNG, GIF o WebP")
  end

  def file_must_fit_size_limit
    return unless file.attached?
    return if file.byte_size <= MAX_FILE_SIZE

    errors.add(:file, "debe pesar como maximo 10 MB")
  end
end
