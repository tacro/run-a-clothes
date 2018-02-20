class ItemImageUploader < CarrierWave::Uploader::Base
    # Include RMagick or MiniMagick support:
    if Rails.env.production?
      include Cloudinary::CarrierWave
    end
     include CarrierWave::RMagick
    # include CarrierWave::MiniMagick


    process :convert => 'jpg'
    if Rails.env.production?
      process :tags => ['image_name']
    end

    version :standard do
       process :resize_and_pad=> [570, 852, background = :transparent, gravity = Magick::CenterGravity]
       #process :resize_to_fill=> [570, 852, background = :transparent, gravity = ::Magick::CenterGravity]
    end
    # Choose what kind of storage to use for this uploader:
    storage :file
    # storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
       "post_images/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    # def default_url(*args)
    #   # For Rails 3.1+ asset pipeline compatibility:
    #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    #
    #
    # end

    # Process files as they are uploaded:
    # process scale: [200, 300]
    #
    # def scale(width, height)
    #   # do something
    # end

    # Create different versions of your uploaded files:
    version :thumb do
      #process :resize_to_limit => [380, 568]
      #process :resize_and_pad=>[380, 568, background = :transparent, gravity = ::Magick::CenterGravity]
      process :resize_to_fill=>[380, 568, gravity =  Magick::CenterGravity]
    end

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
     def extension_whitelist
       %w(jpg jpeg gif png)
     end

    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    def filename
     "#{secure_token}.jpg" if original_filename.present?
    end

    if Rails.env.production?
     def public_id
      return model.id
     end
    end

   protected
   def secure_token
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
   end
  end
