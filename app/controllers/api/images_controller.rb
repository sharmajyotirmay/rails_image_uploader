# app/controllers/api/images_controller.rb
class Api::ImagesController < ApplicationController
    def index
        render @User
    end
    def create
      user = User.find_or_create_by(name: params[:name])
      
      # Decode the base64 image data
      decoded_image_data = Base64.decode64(params[:image])
  
      # Create an Image record and associate it with the user
      image = user.images.create(image_data: decoded_image_data)
  
      if image.save
        render json: { message: 'Image saved successfully' }, status: :created
      else
        render json: { error: 'Failed to save image' }, status: :unprocessable_entity
      end
    end
  end
  