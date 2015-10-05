//
//  JsonTest.swift
//  JSONSwift
//
//  Created by Ankit Goel on 18/09/15.
//  Copyright © 2015 geekschool. All rights reserved.
//

import Foundation

let file = "file.txt" //this is the file. we will write to and read from it

let text = "some text" //just a text

if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
    let path = dir.stringByAppendingPathComponent(file);
    
    //writing
    do {
        try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
    }
    catch {/* error handling here */}
    
    //reading
    do {
        let text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
    }
    catch {/* error handling here */}
}