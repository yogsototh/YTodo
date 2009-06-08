#!/usr/bin/env ruby

# -- pour la lecture de la date à partir du language naturel
require 'rubygems'
require 'chronic'
require 'time'

class TaskTime
    @created        # creation date of the task
    @started        # date at with the task began (hour,minute,second)
    @done           # date at which the task was done
    @due            # due date for the task
    @duration       # time spend for finish that task
                    # can be set by the user to be
                    # different than (@done - @started)
    @max_duration   # maximal duration for that task
    @min_duration   # minimal duration for that task

    # -- Expressions regulières --
    # Regular Expressions for that class
    @@StdTokenRegExp=Regexp.new(%{(\\w+|"[^"]*")})
    # Notes
    @@TimeShort=Regexp.new(%{#(#{@@StdTokenRegExp.inspect[1..-2]}(,|->))?#{@@StdTokenRegExp.inspect[1..-2]}})
    @@TimeVerbose=Regexp.new(%{ (created|done|due|duration|max_duration|min_duration):#{@@StdTokenRegExp.inspect[1..-2]}} )
    @@Time=Regexp.union(@@TimeShort,@@TimeVerbose)

    def to_s
        res=%{created:"#{@created}"}
        if ( @started )     : res<<=%{,started:"#{@started}"}       end
        if ( @done )        : res<<=%{,done:"#{@done}"}             end
        if ( @due )         : res<<=%{,due:"#{@due}"}               end
        if ( @duration )    : res<<=%{,duration:"#{@duration}"}     end
        if ( @max_duration ): res<<=%{,max_duration:"#{@duration}"} end
        if ( @min_duration ): res<<=%{,min_duration:"#{@duration}"} end
        return res
    end

    def to_detailled_s
        res=%{     created:#{@created}}
        if ( @started )     : res<<="\n"+%{     started: #{@started}}  end
        if ( @done )        : res<<="\n"+%{        done: #{@done}}     end
        if ( @due )         : res<<="\n"+%{         due: #{@due}}      end
        if ( @duration )    : res<<="\n"+%{    duration: #{@duration}} end
        if ( @max_duration ): res<<="\n"+%{max_duration: #{@duration}} end
        if ( @min_duration ): res<<="\n"+%{min_duration: #{@duration}} end
        return res
    end

    def from_s( raw_input )
        scanned_input=raw_input.scan( @@TimeShort )
        str_of_start_date = scanned_input.map{ |x| x[3] }
        @due       = Chronic.parse(str_of_start_date)
        str_of_due = scanned_input.map{ |x| x[1] }
        @started     = Chronic.parse(str_of_due)
        raw_input.scan( @@TimeVerbose ).each do |x| 
            timeValue=Chronic.parse(x[1])
            if timeValue==nil: 
                timeValue=Time.parse(x[1])
            end
            eval %{@#{x[0]}=timeValue} 
        end

    end

    def initialize ( raw_input=nil )
        @created=Time.now
        @started      = nil
        @done         = nil
        @due          = nil
        @duration     = nil
        @max_duration = nil 
        @min_duration = nil 
        if raw_input:
            from_s raw_input
        end
    end

    def regexp
        return @@Time
    end
end
