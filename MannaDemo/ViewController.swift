////
////  ViewController.swift
////  MannaDemo
////
////  Created by 정재인 on 2020/10/21.
////
//
//import UIKit
//import SwiftKeychainWrapper
//
//class ViewController: UIViewController {
//    
//    let marker = UserView(text: "우석")
//    let marker2 = UserView(text: "둘").then {
//        $0.frame.size = CGSize(width: 100, height: 100)
//        $0.backgroundColor = .red
//    }
//
//    let imageView = UIImageView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .brown
//        let temp = makeImageFrom(marker2)
//        imageView.image = #imageLiteral(resourceName: "back")
//        
//        view.addSubview(marker)
//        view.addSubview(imageView)
//
//        marker.translatesAutoresizingMaskIntoConstraints = false
//        marker.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        marker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        marker.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        marker.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.topAnchor.constraint(equalTo: marker.bottomAnchor, constant: 20).isActive = true
//        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        
////        marker3.translatesAutoresizingMaskIntoConstraints = false
////        marker3.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
////        marker3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////        marker3.widthAnchor.constraint(equalToConstant: 100).isActive = true
////        marker3.heightAnchor.constraint(equalToConstant: 100).isActive = true
////
////        name.translatesAutoresizingMaskIntoConstraints = false
////        name.centerYAnchor.constraint(equalTo: marker3.centerYAnchor).isActive = true
////        name.centerXAnchor.constraint(equalTo: marker3.centerXAnchor).isActive = true
////
////        imageView.translatesAutoresizingMaskIntoConstraints = false
////        imageView.topAnchor.constraint(equalTo: marker3.bottomAnchor, constant: 20).isActive = true
////        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
////        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
////        KeychainWrapper.standard.removeObject(forKey: "device_id")
//    }
//    
//    func makeImageFrom(_ desiredView: UIView) -> UIImage {
//       let size = CGSize(width: desiredView.bounds.width, height: desiredView.bounds.height)
//       let renderer = UIGraphicsImageRenderer(size: size)
//       let image = renderer.image { (ctx) in
//           desiredView.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
//       }
//       return image
//   }
//
//}
//
