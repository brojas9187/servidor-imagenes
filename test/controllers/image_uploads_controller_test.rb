require "test_helper"

class ImageUploadsControllerTest < ActionDispatch::IntegrationTest
  test "renders the upload page" do
    get root_url

    assert_response :success
    assert_select "form[action='#{image_uploads_path}']"
    assert_select "input[type=file][name='image_upload[file]']"
  end

  test "creates an image upload" do
    assert_difference("ImageUpload.count", 1) do
      post image_uploads_url, params: {
        image_upload: {
          title: "Spawn map",
          file: uploaded_test_image(filename: "spawn.png")
        }
      }
    end

    image_upload = ImageUpload.last
    assert_redirected_to image_upload_url(image_upload)

    follow_redirect!
    assert_response :success
    assert_includes response.body, image_upload_file_url(image_upload, filename: "spawn.png")
  end

  test "serves the uploaded image as an inline image" do
    image_upload = create_test_image_upload(filename: "tiny.png")

    get image_upload_file_url(image_upload, filename: "tiny.png")

    assert_response :success
    assert_equal "image/png", response.media_type
    assert_match(/inline/, response.headers["Content-Disposition"])
  end
end
