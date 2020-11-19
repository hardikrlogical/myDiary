//
//  Constant.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import Foundation
import UIKit

//MARK:- AppDelegate Singletone object

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let kProjectName                    = "DemoTestTask"

//MARK:- StoryBoard Name
let MAIN_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)


let kStatus                             = 1
let kNoInternet                         = "Unable to contact the server"
let kErrorNetwork                       = "Network error"
//WebService Constant
//live URL
let kMainUrl                           = "https://private-ba0842-gary23.apiary-mock.com/"

let KDiaryList                         = "notes"


// MARK:- Device Type Constants
struct ScreenSize {
    static let ScreenWidth = UIScreen.main.bounds.size.width
    static let ScreenHeight = UIScreen.main.bounds.size.height
    static let ScreenMaxLength = max(ScreenSize.ScreenWidth, ScreenSize.ScreenHeight)
    static let ScreenMinLength = min(ScreenSize.ScreenWidth, ScreenSize.ScreenHeight)
}

func getTimeStamp() -> String {
    //let currentDate = Date()
    //let myTimeStamp = currentDate.timeIntervalSince1970
    //let TimeStamp:String = String(myTimeStamp)
    
    let currentTime = NSDate().timeIntervalSince1970 * 1000
    let TimeStampNew:String = String(currentTime)
    let temp = TimeStampNew.components(separatedBy: ".")
    return temp[0]
}

