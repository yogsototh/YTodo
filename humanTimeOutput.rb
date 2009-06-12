#!/usr/bin/env ruby

require 'time'

module HumanTimeOutput 
    def self.included(base)
        base.class_eval do
            alias_method :original_to_s, :to_s unless method_defined?(:original_to_s)
            # alias_method :to_s, :to_s_humanized
        end
    end

    def is_today?
        selfTab=self.to_a
        nowTab=Time.now.to_a
        return selfTab[4] == nowTab[4] &&
            selfTab[5] == nowTab[5] && 
            selfTab[6] == nowTab[6]
    end
    def to_s_humanized
        if self.is_today?
            return "today"
        else
            self.original_to_s
        end
    end
end
Time.send :include, HumanTimeOutput

