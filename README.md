# JSONSwift
## JSON parser in pure swift. 
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
    ]}


Just call the method jsonParse with the jsonData string


    if let data =  jsonParse(jsonData) as? [String: AnyObject],
        let monday = data["MONDAY"] as? [AnyObject]  {
        for (course,_) in monday {
            println(course)
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

// Just call the method jsonParse with the jsonData string
    
    var outputArray : Array =  jsonParse(jsonData)!

// Retrieve nested object values

    for nested in outputArray {
        var what : Dictionary = (nested as? [String : AnyObject])!
        for (_,description) in what {
            println(description)
        }
    }


#### Parse twitter JSON..


// Sample twitter data from twitter search API


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

// Access tweets from Json returned by twitter API


    var outDictionary : Dictionary =  jsonParse(fileContent!)!


    if let statuses = outDictionary["statuses"] as? [AnyObject]{
    for elem in statuses {

        if let tweet = elem as? [String: AnyObject],
            let text : String = tweet["text"] as? String {
                println(text)
            }
        }
    }

// ENJOY!! You are a swift JSON parsing pro. xD

### Authors
[Ankit Goel](https://github.com/ankit1ank)

[Kartik Yelchuru](https://github.com/buildAI)

