//
//  UIView+Ext.swift
//  MannaDemo
//
//  Created by once on 2020/10/23.
//

import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
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
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 19, height: self.bounds.height)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
