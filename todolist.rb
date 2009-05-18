#!/usr/bin/env ruby

class TodoList
    def initialize()
        @todoList=[]
    end
    def addTask(task)
        @todoList.append(task)
    end
end
