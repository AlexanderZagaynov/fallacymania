module Paperclip

  interpolates :placeholder do |attachment, style|
    asset_name = attachment.instance.class.name.underscore
    asset_name.insert asset_name.rindex('/').to_i, 'default_'
    asset_name << "_#{style}_#{attachment.name}"
    ActionController::Base.helpers.image_path("#{asset_name}.png")
  end

  class Attachment

    def cleanup_filename filename
      return filename_cleaner.call(filename) if @options[:filename_cleaner]
      mime = MIME::Types[@file.content_type.to_s.strip].first
      ext = mime.try(:extensions).try(:first) || File.extname(filename)
      ext = ".#{ext}" if ext.present? && ext.first != '.'
      "#{SecureRandom.hex}#{ext}"
    end

    default_options.merge! default_url: ':placeholder'

  end
end
