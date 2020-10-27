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
        case half
        case full
    }
    private enum Constant {
        static let halfViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.55
        static let partialViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.8
        static let fullViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.3 
    }
}

class BottomSheetViewController: UIView {
    var standardY = CGFloat(0)
    var collectionView = MannaCollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 200))
    var backgroundView = UIImageView()
    var bar = UIImageView()
    var zoomIn = UIButton()
    var zoomOut = UIButton()
    var myLocation = UIButton()
    var expectArrived = UILabel()
    var remainingTimeLabel = UILabel()
    var remmainingTime = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.halfViewYPosition
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
        if (minY + translation.y >= Constant.halfViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
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
                                .partial : .half
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
        expectArrived.do {
            $0.text = "예상 도착 순위"
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 17)
            $0.textColor = .black
        }
        bar.do {
            $0.image = #imageLiteral(resourceName: "bottomsheetbar")
        }
        backgroundView.do {
            $0.image = #imageLiteral(resourceName: "bottomsheet")
            $0.addGestureRecognizer(gesture)
            $0.isUserInteractionEnabled = true
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
        remainingTimeLabel.do {
            $0.text = "남은 시간"
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 12)
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            $0.attributedText = NSMutableAttributedString(string: "남은시간", attributes: [NSAttributedString.Key.kern: -1])
        }
        remmainingTime.do {
            $0.text = "50:12"
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 17)
            $0.textColor = UIColor(named: "keyColor")
        }
    }
    
    func layout() {
        [zoomIn, zoomOut, myLocation, backgroundView].forEach { addSubview($0) }
        [collectionView, bar, expectArrived, remainingTimeLabel, remmainingTime].forEach { backgroundView.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.bottom.equalToSuperview()
        }
//
//        view.widthAnchor.constraint(equalToConstant: 95).isActive = true
//
//        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 25.11).isActive = true
//
//        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 120.24).isActive = true
        expectArrived.snp.makeConstraints {
            
            $0.top.equalTo(backgroundView).offset(MannaDemo.convertHeigt(value: 33.68))
            $0.leading.equalTo(backgroundView).offset(MannaDemo.convertWidth(value: 25.11))
            
            $0.width.equalTo(MannaDemo.convertWidth(value: 95))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 25))
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(expectArrived.snp.bottom).offset(MannaDemo.convertHeigt(value: 22.26))
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
        bar.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(11.5)
            $0.centerX.equalTo(self)
            $0.width.equalTo(MannaDemo.convertWidth(value: 60))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 2.99))
        }
        remainingTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(expectArrived.snp.centerY)
            $0.trailing.equalTo(backgroundView.snp.trailing).offset(-MannaDemo.convertWidth(value: 72.75))
            $0.width.equalTo(MannaDemo.convertWidth(value: 55))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 20))
        }
        remmainingTime.snp.makeConstraints {
            $0.centerY.equalTo(expectArrived.snp.centerY)
            $0.leading.equalTo(remainingTimeLabel.snp.trailing).offset(MannaDemo.convertWidth(value: 2.06))
            $0.width.equalTo(MannaDemo.convertWidth(value: 47))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 25))
        }
    }
}
