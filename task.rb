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
    def initialize(raw_input)
        @notes=[]
        @contacts=[]
        @contexts=[]
        @projects=[]
        @tags=[]
        @priority=0
        @dates=TaskTime.new()
        from_s(raw_input)
    end
    def to_s
        res=@description
        if (@contexts): res+=' ' + @contexts.map { |x| x.to_s }.join(" ") end
        if (@projects): res+=' ' + @projects.map { |x| '['+x.to_s+']' }.join(" ") end
        if (@contacts): res+=' ' + @contacts.map { |x| x.to_s }.join(" ") end
        if (@dates):    res+=' ' + @dates.to_s end
        if (@tags):     res+=' ' + '{' + @tags.map{ |x| x.to_s }.join(", ") + '}' end
        return res
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

        @contexts=raw_input.scan(@@ContextsRegExp).map{ |x| x[0] }
        @projects=raw_input.scan(@@ProjectsRegExp).map{ |x| x[0] }
        @contacts=raw_input.scan(@@ContactsRegExp).map{ |x| x[1] }
        @notes   =raw_input.scan(   @@NotesRegExp).map{ |x| x[0] }

        # somehow special for the priority
        @priority= raw_input.scan( /!/ ).length - raw_input.scan( /\?/ ).length

        @description=raw_input.gsub(
            Regexp.union(@@ContextsRegExp, @@ProjectsRegExp, 
                         @@ContactsRegExp, @@NotesRegExp, 
                         /!/, /\?/, @dates.regexp),"")
        @dates=TaskTime.new(raw_input)
    end
end

current = Task.new("Coucou");
print current.to_s
print "\n"
