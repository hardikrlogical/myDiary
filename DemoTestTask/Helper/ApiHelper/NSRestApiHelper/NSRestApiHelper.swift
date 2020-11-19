//
//  NSRestApiHelper.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//


import UIKit
import Alamofire

// MARK:- Type alias defines
typealias CompletionHandler = (_ obj: AnyObject?, _ error: Error? , _ statusCode: Int) -> Void

class NSRestApiHelper: NSObject {

    override init () {
        super.init()
    }
    
    //Base url
    var baseURL: String = kMainUrl
    
    //service URL property
    var serviceURL: String = String() {
        didSet {
            self.serviceURL = self.baseURL + serviceURL
        }
    }
    
    
    func getRequest(CompletionHandler completion:@escaping CompletionHandler) {
        let headers:HTTPHeaders = []
        
        AF.request(URL(string: serviceURL)!, method: .get, parameters: nil,encoding: JSONEncoding.default , headers: headers, interceptor: nil).responseJSON { (response) in
                  
        
            switch response.result {
            case .success(_):
                if response.value != nil {
                    print(response.value as Any)
                    let statusCode = response.response!.statusCode
                    print("-------------STATUS CODE \(statusCode)------------------")
                    if statusCode == 200 {
                     completion(response.value as AnyObject, nil, 1)
                    } else {
                     completion(response.value as AnyObject, nil, 0)
                    }
                }
                break
            case .failure(_):
                if response.value != nil {
                    print(response.value as Any)
                    completion(nil, nil, 0)
                }
                break
                
            }
        }
    }
    
}
