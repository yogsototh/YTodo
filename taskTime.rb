#!/usr/bin/env ruby

class TaskTime
    @creation_date  # creation date of the task
    @done_date      # date at which the task was done
    @start_date     # date at with the task began (hour,minute,second)
    @due_date       # due date for the task
    @duration       # time spend for finish that task
                    # can be set by the user to be
                    # different than (@done_date - @start_date)
    @max_duration   # maximal duration for that task
    @min_duration   # minimal duration for that task
    def initialize()
        @creation_date=Time.now
    end
    def taskTimeRegExp
        return Regexp.new(" #[^ ]*")
    end
end
