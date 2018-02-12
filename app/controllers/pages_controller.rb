class PagesController < ApplicationController
    #layout "splashpage"
    require 'nokogiri'

	def index
        @aBlogList = execute_statement("select * from pastorblog_dev.contents order by published_at desc limit 4;")
        @aArticles = []

        @sDomain = "http://ffcpastor.com/"

        @bShowRecent = false

        sRecentTime = @aBlogList.first[18].to_s
        oRecent = Time.parse(sRecentTime)
        oCrrnt = Time.new
        oTDiff = (((oCrrnt - oRecent) / 24) / 3600)
        nTDiff = '%.0f' % oTDiff

        if oTDiff < 5
            @bShowRecent = true
        end

        for aBlog in @aBlogList do
            @aTmp = {}
            oContent = Nokogiri::HTML.fragment(aBlog[4])
            oPTag = oContent.search('p')
            oImg = oContent.search('img')
            sImg = ""
            sTxt = ""

            if oPTag.first.search('img').size > 0
                sTxt = oPTag[1].inner_html
            else
                sTxt = oPTag.first.inner_html
            end

            aRgx = sTxt.split(/(?<=[?.!])/)
            sTxt = "#{aRgx[0]}#{aRgx[1][0]}"

            if oImg.size > 0
                eImg = oImg.first
                sImgSrc = eImg['src']
                nImgId = 0

                if sImgSrc != ""
                    aImgSrc = sImgSrc.split("/")
                    nImgId = aImgSrc[aImgSrc.size - 2]
                end

                sImgName = eImg['data-imagename']
#                logger.debug "IMAGENAME IS: #{eImg['data-imagename']}"
            end

            oDate = Time.parse(aBlog[18].to_s)
            sMonth = '%02d' % oDate.month
            sDay = '%02d' % oDate.day
            sLink = "blog/#{oDate.year}/#{sMonth}/#{sDay}/#{aBlog[10]}"

            @aTmp['link']  = sLink
            @aTmp['title'] = aBlog[2]
            @aTmp['date']  = aBlog[18].strftime("%^b %-d, %Y")
            @aTmp['text']  = sTxt
            @aTmp['image_src']  = sImgSrc
            @aTmp['image_name'] = sImgName
            @aTmp['image_id']   = nImgId

            @aArticles.push @aTmp
        end

	end

    def requestNewSubscription
#        require 'mailchimp'

        email = params[:subscribe_email]
        fname = params[:subscribe_fname]
        lname = params[:subscribe_lname]

#  		logger.debug "\n\n\n\n\n\n\nPARAMS ARE:\n"
#        logger.debug "EMAIL - #{email}"
#        logger.debug "FNAME - #{fname}"
#        logger.debug "LNAME - #{lname}"
#  		logger.debug "\n\n\n\n\n\n\n"

		response = {}
		content  = {}
		status   = ""
		message  = ""

		begin
            result = Mailchimp.addNewEmailAddress(fname, lname, email)
            response['status'] = "success"
            response['message'] = "request submitted successfully"
            response['content'] = result
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
