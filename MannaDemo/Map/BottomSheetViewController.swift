//
//  BottomSheetViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit
import SnapKit

extension BottomSheetViewController {
    private enum State {
        case partial
        case full
    }
    private enum Constant {
        static let fullViewYPosition: CGFloat = UIScreen.main.bounds.height / 2
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height * 0.875}
    }
}

class BottomSheetViewController: UIView {
    var standardY = CGFloat(0)
    var collectionView = MannaCollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.85, height: 200))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(10)
            $0.centerX.equalTo(snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        self.frame = CGRect(x: 0,
                            y: yPosition,
                            width: self.frame.width,
                            height: self.frame.height)
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let minY = self.frame.minY
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            self.frame = CGRect(x: 0,
                                y: minY,
                                width: self.frame.width,
                                height: self.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .began {
            standardY = recognizer.location(in: self).y
        } else if recognizer.state == .changed {
            self.center.y = (self.center.y + recognizer.location(in: self).y) - standardY
            
        } else if recognizer.state == .ended {
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .allowUserInteraction,
                           animations: {
                            let state: State = recognizer.velocity(in: self).y >= 0 ?
                                .partial : .full
                            self.moveView(state: state)},
                           completion: { _ in
                            self.isUserInteractionEnabled = true }
            )
        }
    }
    
    func attribute() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        self.do {
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.addGestureRecognizer(gesture)
            $0.backgroundColor = .gray
            $0.alpha = 0.7
        }
        collectionView.do {
            $0.alpha = 1
        }
    }
}
