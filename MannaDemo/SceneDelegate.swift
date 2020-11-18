//
//  SceneDelegate.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let url = "http://ec2-13-124-151-24.ap-northeast-2.compute.amazonaws.com:8888/user"
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rankView = RankingViewController()
            
            let mainView = MapViewController()
            let mannalistView = MannaListViewController()
            
            let registerView = RegisterUserViewController()
            
            print("이 기종의 스케일", UIScreen.main.scale)
            
            if KeychainWrapper.standard.string(forKey: "device_id") == nil {
                if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                    let saveSuccessful: Bool = KeychainWrapper.standard.set(uuid, forKey: "device_id")
                    print("keychain is successful : \(saveSuccessful)")
                }
                window.rootViewController = registerView
            } else {
                if let deviceID = KeychainWrapper.standard.string(forKey: "device_id") {
                    let param: Parameters = [
                        "device_id" : deviceID,
                    ]
                    
                    AF.request("https://manna.duckdns.org:18888/manna?deviceToken=\(deviceID)", parameters: param).responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("성공",value)
                            let result = JSON(value)["error"]
                            if result == "Not Found" {
                                window.rootViewController = registerView
                            } else {
                                window.rootViewController = mannalistView
                            }
                            break
                        case .failure(let error):
                            print("실패")
                            window.rootViewController = registerView
                            break
                        }
                    }
                    window.rootViewController = mannalistView
                }
            }
            self.window = window
            window.makeKeyAndVisible()
        }
        
        func sceneDidDisconnect(_ scene: UIScene) {
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }
        
        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }
        
        func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
        
        
    }
    
}
