#!/usr/bin/env ruby
#
require 'taskTime.rb'
require 'contact.rb'

class Task
    def initialize(description, note, contacts, 
                   contexts, projects, dates, tags)
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
        # tags
        @tags=tags
    end
    def initialize(description)
        @notes=[]
        @contacts=[]
        @contexts=[]
        @projects=[]
        @tags=[]
        @priority=0
        @dates=TaskTime.new()
    end
    def to_s
        return @description + 
            @contexts.map { |x| x.to_s }.join(" ") + 
            @projects.map { |x| '['+x.to_s+']' }.join(" ") +
            @contacts.map { |x| x.to_s }.join(" ") +
            @dates.to_s +
            '{' + @tags.map{ |x| x.to_s }.join(", ") + '}'
    end

    # -- constant class variable for each part 
    # -- of the regular expressions

    # Regular Expressions for that class
    @@StdTokenRegExp=/(\w+|"[^"]*")/
    # Context
    @@ContextsRegExp=Regexp.new(%{ @#{@@StdTokenRegExp.inspect}})
    # Project
    @@ProjectsRegExp=Regexp.new(%{\\[#{@@StdTokenRegExp.inspect}\\]})
    # Contact
    @@ContactsRegExp=Regexp.new(%{ (c|contact):#{@@StdTokenRegExp.inspect}})
    # Notes
    @@NotesRegExp=Regexp.new(%{\(#{@@StdTokenRegExp.inspect}\)})

    def from_s( raw_input )

        @contexts=raw.scan(@@ContextsRegExp).map{ |x| x[0] }
        @projects=raw.scan(@@ProjectsRegExp).map{ |x| x[0] }
        @contacts=raw.scan(@@ContactsRegExp).map{ |x| x[1] }
        @notes   =raw.scan(   @@NotesRegExp).map{ |x| x[0] }
        # @contexts=raw.scan(/ @(\w+|"[^"]*")/).map{ |x| x[0] }
        # @projects=raw.scan(/\[(\w+|"[^"]*")\]/).map{ |x| x[0] }
        # @contacts=raw.scan(/ (c|contact):(\w+|"[^"]*")/).map{ |x| x[1] }
        # @notes=raw.scan(/\[(\w+|"[^"]*")\]/).map{ |x| x[1] }

        # somehow special for the priority
        @priority= raw.scan( /!/ ).length - raw.scan( /\?/ ).length

        @description=raw_input.gsub(
            Regexp.union(@@ContextsRegExp, @@ProjectsRegExp, @@ContactsRegExp, @@NotesRegExp, /!/, /\?/, @date.dateRegexp),"")
        @dates   =TaskTime.from_s(raw_input)
    end
end
