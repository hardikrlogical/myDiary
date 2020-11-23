//
//  ApiManager.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//


import UIKit
import Foundation
import Alamofire
import SystemConfiguration
import RxSwift

public class Reachability {
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}

class ApiManager: NSRestApiHelper {
    class var sharedManager: ApiManager {
        struct Singleton {
            static let instance = ApiManager()
        }
        return Singleton.instance
    }
    
    //    func requsetForGet(urlQuery: String, CompletionHandler completion: @escaping CompletionHandler) {
    //        serviceURL = urlQuery
    //        getRequest() { (response, error, status) in
    //            completion(response, error, status)
    //        }
    //    }
    
    
    
    func requsetForGet(urlQuery: String) -> Observable<(AnyObject?,Error?,Int)> {
        return Observable.create { (observer) -> Disposable in
            self.serviceURL = urlQuery
            self.getRequest() { (response, error, status) in
                //completion(response, error, status)
                observer.onNext((response,error,status))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
