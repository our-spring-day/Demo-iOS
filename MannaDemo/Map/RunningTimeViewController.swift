//
//  RunningTimeViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit
import Lottie

class RunningTimeViewController: UIViewController {
    var expectArrived = UILabel()
    var collectionView = MannaCollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 200))
    var animationView = AnimationView(name:"12670-flying-airplane")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        lottieFunc()
    }
    
    func attribute() {
        expectArrived.do {
            $0.text = "예상 도착 순위"
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 17)
            $0.textColor = .black
        }
    }
    
    func layout() {
        [collectionView, expectArrived].forEach { view.addSubview($0) }
        
        expectArrived.snp.makeConstraints {
            $0.top.equalTo(view).offset(MannaDemo.convertHeigt(value: 33.68))
            $0.leading.equalTo(view).offset(MannaDemo.convertWidth(value: 25.11))
            $0.width.equalTo(MannaDemo.convertWidth(value: 95))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 25))
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(expectArrived.snp.bottom).offset(MannaDemo.convertHeigt(value: 22.26))
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func lottieFunc() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(-10)
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(75)
        }
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        //animationView.pause()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
