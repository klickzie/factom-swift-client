//
//  ApiManager.swift
//  factom-swift
//
//  Created by Aman Joshi on 15/10/19.
//  Copyright © 2019  Aman Joshi . All rights reserved.
//

import Foundation
import Alamofire

public typealias APICompletionHandler = ((_ response:JSONObject?, _ error:Error?)->Void)
public typealias JSONObject           = [String:Any]

//Base class for requesting the API's from the server
public class ApiManager {
    
    //MARK: - Properties
    public static let shared = ApiManager()
    
    //MARK: - Functions
    
    //call the below function for making request to the server
    //It is an asynchronous function
    //It gives a callback of type APICompletionHandler after it get response
    
    func httpRequest(urlString:String, params:JSONObject?, completion:@escaping APICompletionHandler) {
        let urlEncoding = JSONEncoding.prettyPrinted
        let headers = ["content-type":"text/plain"]
        print(params ?? "nil", "header - \(headers)")
        if isConnectedToInternet() {
            Alamofire.request(urlString, method: .post, parameters: params, encoding: urlEncoding, headers: headers).validate(statusCode: 200..<500).responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    if let jsonObject:JSONObject = json as? JSONObject {
                        print(json)
                        completion(jsonObject, nil)
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //Call the below function to check the internet connection
    @discardableResult
    open func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}
