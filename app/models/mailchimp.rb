class Mailchimp < ApplicationRecord

    require 'net/http'
	require 'uri'
	require 'logger'

    def self.getCurrentList
        begin
			result = {}
			logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

			logger.tagged("MAILCHIMP") { logger.debug "Fetching url and api key..." }
            @mc = Mailchimp.where(service: "mailchimp").first
            url = @mc.service_url
            key = @mc.apikey

			if url == "" or key == ""
				raise "Invalid parameters set for Mailchimp object - please check value of Key and Url"
			end

			logger.tagged("MAILCHIMP") { logger.debug "Building request to Mailchimp server..." }

            uri = URI.parse(url)
            request = Net::HTTP::Get.new("#{uri}lists")
            request.basic_auth("ffcpastor", key)

            req_options = {
                use_ssl: uri.scheme == "https",
            }

			logger.tagged("MAILCHIMP") { logger.debug "Sending request to Mailchimp server..." }
            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end

			if response.code.to_i == 200
				logger.tagged("MAILCHIMP") { logger.debug "Request received successfully - building hash response..." }
				respjson = JSON.parse(response.body)
				headinfo = JSON.parse(response.to_json)

				result['status']    = "success"
				result['code']      = response.code.to_i
                result['content']   = respjson
                result['headers']   = headinfo
			else
				logger.tagged("MAILCHIMP") { logger.debug "Request failed with status code #{response.code}, Error: #{response.body}" }
				raise "Error making request: STATUS CODE #{response.code}, ERROR: #{response.body}"
			end
		rescue => error
			result['status']  = "failure"
			result['message'] = "Error: #{error.message}"
			result['content'] = error.backtrace
		ensure
			return result
		end
    end


    def self.addNewEmailAddress
    end

end
