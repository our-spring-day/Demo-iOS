//
//  BottomSheetViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit
import SnapKit
import Lottie

extension BottomSheetViewController {
    enum State {
        case partial
        case half
        case full
    }
    enum Constant {
        static let halfViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.5
        static let partialViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.85
        static let fullViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.05
    }
}

class BottomSheetViewController: UIViewController {
    var currentState: State = .half
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
    var animationView = AnimationView(name:"12670-flying-airplane")
    var chatViewController = ChatViewController()
    var rankingViewController = RankingViewViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        lottieFunc()
    }
    
    func lottieFunc() {
        backgroundView.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(-10)
            $0.centerX.equalTo(backgroundView)
            $0.width.height.equalTo(75)
        }
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        //animationView.pause()
    }

    private func moveView(state: State) {
        
        var YPosition: CGFloat?
        switch state {
        case .full:
            YPosition = Constant.fullViewYPosition
            self.view.alpha = 1
            break
        case .half:
            YPosition = Constant.halfViewYPosition
            self.view.alpha = 0.9
            break
        case .partial:
            YPosition = Constant.partialViewYPosition
            self.view.alpha = 0.5
            break
        }
        
        self.view.frame = CGRect(x: 0,
                            y: YPosition!,
                            width: self.view.frame.width,
                            height: self.view.frame.height)
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let minY = self.view.frame.minY
        if (minY + translation.y >= Constant.halfViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            self.view.frame = CGRect(x: 0,
                                y: minY,
                                width: self.view.frame.width,
                                height: self.view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .began {
            //터치가 시작 될 때 거리를 저장
            standardY = recognizer.location(in: self.view).y
        } else if recognizer.state == .changed {
            //시작 될 때 저장한 거리만큼 떨어뜨려 움직임
            self.view.center.y = (self.view.center.y + recognizer.location(in: self.view).y) - standardY
            if view.frame.origin.y < Constant.fullViewYPosition {
                view.frame.origin.y = Constant.fullViewYPosition
            }
        } else if recognizer.state == .ended {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .allowUserInteraction,
                           animations: { [self] in
                            if self.view.frame.origin.y > Constant.halfViewYPosition {
                                currentState = recognizer.velocity(in: self.view).y >= 0 ?
                                    .partial : .half
                            } else {
                                currentState = recognizer.velocity(in: self.view).y >= 0 ?
                                    .half : .full
                            }
                            self.moveView(state: currentState)},
                           completion: { _ in
                            self.view.isUserInteractionEnabled = true }
            )
        }
    }
    
    func attribute() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        self.do {
            $0.view.layer.cornerRadius = 20
            $0.view.clipsToBounds = true
            $0.view.backgroundColor = .none
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
            $0.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
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
        [zoomIn, zoomOut, myLocation, backgroundView].forEach { view.addSubview($0) }
        [collectionView, bar, expectArrived, remainingTimeLabel, remmainingTime].forEach { backgroundView.addSubview($0) }
        
        addChild(chatViewController)
        backgroundView.addSubview(chatViewController.view)
        chatViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view)
        }
        chatViewController.didMove(toParent: self)
        
        
        addChild(rankingViewController)
        backgroundView.addSubview(rankingViewController.view)
        rankingViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view)
        }
        rankingViewController.didMove(toParent: self)
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        expectArrived.snp.makeConstraints {
            $0.top.equalTo(backgroundView).offset(MannaDemo.convertHeigt(value: 33.68))
            $0.leading.equalTo(backgroundView).offset(MannaDemo.convertWidth(value: 25.11))
            $0.width.equalTo(MannaDemo.convertWidth(value: 95))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 25))
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(expectArrived.snp.bottom).offset(MannaDemo.convertHeigt(value: 22.26))
            $0.centerX.equalTo(view.snp.centerX)
        }
        zoomIn.snp.makeConstraints {
            $0.bottom.equalTo(backgroundView.snp.top).offset(-20)
            $0.leading.equalTo(view.snp.leading).offset(15)
            $0.width.height.equalTo(40)
        }
        zoomOut.snp.makeConstraints {
            $0.bottom.equalTo(backgroundView.snp.top).offset(-20)
            $0.leading.equalTo(zoomIn.snp.trailing).offset(15)
            $0.width.height.equalTo(30)
        }
        myLocation.snp.makeConstraints {
            $0.bottom.equalTo(backgroundView.snp.top).offset(-20)
            $0.trailing.equalTo(view.snp.trailing).offset(-15)
            $0.width.height.equalTo(30)
        }
        bar.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(11.5)
            $0.centerX.equalTo(self.view)
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
