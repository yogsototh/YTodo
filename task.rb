#!/usr/bin/env ruby

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
end
