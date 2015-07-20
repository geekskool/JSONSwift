//
//  JsonParse.swift
//  JSONSwift
//
//  Authored by Ankit Goel, Karthik Yelchuru
//  Copyright (c) 2015 geekskool. All rights reserved.
//

import Foundation

/*------------------------------------THIS IS THE START OF PARSER---------------------------------------------------------------------*/



func jsonParseAnyObject(jsonString: String) -> AnyObject? {
    
    var index = jsonString.startIndex
    
    // Run space parser to remove beginning spaces
    spaceParser(jsonString, index: &index)
    
    if let output = arrayParser(jsonString,index: &index) {
        return output
    }
    if let output = objectParser(jsonString,index: &index) {
        return output
    }
    return nil
}

//function to parser object
//Starts by checking for a {
//Next checks for the key of the object
//finally the value of the key
//Uses - KeyParser,SpaceParser,valueParser and endofsetParser
//Finally checks for the end of the main Object with a }

func objectParser(jsonString: String, inout index:String.Index) -> AnyObject? {
    var parsedArray = [String: AnyObject]()
    if jsonString[index] == "{" {
        index = index.successor()
        while true {
            if let returnedElem = keyParser(jsonString,index: &index) {
                let key = returnedElem as! String
                spaceParser(jsonString, index: &index)
                if let _ = colonParser(jsonString, index: &index) {
                    if let returnedElem = valueParser(jsonString, index: &index) {
                        let value = returnedElem
                        parsedArray[key] = value
                    }
                    spaceParser(jsonString, index: &index)
                    if let _ = endOfSetParser(jsonString, index: &index) {
                        return parsedArray
                    }
                }
                else {
                    return nil
                }
            }
            else if jsonString[index] == "}" || isSpace(jsonString[index]) {
                spaceParser(jsonString, index: &index)
                if let _ = endOfSetParser(jsonString,index: &index) {
                    return parsedArray
                }
                return nil
            }
            else {
                break
            }
        }
    }
    return nil
}

//function to check key value in an object
//Uses SpaceParser and StringParser
func keyParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    spaceParser(jsonString, index: &index)
    if let returnedElem: AnyObject = stringParser(jsonString, index: &index) {
        return returnedElem
    }
    return nil
}

//function to check colon
func colonParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    if jsonString[index] == ":" {
        index =  index.successor()
        return ":"
    }
    return nil
}

//function to check value in an object
//SpaceParser to remove spaces
//pass it to the elemParser
//stores the returned element in a variable called value
//afetr which the string is then passed to the space and comma parser
func valueParser(jsonString:String, inout index: String.Index) -> AnyObject? {
    spaceParser(jsonString, index: &index)
    if let returnedElem = elemParser(jsonString, index: &index) {
        let value = returnedElem
        spaceParser(jsonString, index: &index)
        commaParser(jsonString, index: &index)
        return value
    }
    return nil
}

//function to check end of object
//checks for a }
func endOfSetParser(jsonString:String, inout index: String.Index) -> Bool? {
    if jsonString[index] == "}" {
        index = index.successor()
        return true
    }
    return nil
}

//function to parser an array
//starts by checking for a [
//after which it is passed to an elemParser store the returned value in another array called parsed array
//Uses elemParser,SpaceParser,commaParser,endOfArrayParser
//Finally checks for a ] to mark the end of the array
func arrayParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    var parsedArray = [AnyObject]()
    if jsonString[index] == "[" {
        index = index.successor()
        while true {
            if let returnedElem = elemParser(jsonString, index: &index) {
                parsedArray.append(returnedElem)
                spaceParser(jsonString, index: &index)
                if let _ = commaParser(jsonString, index: &index) {
                }
                else if let _ = endOfArrayParser(jsonString, index: &index) {
                    return parsedArray
                }
                else {
                    return nil
                }
            }
            else if jsonString[index] == "]" || isSpace(jsonString[index]) {
                spaceParser(jsonString, index: &index)
                if let _ = endOfArrayParser(jsonString, index: &index) {
                    return parsedArray
                }
                return nil
            }
            else {
                break
            }
        }
    }
    return nil
}

//Parsing elements in Array
//uses StringParser,numberParser,arrayParser,objectParser and nullParser
func elemParser(jsonString:String, inout index: String.Index) -> AnyObject? {
    spaceParser(jsonString, index: &index)
    if let returnedElem = stringParser(jsonString, index: &index) {
        return returnedElem
    }
    if let returnedElem = numberParser(jsonString, index: &index) {
        return returnedElem
    }
    if let returnedElem = booleanParser(jsonString, index: &index) {
        return returnedElem
    }
    if let returnedElem = arrayParser(jsonString, index: &index) {
        return returnedElem
    }
    if let returnedElem = objectParser(jsonString, index: &index) {
        return returnedElem
    }
    if let returnedElem = nullParser(jsonString, index: &index) {
        return returnedElem
    }
    return nil
}

//A function to check end of array
func endOfArrayParser(jsonString:String, inout index: String.Index) -> Bool? {
    
    if jsonString[index] == "]" {
        index = index.successor()
        return true
    }
    return nil
}

//method to check space
func isSpace(c: Character) -> Bool {
    switch c {
    case " ", "\t", "\n":
        return true
    default:
        return false
    }
}


//space parser
//uses isSpace function
func spaceParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    if isSpace(jsonString[index]) {
        var parsedSpace = ""
        let startingIndex = index
        while index != jsonString.endIndex {
            if isSpace(jsonString[index]) {
                index = index.successor()
            }
            else {
                break
            }
        }
        let range = startingIndex..<index
        parsedSpace = jsonString[range]
        return parsedSpace
    }
    return nil
}

//method to check for  number
func isNumber(n: Character) -> Bool {
    if "0"..."9" ~= n {
        return true
    }
    else {
        return false
    }
}

//method to consume the number
func consumeNumber(jsonString: String, inout index: String.Index) {
    while isNumber(jsonString[index]) {
        if index.successor() != jsonString.endIndex {
            index = index.successor()
        }
        else {
            break
        }
    }
}

//number parser -- This method check all json valid numbers including exponents
func numberParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    
    let startingIndex = index
    
    // When number is negative i.e. starts with "-"
    if jsonString[startingIndex] == "-" {
        index = index.successor()
    }
    
    if !isNumber(jsonString[index]) {
        return nil
    }
    
    consumeNumber(jsonString,index: &index)
    
    // For decimal points
    if jsonString[index] == "." {
        if index.successor() != jsonString.endIndex {
            index = index.successor()
        }
        else {
            return nil
        }
        if !isNumber(jsonString[index]) {
            return nil
        }
        consumeNumber(jsonString,index: &index)
    }
    
    //For exponents
    if  (jsonString[index] == "e" || jsonString[index] == "E") {
        if index.successor() != jsonString.endIndex {
            index = index.successor()
        }
        else {
            return nil
        }
        if jsonString[index] == "-" || jsonString[index] == "+" {
            index = index.successor()
        }
        if !isNumber(jsonString[index]) {
            return nil
        }
        consumeNumber(jsonString,index: &index)
    }
    
    let range = startingIndex..<index
    let parsedNumber = (jsonString[range] as NSString).doubleValue
    return parsedNumber
}



func stringParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    if jsonString[index] == "\""{
        index = index.successor()
        let startingIndex = index
        while index != jsonString.endIndex {
            if jsonString[index] == "\\" {
                index = index.successor()
                switch jsonString[index] {
                case "\"" :
                    index = index.successor()
                default :
                    break
                }
            }
            else if jsonString[index] == "\"" {
                break
            }
            else {
                index = index.successor()
            }
        }
        let range = startingIndex..<index
        let parsedString = jsonString[range]
        index = index.successor()
        return parsedString
    }
    return nil
}



//comma parser
func commaParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    if jsonString[index] == "," {
        index = index.successor()
        return ","
    }
    return nil
}

//boolean parser
//advances the index by 4 and checks for true or by 5 and checks for false
func booleanParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    let startingIndex: String.Index = index
    index = advance(index, 4, jsonString.endIndex)
    let trueString = jsonString[startingIndex..<index]
    if trueString == "true" {
        return true
    }
    if index != jsonString.endIndex {
        index = index.successor()
        let falseString = jsonString[startingIndex..<index]
        if falseString  == "false" {
            return false
        }
    }
    index = startingIndex
    return nil
}

class NULL {}

func nullParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    let startingIndex = index
    index = advance(index, 4, jsonString.endIndex)
    let nullString = jsonString[startingIndex..<index]
    if nullString == "null" || nullString == "NULL" {
        return NULL()
    }
    index = startingIndex
    return nil
}

//returns a Dictionary
func jsonParse(jsonString: String) -> [String: AnyObject]? {
    if let output = jsonParseAnyObject(jsonString) as? [String: AnyObject] {
        return output
    }
    return nil
}

//returns an array
func jsonParse(jsonString: String) -> [AnyObject]? {
    if let output = jsonParseAnyObject(jsonString) as? [AnyObject] {
        return output
    }
    return nil
}


/*------------------------------------END OF PARSER---------------------------------------------------------------------*/


/*.................................JSON STRINGIFY............................................................................................................................*/

func jsonStringify(jsonObject: AnyObject) -> String {
    
    var jsonString: String = ""
    
    switch jsonObject {
        
    case _ as [String: AnyObject] :
        
        let tempObject: [String: AnyObject] = jsonObject as! [String: AnyObject]
        jsonString += "{"
        for (key , value) in tempObject {
            if jsonString.characters.count > 1 {
                jsonString += ","
            }
            jsonString += "\"" + String(key) + "\":"
            jsonString += jsonStringify(value)
        }
        jsonString += "}"
        
    case _ as [AnyObject] :
        
        jsonString += "["
        for i in 0..<jsonObject.count {
            if i > 0 {
                jsonString += ","
            }
            jsonString += jsonStringify(jsonObject[i])
        }
        jsonString += "]"
        
    case _ as String :
        
        jsonString += ("\"" + String(jsonObject) + "\"")
        
    case _ as NSNumber :
        
        if jsonObject.isEqualToValue(NSNumber(bool: true)) {
            jsonString += "true"
        } else if jsonObject.isEqualToValue(NSNumber(bool: false)) {
            jsonString += "false"
        } else {
            return String(jsonObject)
        }
        
    case _ as NULL :
        
        jsonString += "null"
        
    default :
        
        jsonString += ""
    }
    return jsonString
}

/*          USAGE

var stringifiedJsonObject = jsonStringify(jsonObject) */


/*...........................................END OF JSON STRINGIFY.....................................................................................................................*/






do {
    let location = "~/Documents/SwiftBeginnerStuff/jsondata/youtube.json".stringByExpandingTildeInPath
    let fileLocation: String  = try(String(contentsOfFile: location,encoding: NSUTF8StringEncoding))
    //print(fileLocation)
    if let jsonObject: [String: AnyObject] = jsonParse(fileLocation) {
        print("parsed data is :\(jsonObject)")
    }
    else {
            print("something isnt right")
    }
}catch {
    print("Error : maybe the file does not exist")
}









//func numberParserForDecimal(jsonString: String, inout index: String.Index) -> AnyObject? {
//    let startingIndex = index
//    if jsonString[index] == "." {
//        if index.successor() != jsonString.endIndex {
//            index = index.successor()
//        }
//        else {
//            return nil
//        }
//        if !isNumber(jsonString[index]) {
//            return nil
//        }
//        consumeNumber(jsonString,index: &index)
//    }
//    return jsonString[startingIndex..<index]
//}
//
//func numberParserForExponents(jsonString: String, inout index: String.Index) -> AnyObject? {
//    let startingIndex = index
//    if  (jsonString[index] == "e" || jsonString[index] == "E") {
//        if index.successor() != jsonString.endIndex {
//            index = index.successor()
//        }
//        else {
//            return nil
//        }
//        if jsonString[index] == "-" || jsonString[index] == "+" {
//            index = index.successor()
//        }
//        if !isNumber(jsonString[index]) {
//            return nil
//        }
//        consumeNumber(jsonString,index: &index)
//    }
//    return jsonString[startingIndex..<index]
//
//}




//// string parser
//func stringParser1(jsonString: String, inout index: String.Index) -> AnyObject? {
//    if jsonString[index] == "\""{
//        var s = 0
//        index = index.successor()
//        let startingIndex: String.Index = index
//        while index != jsonString.endIndex {
//            if jsonString[index] == "\\" {
//                index = index.successor()
//                s = 1
//                continue
//            }
//            if s == 1 && jsonString[index] == "\""{
//                index = index.successor()
//                s = 0
//                continue
//            }
//            else if jsonString[index] == "\""{
//                break
//            }
//            index = index.successor()
//            s = 0
//        }
//        let range = startingIndex..<index
//        let parsedString = jsonString[range]
//        index = index.successor()
//        print("parser1: \(parsedString)")
//        return parsedString
//    }
//    return nil
//}


