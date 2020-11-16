//
//  getDeviceToken.swift
//  MannaDemo
//
//  Created by once on 2020/11/17.
//

import Foundation



class getDeviceToken {
    static func getUserDeviceToken(name: String) -> String{
        switch name {
        case "우석":
            return "f606564d8371e455"
        case "연재":
            return "aed64e8da3a07df4"
        case "상원":
            return "8F630481-548D-4B8A-B501-FFD90ADFDBA4"
        case "재인":
            return "0954A791-B5BE-4B56-8F25-07554A4D6684"
        case "효근":
            return "8D44FAA1-2F87-4702-9DAC-B8B15D949880"
        case "규리":
            return "2872483D-9E7B-46D1-A2B8-44832FE3F1AD"
        case "종찬":
            return "C65CDF73-8C04-4F76-A26A-AE3400FEC14B"
        case "용권":
            return "69751764-A224-4923-9844-C61646743D10"
        default:
            break
        }
        return ""
    }
}
