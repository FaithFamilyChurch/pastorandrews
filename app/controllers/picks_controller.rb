class PicksController < ApplicationController

    def index
        @aPickList = execute_statement("select * from pastorblog_dev.picks order by created_at desc limit 5;")

        @aPicks = Array.new

        for oPick in @aPickList do

            pick = {}
            pick['id'] = oPick[0]
            pick['title'] = oPick[1]
            pick['author'] = oPick[2]
            pick['description'] = oPick[3]
            pick['picktype'] = oPick[4]
            pick['link'] = oPick[5]
            pick['score'] = oPick[6]
            pick['isbn'] = oPick[7]
            pick['publisher'] = oPick[8]
            pick['year_published'] = oPick[9]
            pick['pick_length'] = oPick[10]
            pick['created_at'] = oPick[11]
            pick['updated_at'] = oPick[12]
            pick['image_link'] = oPick[13]

            @aPicks.push(pick)
        end

        @aPicks.reverse!
#        @sDomain = "http://#{Rails.configuration.site_url}/"
    end

end
