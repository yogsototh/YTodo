#!/usr/bin/env ruby

require 'time'

module BetterOutput 
    def is_today?
        selfTab=self.to_a
        nowTab=Time.now.to_a
        return selfTab[4] == nowTab[4] and 
                selfTab[5] == nowTab[5] and 
                selfTab[6] == nowTab[6]
    end
    def to_s 
        now=Time.now
        nowTab=now.to_a
        selfTab=self.to_a

        if (self < now): # in the past
            if is_today?:
        else: # in the future
        end 
    end
end
Time.send :include, BetterOutput

