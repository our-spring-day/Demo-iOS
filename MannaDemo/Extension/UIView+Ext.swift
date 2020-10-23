//
//  UIView+Ext.swift
//  MannaDemo
//
//  Created by once on 2020/10/23.
//

import UIKit

extension UIView {
    func asImage() -> UIImage {
        //        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        //        let image = renderer.image { _ in
        //            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        //        }
        //        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        ////        drawHierarchy(in: bounds, afterScreenUpdates: true)
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //        return image
        //    }
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image {
            layer.render(in: $0.cgContext)
        }
    }
    func makeImageFrom(_ desiredView: UIView) -> UIImage {
       let size = CGSize(width: desiredView.bounds.width, height: desiredView.bounds.height)
       let renderer = UIGraphicsImageRenderer(size: size)
       let image = renderer.image { (ctx) in
           desiredView.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
       }
       return image
   }
}