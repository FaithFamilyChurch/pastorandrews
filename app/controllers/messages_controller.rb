class MessagesController < ApplicationController

    require 'net/http'
    require 'uri'
    require 'logger'
    require 'mailchimp'

    def index
        #GET https://content.googleapis.com/youtube/v3/playlistItems?playlistId=PLxCb4nfrSan_nmC3XZSjLiQ2qSpc6olnC&maxResults=4&part=id%2Csnippet%2CcontentDetails&key=AIzaSyAMkHWnLNAvpKte-XA9nh3RheX7lFn_dNM

        @aVideos = []
        @mc      = Mailchimp.where(service: "youtube").first

        sUrl = @mc.service_url
        sKey = @mc.apikey

        nMaxVids    = 4
        nMaxResults = 10 # pull down 10 videos in case a few are private or not available

        aReqData  = {
            "part"       => "id%2Csnippet%2CcontentDetails",
            "playlistId" => "PLxCb4nfrSan_nmC3XZSjLiQ2qSpc6olnC",
            "maxResults" => nMaxResults,
            "key"        => sKey
        }

        sRequestUrl = "#{sUrl}?playlistId=#{aReqData['playlistId']}&maxResults=#{aReqData['maxResults']}&part=#{aReqData['part']}&key=#{sKey}"
        oUri         = URI(sRequestUrl)
        oRequest     = Net::HTTP::Get.new(oUri)
        aReqOptions = {
            use_ssl: oUri.scheme == "https",
        }

        logger.tagged("MAILCHIMP") { logger.debug "Sending request to Youtube server..." }
        oResponse = Net::HTTP.start(oUri.hostname, oUri.port, aReqOptions) do |oHttp|
            oHttp.request(oRequest)
        end

        if oResponse.code.to_i == 200
            logger.tagged("MAILCHIMP") { logger.debug "Request received successfully - building hash response..." }

            aRespJSON = JSON.parse(oResponse.body)
            aItems    = aRespJSON['items']

            aItems.each do |aItem|
                if aItem['snippet']['thumbnails'].present?
                    @aVideos.push(aItem['snippet'])
                end
            end

            if @aVideos.size > 4
                @aVideos = @aVideos[0..3]
            end
        else
            logger.tagged("MAILCHIMP") { logger.debug "Request failed with status code #{oResponse.code}, Error: #{oResponse.body}" }
        end
    end

end
