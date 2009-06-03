#!/usr/bin/env ruby

# -- pour la lecture de la date à partir du language naturel
require 'rubygems'
require 'chronic'

class TaskTime
    @creation_date  # creation date of the task
    @start_date     # date at with the task began (hour,minute,second)
    @done_date      # date at which the task was done
    @due_date       # due date for the task
    @duration       # time spend for finish that task
                    # can be set by the user to be
                    # different than (@done_date - @start_date)
    @max_duration   # maximal duration for that task
    @min_duration   # minimal duration for that task

    # -- Expressions regulières --
    # Regular Expressions for that class
    @@StdTokenRegExp=Regexp.new(%{(\\w+|"[^"]*")})
    # Notes
    @@Time=Regexp.new(%{#(#{@@StdTokenRegExp.inspect[1..-2]}(,|->))?#{@@StdTokenRegExp.inspect[1..-2]}})

    def to_s
        res=%{created:#{@creation_date}}
        if ( @start_date )  : res+=%{,started:#{@start_date}}       end
        if ( @done_date )   : res+=%{,done:#{@done_date}}           end
        if ( @due_date )    : res+=%{,due:#{@due_date}}             end
        if ( @duration )    : res+=%{,duration:#{@duration}}        end
        if ( @max_duration ): res+=%{,max_duration:#{@duration}}    end
        if ( @min_duration ): res+=%{,min_duration:#{@duration}}    end
        return res
    end

    def to_detailled_s
        res=%{     created:#{@creation_date}}
        if ( @start_date )  : res+="\n"+%{     started:#{@start_date}}    end
        if ( @done_date )   : res+="\n"+%{        done:#{@done_date}}        end
        if ( @due_date )    : res+="\n"+%{         due:#{@due_date}}          end
        if ( @duration )    : res+="\n"+%{    duration:#{@duration}}     end
        if ( @max_duration ): res+="\n"+%{max_duration:#{@duration}} end
        if ( @min_duration ): res+="\n"+%{min_duration:#{@duration}} end
        return res
    end

    def from_s( raw_input )
        scanned_input=raw_input.scan( @@Time )
        str_of_start_date = scanned_input.map{ |x| x[3] }
        @due_date       = Chronic.parse(str_of_start_date)
        str_of_due_date = scanned_input.map{ |x| x[1] }
        @start_date     = Chronic.parse(str_of_due_date)
    end

    def initialize ( raw_input=nil )
        @creation_date=Time.now
        @start_date   = nil
        @done_date    = nil
        @due_date     = nil
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
