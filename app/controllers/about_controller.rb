class AboutController < ApplicationController
    def index
        @nNumYears = getTimeDifference()
    end

    def getTimeDifference
        require 'time'
        oStart = Time.parse('2002-03-31 12:00:00 -0500')
        oCrrnt = Time.new
        oTDiff  = ((((oCrrnt - oStart) / 365) / 24) / 3600)
        return '%.0f' % oTDiff
    end
end
