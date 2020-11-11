//
//  GetMannaAPI.swift
//  MannaDemo
//
//  Created by once on 2020/11/07.
//
//
import Alamofire
import SwiftyJSON
import UIKit

class GetMannaAPI {
    static func getManna() {
        let url = "https://manna.duckdns.org:18888/manna?deviceToken=8F630481-548D-4B8A-B501-FFD90ADFDBA4"
        AF.request(url).response { response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
            case .failure(let err):
                print("err")
            }
            
            print("이거나오남")
        }
    }
}
