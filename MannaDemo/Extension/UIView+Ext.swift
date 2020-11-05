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
    
    func createImage() -> UIImage {
        
        let rect: CGRect = self.frame
        
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
