require "test_helper"

class ImageUploadTest < ActiveSupport::TestCase
  test "is valid with a supported image" do
    image_upload = ImageUpload.new(title: "Spawn")
    attach_test_image(image_upload)

    assert image_upload.valid?
  end

  test "requires a file" do
    image_upload = ImageUpload.new(title: "No file")

    assert_not image_upload.valid?
    assert_includes image_upload.errors[:file], "can't be blank"
  end

  test "rejects unsupported file types" do
    image_upload = ImageUpload.new(title: "Text")
    image_upload.file.attach(
      io: StringIO.new("not an image"),
      filename: "notes.txt",
      content_type: "text/plain"
    )

    assert_not image_upload.valid?
    assert_includes image_upload.errors[:file], "debe ser JPG, PNG, GIF o WebP"
  end

  test "rejects files over the size limit" do
    image_upload = ImageUpload.new(title: "Huge")
    image_upload.file.attach(
      io: StringIO.new("a" * (ImageUpload::MAX_FILE_SIZE + 1)),
      filename: "huge.png",
      content_type: "image/png"
    )

    assert_not image_upload.valid?
    assert_includes image_upload.errors[:file], "debe pesar como maximo 10 MB"
  end
end
