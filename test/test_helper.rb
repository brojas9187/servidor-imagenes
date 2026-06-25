ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "base64"
require "stringio"
require "tempfile"

module ImageUploadTestHelper
  TINY_PNG_BASE64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="

  def attach_test_image(record, filename: "tiny.png", content_type: "image/png")
    record.file.attach(
      io: StringIO.new(Base64.decode64(TINY_PNG_BASE64)),
      filename: filename,
      content_type: content_type
    )
  end

  def create_test_image_upload(title: "Spawn", filename: "tiny.png")
    image_upload = ImageUpload.new(title: title)
    attach_test_image(image_upload, filename: filename)
    image_upload.save!
    image_upload
  end

  def uploaded_test_image(filename: "tiny.png")
    extension = File.extname(filename).presence || ".png"
    tempfile = Tempfile.new([ "upload", extension ])
    tempfile.binmode
    tempfile.write(Base64.decode64(TINY_PNG_BASE64))
    tempfile.rewind

    uploaded_test_files << tempfile
    Rack::Test::UploadedFile.new(tempfile.path, "image/png", true, original_filename: filename)
  end

  def after_teardown
    uploaded_test_files.each(&:close!)
    super
  end

  private

  def uploaded_test_files
    @uploaded_test_files ||= []
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include ImageUploadTestHelper
  end
end
