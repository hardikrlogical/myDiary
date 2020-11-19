//
//  NSUtility.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import UIKit
import CoreLocation

let debubPrintLog: Int = 1

class NSUtility: NSObject {
    
    //MARK:- Get FilePath
    /**
    Used to get file path
    - parameter fileName:         fileName string
    
    - returns: String
    */
   
    
    
    //MARK:- Get Object for key
    /**
     Get value from Dictionary
     
     - parameter key: string
     - parameter dictResponse: dictResponse
     - returns: value as Anyobject
     */
    class func getObjectForKey(key: String!, dictResponse: NSDictionary!) -> Any {
        guard let akey = key, let adictResponse = dictResponse , akey.isEmpty == false && adictResponse != NSNull() else {
            return ""
        }
        
        guard let value = dictResponse.value(forKey: key) else {
            return ""
        }
        
        if let _: NSNull = value as? NSNull {
            return ""
        } else {
            if value as? String ?? "" == "<null>" {
                return ""
            }
            return value
        }
    }
    
    //MARK:- Get String Value from Dictionary
    class func getStringObjectForKey(_ key: String!, From dictionary: NSDictionary!) -> String {
        guard let akey = key, let adictResponse = dictionary , akey.isEmpty == false && adictResponse != NSNull() else {
            return ""
        }
        
        guard let value = adictResponse.value(forKey: key) else {
            return ""
        }
        
        if let _: NSNull = value as? NSNull {
            return ""
        } else {
            if let valueString = value as? String {
                return valueString == "<null>" ? "" : valueString
            } else if let valueInt = value as? Int {
                return "\(valueInt)"
            } else if let valueInt = value as? Int64 {
                return "\(valueInt)"
            } else {
                return ""
            }
        }
    }
    
    //MARK:- Get Int Value from Dictionary
    class func getIntObjectForKey(_ key: String!, From dictionary: NSDictionary!) -> Int? {
        guard let akey = key, let adictResponse = dictionary , akey.isEmpty == false && adictResponse != NSNull() else {
            return 0
        }
        
        guard let value = adictResponse.value(forKey: key) else {
            return 0
        }
        
        if let _: NSNull = value as? NSNull {
            return 0
        } else {
            if let valueString = value as? String {
                return valueString == "<null>" ? 0 : Int(valueString) ?? 0
            } else if let valueInt = value as? Int {
                return valueInt
            } else {
                return 0
            }
        }
    }
    
    //MARK:- Check String Contain Text
    /**
     Check For Empty String
     
     - parameter string: string
     - returns: result bool
     */
    class func checkIfStringContainsText(string: String?) -> Bool {
        if let stringEmpty = string {
            let strNew = stringEmpty.trimmingCharacters(in: .whitespacesAndNewlines)
            if (strNew.isEmpty) {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    
    //MARK:- Get and Set value to UserDefaults
    /**
     Get value from user defaults
     - returns: value as Anyobject
     */
    class func getValueFromUserDefaultsForKey(keyName: String!) -> AnyObject? {
        if !NSUtility.checkIfStringContainsText(string: keyName) {
            return nil
        }
        let value: AnyObject? = UserDefaults.standard.object(forKey: keyName) as AnyObject?
        if value != nil {
            return value
        } else {
            return nil
        }
    }
    
    /**
     Save value to user defaults
     
     - parameter keyName: keyName
     - parameter value:   value
     */
    class func setValueToUserDefaultsForKey(keyName: String!, value: AnyObject!) {
        if !NSUtility.checkIfStringContainsText(string: keyName) {
            return
        }
        if value == nil {
            return
        }
        UserDefaults.standard.set(value, forKey: keyName)
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- time convert from date
    class func timeConvertFromDate(date: Date) -> String {
        
        let calendar = Calendar.current
        let dateCompnents = Set<Calendar.Component>([.year, .month, .weekOfMonth, .day, .hour, .minute, .second])
        let components = calendar.dateComponents(dateCompnents, from: date, to: Date())
        
        if components.year! > 0 {
            if components.year! > 1 {
                return "\(components.year!) years ago"
            } else {
                return "\(components.year!) year ago"
            }
        } else if components.month! > 0 {
            if components.month! > 1 {
                return "\(components.month!) months ago"
            } else {
                return "\(components.month!) month ago"
            }
        } else if components.weekOfMonth! > 0 {
            if components.weekOfMonth! > 1 {
                return "\(components.weekOfMonth!) weeks ago"
            } else {
                return "\(components.weekOfMonth!) week ago"
            }
        } else if components.day! > 0 {
            if components.day! > 1 {
                return "\(components.day!) days ago"
            } else {
                return "\(components.day!) day ago"
            }
        } else {
            if (components.hour! >= 2) {
                return "\(components.hour!) hours ago"
            } else if (components.hour! >= 1){
                return "\(components.hour!) hour ago"
            } else if (components.minute! >= 2) {
                return "\(components.minute!) minutes ago"
            } else if (components.minute! >= 1){
                return "\(components.minute!) minute ago"
            } else {
                return "moment ago"
            }
        }
    }
    
    //MARK:- Convet Date or time to String
    /**
     Get date or time from current date to assing date
     
     - parameter date: date
     */
    class func dateStringFromTimeStamp(timeStamp: Int64, strDateFormat: String) -> String {
        
        let newDate = Date(timeIntervalSince1970: TimeInterval(timeStamp)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormat//"HH:mm:ss dd-MM-yyyy"
        let convertedDate = dateFormatter.string(from: newDate)
        return convertedDate
    }
    
    //MARK:- Set FontSize
    /**
     Set FontSize
     
     - parameter size: image
     */
    class func fontSizeCompatibleWithDevice(size: CGFloat) -> CGFloat {
        
        let fontSize = UIDevice.current.model == "iPad" ? size + 5.0 : (ScreenSize.ScreenWidth > 320 ? size + 1.0 : size)
        return fontSize
    }
    
    //MARK:- Generate Random string
    class func generateRandomString(length: Int) -> String {
        let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        let len = length
        var randomString = ""
        for _ in 0..<len {
            // generate a random index based on your array of characters count
            let rand = arc4random_uniform(UInt32(characters.count))
            // append the random character to your string
            randomString.append(characters[Int(rand)])
        }
        return randomString
    }
   
    //MARK:- Location Placemark
    class func getLocationPlacemark(from pincode: String, CompletionHandler completion:@escaping (_ responceInfo: AnyObject?, _ error: Error?)-> Void) {
        let zipCode = pincode
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipCode) {
            (placemarks, error) -> Void in
            // Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
            guard error == nil else {
                completion(nil, error)
                return
            }
            if let placemark = placemarks?[0] {
                DBlog(message: placemark.administrativeArea as Any)
                completion(placemark, nil)
            }
            
        }
    }
    
    
}

//MARK:- Print Debug Log
/**
 Show DebubLogs Methods
 1.    set value 1 to debubPrintLog to Enable the debuging logs
 2.    set value 0 to debubPrintLog to Disable the debuging logs
 3.    debubPrintLog is a Global variable
 - parameter message: message
 */
func DBlog(message: Any) {
    if debubPrintLog == 1 {
        print(message)
    }
}
