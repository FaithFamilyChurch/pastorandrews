class Mailchimp < ApplicationRecord

    has_many :mailchimp_lists

    require 'net/http'
    require 'uri'
    require 'logger'


    def self.addNewEmailAddress(name, email)
        begin
			result = {}
			logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

			logger.tagged("MAILCHIMP") { logger.debug "Fetching url and api key..." }
            @mc = Mailchimp.where(service: "mailchimp").first

            mcl = @mc.mailchimp_lists.first
            url = @mc.service_url
            key = @mc.apikey

			if url == "" or key == ""
				raise "Invalid parameters set for Mailchimp object - please check value of Key and Url"
			end

            logger.tagged("MAILCHIMP") { logger.debug "Checking for variables..." }

            if name.strip == ""
                raise "The subscriber name is required to be added to the email list"
            end

            if email.strip == ""
                raise "The subscriber email is required to be added to the email list"
            end

			logger.tagged("MAILCHIMP") { logger.debug "Building request to Mailchimp server..." }

            uri = URI.parse(url)

            request = Net::HTTP::Post.new("#{uri}lists/#{mcl.list_id}/members")
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


    def self.getCurrentListSubscribers
        begin
			result = {}
			logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

			logger.tagged("MAILCHIMP") { logger.debug "Sending GET request to Mailchimp server..." }

            result = Mailchimp.sendMailchimpListRequest("GET", "members")

        rescue => error
			result['status']  = "failure"
			result['message'] = "Error: #{error.message}"
			result['content'] = error.backtrace
        ensure
			return result
        end
    end

    def self.getCurrentList
        begin
			result = {}
			logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

			logger.tagged("MAILCHIMP") { logger.debug "Fetching url and api key..." }
            @mc = Mailchimp.where(service: "mailchimp").first

            mcl = @mc.mailchimp_lists.first
            url = @mc.service_url
            key = @mc.apikey

			if url == "" or key == ""
				raise "Invalid parameters set for Mailchimp object - please check value of Key and Url"
			end

			logger.tagged("MAILCHIMP") { logger.debug "Building request to Mailchimp server..." }

            uri = URI.parse(url)

            request = Net::HTTP::Get.new("#{uri}lists/#{mcl.list_id}")
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


    def self.sendMailchimpListRequest(request_type, request_path, data={})
        begin
            result = {}
            allowed_requests = ["GET", "POST", "PATCH", "PUT", "DELETE"]

			logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

            if request_type.strip == ""
                raise "Request type required to send list request"
            end

            if !allowed_requests.include? request_type
                raise "Request type #{request_type} is not allowed"
            end

			logger.tagged("MAILCHIMP") { logger.debug "Fetching url and api key..." }
            @mc = Mailchimp.where(service: "mailchimp").first

            mcl = @mc.mailchimp_lists.first
            url = @mc.service_url
            key = @mc.apikey

			if url == "" or key == ""
				raise "Invalid parameters set for Mailchimp object - please check value of Key and Url"
			end

			logger.tagged("MAILCHIMP") { logger.debug "Building request to Mailchimp server..." }

            uri = URI.parse(url)

            request_url = "#{uri}lists/#{mcl.list_id}"
            if request_path.strip != ""
                request_url = request_url + "/#{request_path}"
            end

            request = case request_type.upcase
                when "GET" then Net::HTTP::Get.new(request_url)
                when "PUT" then Net::HTTP::Put.new(request_url)
                when "POST" then Net::HTTP::Post.new(request_url)
                when "PATCH" then Net::HTTP::Patch.new(request_url)
                when "DELETE" then Net::HTTP::Delete.new(request_url)
                else "Invalid Request Type"
            end

            request.basic_auth("ffcpastor", key)

            if data.size > 0
                request.content_type = "application/json"
                request.body = JSON.dump(data)
            end

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
            return response
        end
    end

end
