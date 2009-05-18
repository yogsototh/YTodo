#!/usr/bin/env ruby
#
require 'taskTime.rb'
require 'contact.rb'

class Task
    def initialize(description, note, contacts, 
                   contexts, projects, dates)
        # the title of the task
        @description=description    
        # list of additionnal informations about the note
        # such as files (pdf, csv...)
        # details concerning this task
        @notes=notes
        # list of contacts
        @contacts=contacts
        # list of contextes
        @contexts=contexts
        # list of projects
        @projects=projects
        # multiple date associated to a task
        @dates=dates
    end
    def initialize(description)
        @notes=[]
        @contacts=[]
        @contexts=[]
        @projects=[]
        @dates=TaskTime.new()
    end
    def to_s
        return @description + 
            @contexts.map { |x| x.to_s }.join " " + 
            @projects.map { |x| x.to_s }.join " " +
            @contacts.map { |x| x.to_s }.join " " +
            @dates.to_s
    end
    def task_from_string( raw_input )
        # petite difficulté pour retrouver le message dans toute cette Meumeu...
        @description = raw_input 
        @description raw_input.gsub(/ (@|(p|project|c|contact|n|note):)(\w+|"[^"]*")/,"")
        @contexts=raw.scan(/ @(\w+|"[^"]*")/).map{ |x| x[0] }
        @projects=raw.scan(/ (p|project):(\w+|"[^"]*")/).map{ |x| x[1] }
        @contacts=raw.scan(/ (c|contact):(\w+|"[^"]*")/).map{ |x| x[1] }
        @notes   =raw.scan(/ (n|note):(\w+|"[^"]*")/).map{ |x| x[1] }
        @dates   =TaskTime.date_from_string(raw_input)
    end
end
