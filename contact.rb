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
