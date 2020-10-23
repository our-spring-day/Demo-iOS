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
        static let fullViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.55
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height * 0.8}
    }
}

class BottomSheetViewController: UIView {
    var standardY = CGFloat(0)
    var collectionView = MannaCollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 200))
    var backgroundView = UIView()
    var zoomIn = UIButton()
    var zoomOut = UIButton()
    var myLocation = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
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
        if yPosition == Constant.partialViewYPosition {
            self.alpha = 0.2
        } else {
            self.alpha = 0.8
        }
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
            $0.backgroundColor = .none
        }
        backgroundView.do {
            $0.backgroundColor = .gray
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.addGestureRecognizer(gesture)
        }
        zoomIn.do {
            $0.backgroundColor = .gray
            $0.setTitle("+", for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
        zoomOut.do {
            $0.backgroundColor = .gray
            $0.setTitle("-", for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
        myLocation.do {
            $0.backgroundColor = .gray
            $0.setTitle("o", for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
    }
    
    func layout() {
        addSubview(backgroundView)
        backgroundView.addSubview(collectionView)
        addSubview(zoomIn)
        addSubview(zoomOut)
        addSubview(myLocation)
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(20)
            $0.centerX.equalTo(snp.centerX)
        }
        zoomIn.snp.makeConstraints {
            $0.bottom.equalTo(backgroundView.snp.top).offset(-20)
            $0.leading.equalTo(snp.leading).offset(15)
            $0.width.height.equalTo(30)
        }
        zoomOut.snp.makeConstraints {
            $0.bottom.equalTo(backgroundView.snp.top).offset(-20)
            $0.leading.equalTo(zoomIn.snp.trailing).offset(15)
            $0.width.height.equalTo(30)
        }
        myLocation.snp.makeConstraints {
            $0.bottom.equalTo(backgroundView.snp.top).offset(-20)
            $0.trailing.equalTo(snp.trailing).offset(-15)
            $0.width.height.equalTo(30)
        }
    }
}
