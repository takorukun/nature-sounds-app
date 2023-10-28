require 'google/apis/youtube_v3'

class YoutubeService
  def self.extract_youtube_video_id(link)
    return nil if link.nil?

    uri = URI(link)

    unless ['youtu.be', 'www.youtube.com'].include?(uri.host)
      return nil
    end

    if uri.host == 'youtu.be'
      return uri.path[1..-1]
    end

    if uri.query
      query = URI.decode_www_form(uri.query)
      query_hash = Hash[query]
      return query_hash["v"]
    end

    nil
  end
end
