require 'rest_client'
require 'json'

DIRECT_MAIL_KEY = "OTc3YTJmYzQtNTIyMy00MWIxLTk0YmMtMzllYjg5ZGY1MGYwOmI5OTY5ZmYzLWE3YWUtNGIxOC1hMjZkLWFmMzk2ZGU0ZWJhMA=="

# convert instagram.jpg -resize 1875x1350 instagram_1875x1350.jpg
# convert sqinstagram.jpg -resize 1875x1350 -gravity center -extent 1875x1350 sqinstagram_1875x1350.jpg
class CreatePostcard
  attr_accessor :recipient, :front, :back, :dryrun

  def initialize(recipient, front, back, dryrun: false)
    self.recipient = recipient
    self.front = front
    self.back = back
    self.dryrun = dryrun
  end

  def run
    RestClient.post(
      'https://print.directmailers.com/api/v1/postcard/',
      JSON.generate(self.template),
      self.headers
    ).tap do |response|
      p response
      puts response
    end
  end

  def headers
    {
      :content_type => 'application/json',
      :authorization => "Basic #{DIRECT_MAIL_KEY}"
    }
  end

  def template
    {
      "Description" => "#{Time.now} #{recipient[:name] }",
      "Size" => "4.25x6",
      "DryRun" => self.dryrun,
      "WaitForRender" => true,
      "To" => {
        "Name" => recipient[:name],
        "AddressLine1" => recipient[:address1],
        "AddressLine2" => recipient[:address2],
        "City" => recipient[:city],
        "State" => recipient[:state],
        "Zip" => recipient[:zip]
      },
      "From" => {
        "Name" => "Adam Derewecki",
        "AddressLine1" => "960 Wisconsin St",
        "City" => "San Francisco",
        "State" => "CA",
        "Zip" => "94107"
      },
      "Front" => "#{self.front}",
      "Back" => "#{self.back}",
    }
  end
end
