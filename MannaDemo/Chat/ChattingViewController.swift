//
//  ChatViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import UIKit
import SnapKit
import RxKeyboard
import RxSwift
import RxCocoa

protocol chattingView: UIViewController {
    var chatMessage: [ChatMessage] { get set }
    var chatView: UITableView { get set }
    var textField: UITextField { get set }
    var sendButton: UIButton { get set }
    func scrollBottom()
}

class ChattingViewController: UIViewController, chattingView {
    let disposeBag = DisposeBag()
    
    private var didSetupViewConstraints = false
    static let shared = ChattingViewController()
    var chatView = UITableView()
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var chatMessage: [ChatMessage] = []
    
    var textField = UITextField()
    let inputBar = InputBar()
    let background = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    }
    lazy var sendButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                 width: MannaDemo.convertWidth(value: 17),
                                                 height: MannaDemo.convertHeight(value: 17)))
        .then {
            $0.setImage(UIImage(named: "good"), for: .normal)
        }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardShow()
        attirbute()
        layout()
        bind()
        scrollBottom()
    }
    
    // MARK: viewWillDisappear removeObserver
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func keyboardShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func scrollBottom() {
        if chatMessage.count != 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessage.count - 1, section: 0)
                self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func scrollLastIndex(index: Int) {
        if chatMessage.count != 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                UIView.animate(withDuration: 4, delay: 3) {
                    self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    func bind() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let `self` = self, self.didSetupViewConstraints else { return }
                print("keyboardVisibleHeight111",keyboardVisibleHeight)
                if keyboardVisibleHeight > 83 {
                    self.inputBar.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.snp.bottom).offset(-keyboardVisibleHeight)
                    }
                }
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    self.chatView.contentInset.bottom = keyboardVisibleHeight
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.willShowVisibleHeight
          .drive(onNext: { keyboardVisibleHeight in
            self.chatView.contentOffset.y += (keyboardVisibleHeight - 83)
          })
          .disposed(by: self.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        if self.chatView.contentInset.bottom == 0 {
          self.chatView.contentInset.bottom = self.inputBar.frame.height * 2
        }
    }

    
    func attirbute() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        self.do {
            $0.title = "설정"
            $0.view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
            $0.navigationController?.navigationBar.standardAppearance = appearance
        }
        
        chatView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ChatCell.self, forCellReuseIdentifier: ChatCell.cellID)
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.bounces = false
            $0.keyboardDismissMode = .interactive
        }
        inputBar.do {
            $0.textView.delegate = self
        }
    }
    
    // MARK: chatView Layout
    func layout() {
        guard !self.didSetupViewConstraints else { return }
        self.didSetupViewConstraints = true

        self.view.addSubview(self.chatView)
        self.view.addSubview(self.inputBar)
        self.view.addSubview(self.background)
        
        self.chatView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        self.inputBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(0)
            $0.bottom.equalTo(view.snp.bottom).offset(-90)
        }
        self.background.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(0)
            $0.top.equalTo(self.inputBar.snp.top).offset(-3)
        }
        self.view.bringSubviewToFront(inputBar)
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        UIView.animate(withDuration: 0) {
            self.inputBar.snp.updateConstraints {
                $0.bottom.equalTo(self.view.snp.bottom).offset(-90)
            }
            self.chatView.contentOffset.y -= (291 - 90)
            
            self.view.layoutIfNeeded()
        }
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatView.dequeueReusableCell(withIdentifier: ChatCell.cellID, for: indexPath) as! ChatCell
        cell.selectionStyle = .none
        var message = chatMessage[indexPath.row]
        if indexPath.row > 0 {
            // 이전 User, 현재 User 같으면
            // message.sendState 상태 true
            if message.user == chatMessage[indexPath.row - 1].user {
                message.sendState = true
            }
            // 이전 User, 현재 User 다르면
            else {
                message.sendState = false
            }
        }
     
        cell.chatMessage = message
        
        var nextUser: String?
        var nextDate: Date?
        var nextHour: String?
        var nextMinute: String?
        
        let hourFormatter = DateFormatter()
        let minuteFormatter = DateFormatter()
        
        hourFormatter.locale = Locale(identifier: "ko")
        minuteFormatter.locale = Locale(identifier: "ko")
        
        hourFormatter.dateFormat = "HH"
        minuteFormatter.dateFormat = "mm"
        
        let currentDate = Date(timeIntervalSince1970: TimeInterval(chatMessage[indexPath.row].timeStamp / 1000))
        let currentHour = hourFormatter.string(from: currentDate)
        let currentMinute = minuteFormatter.string(from: currentDate)
        
        if indexPath.row < chatMessage.count - 1 {
            nextUser = chatMessage[indexPath.row + 1].user
            nextDate = Date(timeIntervalSince1970: TimeInterval(chatMessage[indexPath.row + 1].timeStamp / 1000))
            nextHour = hourFormatter.string(from: nextDate!)
            nextMinute = minuteFormatter.string(from: nextDate!)
        }
        
        if let safeNextMan = nextUser, let safeNextHour = nextHour, let safeNextMinute = nextMinute {
            if chatMessage[indexPath.row].user == safeNextMan
                && "\(currentHour) : \(currentMinute)" == "\(safeNextHour) : \(safeNextMinute)" {
                cell.timeStamp.text = ""
            } else {
                if Int(currentHour)! >= 0 && Int(currentHour)! < 12 {
                    cell.timeStamp.text = chatMessage[indexPath.row].timeStamp.getTime()
                } else {
                    cell.timeStamp.text = chatMessage[indexPath.row].timeStamp.getTime()
                }
            }
        } else {
            if indexPath.row == chatMessage.count - 1 {
                if Int(currentHour)! >= 0 && Int(currentHour)! < 12 {
                    cell.timeStamp.text = chatMessage[indexPath.row].timeStamp.getTime()
                } else {
                    cell.timeStamp.text = chatMessage[indexPath.row].timeStamp.getTime()
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputBar.textView.resignFirstResponder()
    }
}

extension ChattingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.endEditing(true)
    }
}

extension ChattingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
