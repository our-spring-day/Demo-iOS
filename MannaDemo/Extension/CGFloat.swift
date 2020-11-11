//
//  CGFloat.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/11.
//

import UIKit


public extension CGFloat {
    func pixelsToPoints() -> CGFloat { return self * ( 2 / UIScreen.main.scale ) }
}
