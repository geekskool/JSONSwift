# JSONSwift
## JSON parser in pure swift

A JSON parser written from the ground up in pure Swift. It is a functional recursive descent parser.

### Installing
Copy "JsonParse.swift" file into your project. Or just import the framework. That's it. :)

### How to use:

####  Parse JSON Object

    // Data
    
    {
        "MONDAY": [
            {
                "TITLE":   "TEST DRIVEN DEVELOPMENT",
                "SPEAKER": "JASON SHAPIRO",
                "TIME": "9:00 AM"
            },
            {
                "TITLE": "JAVA TOOLS",
                "SPEAKER": "JIM WHITE",
                "TIME": "9:00 AM"
            }
        ],
        "TUESDAY": [
            {
                "TITLE": "MONGODB",
                "SPEAKER": "DAVINMICKELSON",
                "TIME": "1: 00PM"
            },
            {
                "TITLE": "DEBUGGINGWITHXCODE",
                "SPEAKER": "JASONSHAPIRO",
                "TIME": "1: 00PM",
            }
        ]
    }


Just call the method jsonParse with the jsonData string


    if let data : [String: AnyObject] =  jsonParse(fileContent!),
        let monday = data["MONDAY"] as? [AnyObject]  {
            for course in monday {
                if let title = course["TITLE"] as? String {
                    println(title)
                }
            }
    }

    


#### Parse JSON Array


    // Data
    [
        {
            "Name" : "Jhon"
            "ID" : 176
        },		
        {
            "Name" : "Dexter"
            "ID" : 193
        },
        {
            "Name" : "Wick"
            "ID" : 122
        }
    ]

Just call the method jsonParse with the jsonData string
    
    if let data : Array =  jsonParse(input){
        for object in data {
            if let elem = object as? [String: AnyObject] {
                println(elem["Name"]!)
                println(elem["ID"]!)
            }
        }
    }


#### Parse twitter JSON..


Sample twitter data from twitter search API


    {
        statuses: [
            {
            ...
            ...
            "text": "The tweet is here"
            ...
            ...
        },
            {
            ...
            ...
            "text": "The second tweet is here"
            ...
            ...
        }	
        ]
    }

Access tweets from Json returned by twitter API


    if let data : [String: AnyObject] = jsonParse(input), 
        let statuses = data["statuses"] as? [AnyObject]{
        for elem in statuses {

        if let tweet = elem as? [String: AnyObject],
            let text : String = tweet["text"] as? String {
                println(text)
                }
            }
        }
    

### Authors
[Ankit Goel](https://github.com/ankit1ank)

[Kartik Yelchuru](https://github.com/buildAI)

