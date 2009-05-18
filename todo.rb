#!/usr/bin/env ruby

class Contact
    # Contact is mainly an associated array
    # with some standard keys such as:
    #   - name, phone, port, email, address...
    # The idea behind this class is to be able
    # to show the contact informations along
    # with the 
    DefaultValues=[ "name", "email", "phone", "website", 
        "address", "url" ]
    def initialize (name)
        @information["name"]=name;
        @information["email"]=[];
        @information["phone"]=[];
        @information["website"]=[];
        @information["url"]=[];
        @information["address"]=[];
    end

    def append_info(key, value)
        @information[key].append(value)
    end

    def add_email (email)
        append_info("email",email);
    end

    def add_phone (phone)
        append_info("phone",phone);
    end

    def add_website(website)
        append_info("website",website);
    end

    def add_url(url)
        append_info("url",url);
    end

end

class TaskTime
    @creation_date  # creation date of the task
    @done_date      # date at which the task was done
    @start_date     # date at with the task began (hour,minute,second)
    @due_date       # due date for the task
    @duration       # time spend for finish that task
                    # can be set by the user to be
                    # different than (@done_date - @start_date)
    @max_duration   # maximal duration for that task
    @min_duration   # minimal duration for that task
    def initialize()
        @creation_date=Time.now
    end
end

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
