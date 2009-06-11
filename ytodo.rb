#!/usr/bin/env ruby

require "todolist.rb"

# this file run the minimal GUI
#
# it lacks a read config from config file
listeEnvVariables=[]
autosave=true
listeEnvVariables<<='autosave'
defaultTaskFile="tasks.ytd"
listeEnvVariables<<='defaultTaskFile'

def showVariable (varname) 
    printf '%20s = ', varname
    eval "puts "+varname
end

if __FILE__ == $0:
    todoList=TodoList.new
    todoList.load defaultTaskFile
    while true:
        print "> "
        entry=STDIN.gets.chomp
        case entry
        when /^(a|\+|add) / # ça commence par 'a ' '+ ' ou 'add '
            todoList.addTask( Task.new(entry.sub(/^(a|\+|add) /,"")) )
            if autosave: 
                todoList.save defaultTaskFile 
            end
        when /^(l|list)( ?(\d*))?/
            if $3.length>0: print "number "+$3 end
            print todoList.to_s
        when /^(s|save)( (.*))?$/
            if $3 and $3.length>0: 
                filename=$3 
            else
                filename=defaultTaskFile
            end
            puts "saving to " + filename
            todoList.save filename
        when /^(load|=>) (.*)/
            if $2.length>0: 
                filename = $2 
            else 
                filename = defaultTaskFile
            end
            todoList.load filename
        when /^h(elp)?$/
            # Vim tips not to loose any command
            # :r!grep when ytodo.rb 
            puts '
    a + add             add an entry
    cmd <cmd>, !<cmd>  launch external command
    h,help              show this message
    l,list              list the tasks
    load,=> [filename]  load the tasks from file filename
    q,quit              quit
    s,save [filename]   save the tasks to file filename
    show [conf key]     show the value of a configuration variable

    Tips: 
        you can also add an entry if the first word is not a command
    and the entry is longer than 10 characters (most of time it is).

    Reminder:
    @Context [project] (a note) {tag}
    priority: !! ! "nothing" ? ??
    date: 
        #due_date 
        #start_date,due_date 
        for example: #tomorrow,"in 4 days"
    '
        when /^(show)( (.*))?$/
            varname=$3
            if varname and (varname.length>0):
                if listeEnvVariables.include?(varname):
                    printf '%20s = ', varname
                    eval "puts "+varname
                else
                    found=false
                    listeEnvVariables.grep(Regexp.new(varname)).each do |elem|
                        printf '%20s = ', elem
                        eval "puts "+elem
                        found=true
                    end
                    if not found:
                        puts 'unknown variable name: '+varname
                        puts 'please select one of: '+listeEnvVariables.join(', ')
                    end
                end
            else
                listeEnvVariables.each do |key| 
                    printf '%20s = ', key
                    eval "puts "+key
                end
            end
        when /^q(uit)?$/
            break
        when /^(!|cmd )(.+)$/
            system( $2 )
        # must be the last two entries
        when /^.{1,10}$/ 
            # if the entry is not 
            # recognized and less than 10 characters 
            # long then we output an error
            print "/!\\ Commande inconnue /!\\\n"
        else 
            # if the entry is more than 10 characters long
            # and not recognized then it is a new entry
            todoList.addTask( Task.new(entry) )
        end
    end
end
