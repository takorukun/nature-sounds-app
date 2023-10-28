module VideosHelper
  def youtube_thumbnail(video_id, options = {})
    require 'google/apis/youtube_v3'

    options = { show_info: true }.merge(options)

    Rails.cache.fetch("youtube_thumbnail_#{video_id}", expires_in: 1.day) do
      service = Google::Apis::YoutubeV3::YouTubeService.new
      service.key = ENV['YOUTUBE_API_KEY']

      video_item = nil
      begin
          video_response = service.list_videos('snippet,statistics', id: video_id)
          video_item = video_response.items.first
          Rails.logger.debug "Video Item: #{video_item.inspect}"
      rescue Google::Apis::ServerError
        return tag.div("Video not found", class: 'text-center')
        end

      if video_item
        title = video_item.snippet.title
        view_count = video_item.statistics&.view_count || 'N/A'
        begin
          parsed_date = Date.parse(video_item.snippet.published_at)
          upload_date = parsed_date.strftime('%Y/%m/%d')
        rescue
          upload_date = 'N/A'
        end
        width = options.fetch(:width, 308)
        height = options.fetch(:height, 160)

        rubocop:disable Layout/SpaceInsideParens
        content = tag.div(class: 'text-zinc-400 flex flex-col items-center space-y-4') do
          tag.iframe('', class: 'rounded-lg shadow', width: width, height: height,
                          src: "https://www.youtube.com/embed/#{video_id}",
                          frameborder: 0,
                          allowfullscreen: true) +
          rubocop:enable Layout/SpaceInsideParens
          if options[:show_info]
            tag.div(class: 'text-center') do
              tag.p do
                tag.span(title, class: 'block font-bold mb-2') +
                tag.span("#{number_with_delimiter(view_count)} views ") +
                tag.span(upload_date, class: 'text-sm text-gray-500')
              end
            end
          end
        end

        content
      else
        tag.div("Video not found", class: 'text-center')
      end
    end
  end
end
