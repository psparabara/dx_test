# encoding: utf-8

class PostVideoUploader < CarrierWave::Uploader::Base
  include UploaderHelper
  after :remove, :delete_empty_upstream_dirs
  
  storage :file

  def store_dir
    File.join(Rails.root, 'app/assets/videos', model.id.to_s)
  end

  def extension_white_list
    %w(mp4 ogv webm m4v)
  end
end
