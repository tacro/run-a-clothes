class ItemImageUploader < CarrierWave::Uploader::Base
    # Include RMagick or MiniMagick support:
    # if Rails.env.production?
    #   include Cloudinary::CarrierWave
    # end
     include CarrierWave::RMagick
     include CarrierWave::MiniMagick


    process :convert => 'jpg'

    version :standard do
       process :crop
       process :resize_and_pad=> [570, 852, background = :transparent, gravity = Magick::CenterGravity]
       #process :resize_to_fill=> [570, 852, background = :transparent, gravity = ::Magick::CenterGravity]
    end
    # Choose what kind of storage to use for this uploader:
    if Rails.env.development?
      storage :file
    elsif Rails.env.test?
      storage :file
    else
     storage :fog
    end

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
       "post_images/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Create different versions of your uploaded files:
    version :thumb do
      process :crop
      #process :resize_to_limit => [380, 568]
      #process :resize_and_pad=>[380, 568, background = :transparent, gravity = ::Magick::CenterGravity]
      process :resize_to_fill=>[380, 568, gravity = Magick::CenterGravity]
    end

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
     def extension_whitelist
       %w(jpg jpeg gif png)
     end

     def crop
       return if [model.image_x, model.image_y, model.image_w, model.image_h].all?
       manipulate! do |img|
        crop_x = model.image_x.to_i
        crop_y = model.image_y.to_i
        crop_w = model.image_w.to_i
        crop_h = model.image_h.to_i
        img.crop "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"
        img = yield(img) if block_given?
        img
      end
     end

    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    def filename
     "#{secure_token}.jpg" if original_filename.present?
    end

   protected
   def secure_token
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
   end
  end
