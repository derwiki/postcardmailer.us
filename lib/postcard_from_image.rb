require_relative './net_util'
require 'tempfile'
require_relative './s3'
require_relative './create_postcard'

class PostcardFromImage
  attr_accessor :url, :dryrun

  def initialize(url, dryrun: true)
    self.url = url
    self.dryrun = dryrun
  end

  def run
    original_image_file = NetUtil.save_to_tempfile(url)
    puts %x[file #{original_image_file.path}]

    converted_image = {}
    converted_image[:file] = Tempfile.new(["insta-converted-#{Time.now.to_i}", '.jpg'])
    %x[convert #{original_image_file.path} -resize 1875x1350 -gravity center -extent 1875x1350 #{converted_image[:file].path}]

    converted_image[:s3] = AWSS3.upload(File.basename(converted_image[:file].path), converted_image[:file])
    converted_image[:url] = converted_image[:s3].public_url

    create_postcard = CreatePostcard.new(
      { name: 'Adam Derewecki', address1: '960 Wisconsin St', city: 'San Francisco', state: 'CA', zip: '94107' },
      converted_image[:url],
      converted_image[:url],
      dryrun: self.dryrun
    )
    p create_postcard.template
    create_postcard.run.tap do
      original_image_file.unlink
      converted_image[:file].unlink
      #TODO delete from S3
    end
  end
end
