//
//  JsonParse.swift
//  JSONSwift
//
//  Authored by Ankit Goel, Karthik Yelchuru
//  Copyright (c) 2015 geekskool. All rights reserved.
//

import Foundation

func jsonParseAnyObject(jsonString: String) -> AnyObject? {
    
    var index = jsonString.startIndex
    // Run space parser to remove beginning spaces
    spaceParser(jsonString, &index)
    if let output: AnyObject = arrayParser(jsonString,&index) {
        return output
    } else if let output: AnyObject = objectParser(jsonString,&index) {
        return output
    }
    return nil
}

//function to parser object
func objectParser(jsonString: String, inout index:String.Index) -> AnyObject? {
    var parsedArray: [String : AnyObject] = [:]
    if jsonString[index] == "{" {
        index = index.successor()
        while true{
            if let returnedElem: AnyObject = keyParser(jsonString,&index){
                let key = returnedElem as! String
                spaceParser(jsonString, &index)
                if let returnedElem: AnyObject = colonParser(jsonString, &index) {
                    if let returnedElem: AnyObject = valueParser(jsonString, &index){
                        let value:AnyObject = returnedElem
                        parsedArray[key] = value
                    }
                    spaceParser(jsonString, &index)
                    if let returnedElem = endOfSetParser(jsonString, &index) {
                        return parsedArray
                    }
                }
                else{
                    return nil
                }
            }
            else if jsonString[index] == "}" || isSpace(jsonString[index]){
                spaceParser(jsonString, &index)
                if let returnedElem = endOfSetParser(jsonString, &index) {
                    return parsedArray
                }
                else{
                    return nil
                }
            }
            else{
                break
            }
        }
    }
    return nil
}
//function to check key value in an object
func keyParser(jsonString: String, inout index: String.Index) -> AnyObject?{
    spaceParser(jsonString, &index)
    if let returnedElem: AnyObject = stringParser(jsonString, &index){
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
func valueParser(jsonString:String, inout index: String.Index) -> AnyObject? {
    var value: AnyObject
    spaceParser(jsonString, &index)
    if let returnedElem: AnyObject = elemParser(jsonString, &index){
        value = returnedElem
        spaceParser(jsonString, &index)
        commaParser(jsonString, &index)
        return value
    }
    return nil
}
//function to check end of object
func endOfSetParser(jsonString:String, inout index: String.Index) -> Bool? {
    if jsonString[index] == "}"{
        index = index.successor()
        return true
    }
    return nil
}
//function to parser an array
func arrayParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    var parsedArray: [AnyObject] = []
    if jsonString[index] == "[" {
        index  = index.successor()
        while true{
            if let returnedElem: AnyObject = elemParser(jsonString, &index){
                parsedArray.append(returnedElem)
                spaceParser(jsonString, &index)
                if let returnedElem: AnyObject = commaParser(jsonString, &index) {
                }
                else if let returnedElem = endOfArrayParser(jsonString, &index){
                    return parsedArray
                }
                else{
                    return nil
                }
            }
            else if jsonString[index] == "]" || isSpace(jsonString[index]){
                spaceParser(jsonString, &index)
                if let returnedElem = endOfArrayParser(jsonString, &index){
                    return parsedArray
                }
                else{
                    return nil
                }
            }
            else{
                break
            }
        }
    }
    return nil
}
//Parsing elements in Array
func elemParser(jsonString:String, inout index: String.Index) -> AnyObject? {
    spaceParser(jsonString, &index)
    if let returnedElem: AnyObject = stringParser(jsonString, &index) {
        return returnedElem
    }
    else if let returnedElem: AnyObject = numberParser(jsonString, &index) {
        return returnedElem
    }
    else if let returnedElem: AnyObject = booleanParser(jsonString, &index) {
        return returnedElem
    }
    else if let returnedElem: AnyObject = arrayParser(jsonString, &index) {
        return returnedElem
    }
    else if let returnedElem: AnyObject = objectParser(jsonString, &index) {
        return returnedElem
    }
    else if let returnedElem: AnyObject = nullParser(jsonString, &index) {
        return returnedElem
    }
    return nil
}
//A function to check end of array
func endOfArrayParser(jsonString:String, inout index: String.Index) -> Bool? {
    if jsonString[index] == "]"{
        index = index.successor()
        return true
    }
    return nil
}
//method to check space
func isSpace(c: Character) -> Bool {
    switch c {
    case " ", "\t", "\n": return true
    default: return false
    }
}
//space parser
func spaceParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    if isSpace(jsonString[index]){
        var parsedSpace = ""
        let startingIndex: String.Index = index
        while index != jsonString.endIndex{
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

//number parser -- This method check all json valid numbers including exponents
func numberParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    var parsedNumber : Double
    var startingIndex = index
    var first = 0
    
    //method to check for  number
    func isNumber(n: Character) -> Bool{
        switch n {
        case "0","1","2","3","4","5","6","7","8","9": return true
        default	: return false
        }
    }
    
    // When number is negative i.e. starts with "-"
    if jsonString[startingIndex] == "-"
    {
        index = index.successor()
    }
    
    do {
        if first == 0 && !isNumber(jsonString[index]){
            return nil
        }
        if index.successor() != jsonString.endIndex{
            index = index.successor()
            first = 1
        }else{
            index = index.successor()
            break
        }
    } while isNumber(jsonString[index])
    
    if index != jsonString.endIndex && jsonString[index] == "." {
        if index.successor() != jsonString.endIndex{
            index = index.successor()
        }
        else {
            return nil
        }
        
        do {
            if first == 1 && !isNumber(jsonString[index]){
                return nil
            }
            if index.successor() != jsonString.endIndex{
                index = index.successor()
                first = 0
            }else{
                index = index.successor()
                break
            }
        } while isNumber(jsonString[index])
    }
    
    if  (jsonString[index] == "e" || jsonString[index] == "E") {
        if index.successor() != jsonString.endIndex{
            index = index.successor()
        }
        else {
            return nil
        }
        if jsonString[index] == "-" || jsonString[index] == "+"
        {
            index = index.successor()
        }
        do {
            if first == 0 && !isNumber(jsonString[index]){
                return nil
            }
            
            if index.successor() != jsonString.endIndex{
                index = index.successor()
            }
            else {
                index = index.successor()
                break
            }
            
        } while isNumber(jsonString[index])
    }
    
    let range = startingIndex..<index
    let tempNumber = (jsonString[range] as NSString)
    parsedNumber = tempNumber.doubleValue
    return parsedNumber
}
// string parser
func stringParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    if jsonString[index] == "\""{
        var s = 0
        index = index.successor()
        let startingIndex: String.Index = index
        while index != jsonString.endIndex {
            if jsonString[index] == "\\" {
                index = index.successor()
                s = 1
                continue
            }
            if s == 1 && jsonString[index] == "\""{
                index = index.successor()
                s = 0
                continue
            }
            else if jsonString[index] == "\""{
                break
            }
            index = index.successor()
            s = 0
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
    if jsonString[index] == ","{
        index = index.successor()
        return ","
    }
    return nil
}
//boolean parser
func booleanParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    let startingIndex: String.Index = index
    if jsonString[index] == "t" || jsonString[index] == "f"{
        index = advance(index, 4)
        let trueString = jsonString[startingIndex..<index]
        if trueString == "true" {
            return true
        }
        index = index.successor()
        let falseString = jsonString[startingIndex..<index]
        if falseString  == "false" {
            return false
        }}
    index = startingIndex
    return nil
}

class NULL {}

func nullParser(jsonString: String, inout index: String.Index) -> AnyObject? {
    let startingIndex: String.Index = index
    if jsonString[index] == "n" || jsonString[index] == "N"{
        index = advance(index, 4)
        let nullString = jsonString[startingIndex..<index]
        if nullString == "null" || nullString == "NULL" {
            return NULL()
        }}
    index = startingIndex
    return nil
}

func jsonParse(jsonString: String) -> [String: AnyObject]? {
    if let output: [String: AnyObject] = jsonParseAnyObject(jsonString) as? [String: AnyObject]{
        return output
    }
    return nil
}

func jsonParse(jsonString: String) -> [AnyObject]? {
    if let output: [AnyObject] = jsonParseAnyObject(jsonString) as? [AnyObject]{
        return output
    }
    return nil
}
