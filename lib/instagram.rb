require 'json'

class Instagram

  # returns 12 by default
  def self.feed(username)
    url = "https://www.instagram.com/#{username}/?__a=1"
    feed_json = `curl --silent #{url}`
    JSON[feed_json].dig("graphql", "user", "edge_owner_to_timeline_media", "edges").map do |edge|
      edge.dig("node", "display_url")
    end
  end
end

# puts Instagram.feed('derwiki')
