//
//  chatViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit

class ChatViewController: UIViewController {
    var backgroundView = UIView()
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var contentLabel = UILabel()
    var paragraphStyle = NSMutableParagraphStyle()
    let transitionManager = SomeTransitionManager()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMessage))
    
    @objc func tapMessage() {
        backgroundView.alpha = 0.5
        UIView.animate(withDuration: 0, delay: 0.5) {
            self.backgroundView.alpha = 1
        }
        let newView = tempViewController()
        newView.transitioningDelegate = self
        present(newView, animated: true)
    }
    func attribute() {
        
        backgroundView.do {
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.backgroundColor = .red
            $0.addGestureRecognizer(tapGesture)
            $0.isUserInteractionEnabled = true
        }
        profileImageView.do {
            $0.image = #imageLiteral(resourceName: "boddle")
        }
        nameLabel.do {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 14)
            $0.textColor = .black
            paragraphStyle.lineHeightMultiple = 0.99
            $0.attributedText = NSMutableAttributedString(string: "재인", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
        contentLabel.do {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 14)
            $0.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            paragraphStyle.lineHeightMultiple = 0.94
            $0.attributedText = NSMutableAttributedString(string: "이번주 토요일 더포도 스터디룸 빌렸어요~\n늦지말고 오세요~👀 1시부터 4시까지 어쩌...", attributes: [NSAttributedString.Key.kern: -0.3, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        
        [backgroundView].forEach {view.addSubview($0)}
        [profileImageView, nameLabel, contentLabel].forEach { backgroundView.addSubview($0) }
        
        view.backgroundColor = .none
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(view).offset(MannaDemo.convertHeigt(value: 26.63))
            $0.width.equalTo(view).offset(-20)
            $0.height.equalTo(100)
            $0.centerX.equalTo(view)
        }
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalTo(view).offset(MannaDemo.convertWidth(value: 32.63 * 1.333))
            $0.leading.equalTo(view).offset(MannaDemo.convertWidth(value: 21 * 1.333))
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view).offset(MannaDemo.convertWidth(value: 27 * 1.333))
            $0.leading.equalTo(profileImageView.snp.trailing).offset(MannaDemo.convertWidth(value: 14 * 1.333))
            $0.width.equalTo(MannaDemo.convertWidth(value: 252))
            $0.height.equalTo(MannaDemo.convertWidth(value: 22))
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(MannaDemo.convertWidth(value: 14 * 1.333))
            $0.width.equalTo(MannaDemo.convertWidth(value: 252))
            $0.height.equalTo(MannaDemo.convertWidth(value: 50))
        }
        print(backgroundView.bounds)
    }
}
extension ChatViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //return nil 이면 기본 present
        //transitioning 객체가 들어있다면 그 친구를 애니메이션 객체로 사용한다 뭐 그런 느낌
        return transitionManager
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transitionManager.presenting = false
        return nil
    }
}

class  SomeTransitionManager : UIPercentDrivenInteractiveTransition , UIViewControllerAnimatedTransitioning {
    var duration2 = 0.8
    var presenting = true
    var originFrame = CGRect.zero
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return nil
        }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return self
        }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration2
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //여기서는 현재뷰컨과 들어올 뷰컨 둘다 접근 가능함
        let containerView = transitionContext.containerView
        originFrame = (transitionContext.viewController(forKey: .from) as! test).chatView!.frame
        print(originFrame)
        originFrame.origin.y = originFrame.origin.y + UIScreen.main.bounds.height * 0.64
        //to View 는 띄워질 뷰컨의 뷰
        //to View = UIDropShadowView
        let toView = transitionContext.view(forKey: .to)!
        //recipeView = toView
        let recipeView = presenting ? toView : transitionContext.view(forKey: .from)!
        //initialFrame = originFrame
        let initialFrame = presenting ? originFrame : recipeView.frame
        //finalFrame = recipeView.frame
        let finalFrame = presenting ? recipeView.frame : originFrame
        let xScaleFactor = presenting ?
            (initialFrame.width) / finalFrame.width :
          finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
          finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if presenting {
          recipeView.transform = scaleTransform

          recipeView.center = CGPoint(
            x: initialFrame.midX,
            y: initialFrame.midY)
            
          recipeView.clipsToBounds = true
        }
        recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
        recipeView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(recipeView)

        UIView.animate(
          withDuration: duration2,
          delay:0.0,
          usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
          animations: {
            recipeView.transform = self.presenting ? .identity : scaleTransform
            recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
          },completion: { retult in
            transitionContext.completeTransition(retult)
          }
        )
    }
}


