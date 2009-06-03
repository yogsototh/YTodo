#!/usr/bin/env ruby
#
require 'taskTime.rb'
require 'contact.rb'

class Task
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
        if (@contexts.length>0): res+=' ' + @contexts.map { |x| x.to_s }.join(" ") end
        if (@projects.length>0): res+=' ' + @projects.map { |x| '['+x.to_s+']' }.join(" ") end
        if (@contacts.length>0): res+=' ' + @contacts.map { |x| x.to_s }.join(" ") end
        if (@dates):             res+=' ' + @dates.to_s end
        if (@tags.length>0):     res+=' ' + '{' + @tags.map{ |x| x.to_s }.join(", ") + '}' end
        return res
    end

    def to_detailled_s
        res='desc: '+@description
        if (@contexts.length>0): 
            res+="\n contexts:" + @contexts.map { |x| x.to_s }.join(" ") 
        end
        if (@projects.length>0): 
            res+="\n projects:" + @projects.map { |x| '['+x.to_s+']' }.join(" ") 
        end
        if (@contacts.length>0): 
            res+="\n contacts:" + @contacts.map { |x| x.to_s }.join(" ") 
        end
        if (@dates):           
            res+="\n dates   :\n" + @dates.to_detailled_s 
        end
        if (@tags.length>0):     
            res+="\n tags    :" + '{' + @tags.map{ |x| x.to_s }.join(", ") + '}' 
        end
        return res
    end

    # -- constant class variable for each part 
    # -- of the regular expressions

    # Regular Expressions for that class
    @@StdTokenRegExp=Regexp.new(%{(\\w+|"[^"]*")})
    # Context
    @@ContextsRegExp=Regexp.new(%{ @#{@@StdTokenRegExp.inspect[1..-2]}})
    # Project
    @@ProjectsRegExp=Regexp.new(%{\\[#{@@StdTokenRegExp.inspect[1..-2]}\\]})
    # Contact
    @@ContactsRegExp=Regexp.new(%{ (c|contact):#{@@StdTokenRegExp.inspect[1..-2]}})
    # Notes
    @@NotesRegExp=Regexp.new(%{\\(#{@@StdTokenRegExp.inspect[1..-2]}\\)})

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

current = Task.new("Coucou @Home #tomorrow");
print current.to_detailled_s
print "\n"
