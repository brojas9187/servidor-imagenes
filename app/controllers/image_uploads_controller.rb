class ImageUploadsController < ApplicationController
  before_action :set_image_upload, only: %i[show file]

  def index
    @image_upload = ImageUpload.new
    @image_uploads = image_upload_scope
  end

  def show
  end

  def create
    @image_upload = ImageUpload.new(image_upload_params)

    if @image_upload.save
      redirect_to @image_upload, notice: "Imagen subida. El enlace ya esta listo para usar."
    else
      @image_uploads = image_upload_scope
      render :index, status: :unprocessable_entity
    end
  end

  def file
    expires_in 1.year, public: true

    send_data @image_upload.file.download,
      filename: @image_upload.file.filename.to_s,
      type: @image_upload.file.content_type,
      disposition: "inline"
  end

  private

  def image_upload_params
    params.require(:image_upload).permit(:title, :file)
  end

  def set_image_upload
    @image_upload = ImageUpload.with_attached_file.find(params[:id])
  end

  def image_upload_scope
    ImageUpload.with_attached_file.order(created_at: :desc)
  end
end
