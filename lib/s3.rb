require 'aws-sdk-s3'

class AWSS3
  def self.upload(key, image_file)
    s3 = Aws::S3::Resource.new
    s3.bucket('postcardmailer.us').object(key).tap do |obj|
      if obj.upload_file(image_file, acl: 'public-read')
        puts "Wrote: #{obj.public_url}"
      end
    end
  end
end
