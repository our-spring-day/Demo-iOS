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
        static let partialViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.64
        static let fullViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.00
    }
}

class BottomSheetViewController: UIViewController {
    var parentView: UIView?
    var currentState: State = .half
    var standardY = CGFloat(0)
    var backgroundView = UIImageView()
    var bar = UIImageView()
    
    var chatViewController = ChatViewController()
    var runningTimeController = RunningTimeViewController()
    var rankingViewController = RankingViewViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
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
            self.view.alpha = 1
            break
        case .partial:
            YPosition = Constant.partialViewYPosition
            self.view.alpha = 1
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
            //            self.parentView?.isUserInteractionEnabled = false
            //            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2,
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
                            //                            self.view.isUserInteractionEnabled = true
                            //                            self.parentView?.isUserInteractionEnabled = true
                           }
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
        bar.do {
            $0.image = #imageLiteral(resourceName: "bottomsheetbar")
        }
        backgroundView.do {
            $0.image = #imageLiteral(resourceName: "bottomsheet")
            $0.addGestureRecognizer(gesture)
            $0.isUserInteractionEnabled = true
        }
    }
    
    func layout() {
        [backgroundView].forEach { view.addSubview($0) }
        [bar].forEach { backgroundView.addSubview($0) }
        
        [chatViewController, runningTimeController, rankingViewController].forEach {
            addChild($0)
            backgroundView.addSubview($0.view)
            $0.view.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalTo(backgroundView)
            }
            $0.didMove(toParent: self)
        }
        runningTimeController.view.isHidden = true
        chatViewController.view.isHidden = true
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        bar.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(11.5)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(MannaDemo.convertWidth(value: 60))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 5))
        }
    }
}
