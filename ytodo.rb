#!/usr/bin/env ruby

require "todolist.rb"
require 'readline'

# this file run the minimal GUI
#
# it lacks a read config from config file
listeEnvVariables=[]

autosave=true
listeEnvVariables<<='autosave'

saveFile="TODO"
listeEnvVariables<<='saveFile'

doneFile="DONE"
listeEnvVariables<<='doneFile'

# Print help message
def putsHelpMessage
    # Vim tips not to loose any command
    # :r!grep when ytodo.rb 
    puts '
    COMMANDS 
a,+,add <entry>         add an entry
cmd,! <cmd>             launch external command
h,help                  show this message
l,list                  list the tasks
load,=> [filename]      load the tasks from file filename
q,quit                  quit
s,save [filename]       save the tasks to file filename
show [conf key]         show the value of a configuration variable

    TIPS
If your entrie is longer than 10 character long and the first
word is not a command. The entrie is added to task.

    REMINDER
  @Context [project] (a note) {tag}
Priority:   (higher) !!  ! "nothing" ? ?? (lower)
Date:       #due_date, #start_date,due_date 
    example:    #tomorrow,"in 4 days"
    '
end

if __FILE__ == $0:

    # trap the ^C
    trap('INT'){
        if not autosave:
            answer=Readline.readline('Do you want to save your changes? (y/n)',false)
            if not answer =~ /^no?$/:
                puts "Changes saved in #{saveFile}"
                todoList.save saveFile
            end
        end
        puts "\nGood Bye... See you later for another safe and productive day"
        exit 0
    }

    todoList=TodoList.new
    todoList.load saveFile
    while entry = Readline.readline('> ',true):
        case entry
        when /^(a|\+|add) /
            # Add en entry
            todoList.addTask( Task.new(entry.sub(/^(a|\+|add) /,"")) )
            if autosave: 
                todoList.save saveFile 
            end
        when /^(l|list)( ?(\d*))?/
            # list the entries
            if $3.length>0: print "number "+$3 end
            print todoList.to_s
        when /^(done|archive) (\d*)/
            # archive task
            taskNumber=$2
        when /^q(uit)?$/ 
            # Quit
            break
        when /^(s|save)( (.*))?$/
            # save to file
            if $3 and $3.length>0: 
                filename=$3 
            else
                filename=saveFile
            end
            puts "saving to " + filename
            todoList.save filename
        when /^(load|=>) (.*)/
            # load from file
            if $2.length>0: 
                filename = $2 
            else 
                filename = saveFile
            end
            todoList.load filename
        when /^h(elp)?$/
            putsHelpMessage
            # show help message
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
        when /^set ([^= ]*)(=|\s*)(.*)$/
            # default all variable are strings
            begin
                eval $1+"="+$3
            end
        when /^(!|cmd )(.+)$/
            system( $2 )
        # DEV # must be the last two entries # DEV #
        when /^$/ 
            # do nothing when there is no entry
        when /^.{1,10}$/ 
            # if the entry is not 
            # recognized and less than 10 characters 
            # long then we output an error
            print "/!\\ Unknown command /!\\\n"
        else 
            # if the entry is more than 10 characters long
            # and not recognized then it is a new entry
            todoList.addTask( Task.new(entry) )
            if autosave: 
                todoList.save saveFile 
            end
        end
    end
end
