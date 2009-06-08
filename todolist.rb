#!/usr/bin/env ruby

require "task.rb"

class TodoList
    def initialize()
        @todoList=[]
    end
    def addTask(task)
        @todoList << task
    end
    def to_s
        res=""
        i=1
        @todoList.each do |x| 
            res <<= '[' + i.to_s + '] ' + x.to_s + "\n"
            i+=1
        end
        res
    end
    def save(filename)
        f=File.open(filename, 'w') 
        f.write( to_s() ) 
    end
    def load(filename)
        begin
            f=File.open(filename, 'r')
            nbTasks=0
            while (line=f.readline)
                # delete the number ([...]) and
                # the newline character
                line.match(/\[[^\]]*\] (.*)[\r\n]$/)
                line=$1
                addTask( Task.new(line) )
                nbTasks+=1
            end
        rescue Errno::ENOENT
            puts "no such file #{filename}"
        rescue EOFError
            puts "Loaded "+nbTasks.to_s+" entries from "+filename
            f.close
        rescue IOError => e
            puts e.exception
        end
    end
end

if __FILE__ == $0:
    todoList=TodoList.new
    defaultTaskFile="tasks.ytd"
    todoList.load defaultTaskFile
    while true:
        print "> "
        entry=STDIN.gets.chomp
        case entry
        when /^(a|\+|add) / # ça commence par 'a ' '+ ' ou 'add '
            todoList.addTask( Task.new(entry.sub(/^(a|\+|add) /,"")) )
        when /^[@]/
            todoList.addTask( Task.new(entry) )
        when /^(l|list)( ?(\d*))?/
            if $3.length>0: print "number "+$3 end
            print todoList.to_s
        when /^(s|save)( (.*))?/
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
        when /^q(uit)?$/
            break
        else
            print "/!\\ Commande inconnue /!\\\n"
        end
    end
end
