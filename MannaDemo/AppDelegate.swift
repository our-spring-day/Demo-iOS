//
//  AppDelegate.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let userName: [String] = ["우석", "연재", "상원", "재인", "효근", "규리", "종찬", "용권"]
    var userImage: [UIImage] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        for name in userName {
            let image = UserView(text: name).then({
                $0.layer.cornerRadius = 30
            })
            let renderImage = image.asImage()
            userImage.append(renderImage)
        }
        print(userImage)
        var count = 0
//        for key in UserModel.userList.keys {
//            UserModel.userList[key]?.nicknameImage = userImage[count]
//            count += 1
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("앱이 죽었슴다")
    }
}

