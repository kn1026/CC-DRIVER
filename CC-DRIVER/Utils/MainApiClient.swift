//
//  MainApiClient.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/20/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

class MainAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let shared = MainAPIClient()
    
    

    
    var baseURLString:String? = nil
    var baseURL: URL {
        
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            
            return url
        } else {
            
            fatalError()
        }
        
    }
    
    func completeCharge(_ result: STPPaymentResult, amount: Int, completion: @escaping STPErrorBlock) {
        
        let url = self.baseURL.appendingPathComponent("Ride")
        let params: [String: Any] = [
            "Source": result.source.stripeID,
            "Amount": amount

        ]
        
        Alamofire.request(url, method: .post, parameters: params)
                    .validate(statusCode: 200..<500)
            .responseString { response in
                switch response.result {
                    
                case .success:
                    completion(nil)
                    
                case .failure(let error):
                    completion(error)
                }
        }
        
        
        
    }
    
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("Empheral_keys")
        Alamofire.request(url, method: .post, parameters: [
        
            "api_verson": apiVersion
        
        ])
            
        .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    
                    completion(json as? [String: AnyObject], nil)
                    
                    
                case .failure(let error):
                    completion(nil, error)
                }
                
                
                
        }
        
        
        
    }
    
}
