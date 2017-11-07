class PagesController < ApplicationController

	def index
	end

    def requestNewSubscription

        email = params[:subscribe_email]
        fname = params[:subscribe_fname]
        lname = params[:subscribe_lname]

#  		logger.debug "\n\n\n\n\n\n\nPARAMS ARE: #{params.inspect}\n\n\n\n\n\n\n"
  		logger.debug "\n\n\n\n\n\n\nPARAMS ARE:\n"
        logger.debug "EMAIL - #{email}"
        logger.debug "FNAME - #{fname}"
        logger.debug "LNAME - #{lname}"
  		logger.debug "\n\n\n\n\n\n\n"

		response = {}
		content  = {}
		status   = ""
		message  = ""

		begin
            #result = MailChimp.addNewEmailAddress(fname, lname, email)


			response['status'] = "success"
			response['message'] = ""
			response['content'] = content
		rescue => error
			response['status'] = "failure"
			response['message'] = "Error: #{error.message}"
			response['content'] = error.backtrace
		ensure
			respond_to do |format|
				format.html { render :json => response.to_json }
			end
		end
    end

end
