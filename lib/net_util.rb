require 'net/http'
require 'tempfile'
require 'uri'

class NetUtil
  def self.save_to_tempfile(url)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      resp = http.get(uri.path)
      file = Tempfile.new(["insta-#{Time.now.to_i}", '.jpg'])
      file.binmode
      file.write(resp.body)
      file.flush
      file.rewind
      file
    end
  end
end
