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
    
    var chatView = UITableView()
    let bottomView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    }
    
    static let shared = ChattingViewController()
    var keyboardShown:Bool = true
    var messageInput = ChatMessageView()
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var chatMessage: [ChatMessage] = []
    
    var textField = UITextField()
    
    lazy var sendButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                 width: MannaDemo.convertWidth(value: 17),
                                                 height: MannaDemo.convertHeight(value: 17)))
        .then {
            $0.setImage(UIImage(named: "good"), for: .normal)
        }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        keyboardShow()
        attirbute()
        layout()
    }
    
    // MARK: viewWillDisappear removeObserver
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    
    func keyboardShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keykey), name: NSNotification.Name(rawValue: UIResponder.keyboardWillChangeFrameNotification.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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
            .drive(onNext: { [weak self] keyboradHeight in
                print(keyboradHeight)
            })
    }

    
    func attirbute() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        self.do {
            $0.title = "설정"
            $0.view.backgroundColor = .white
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
        textField.do {
            $0.delegate = self
            $0.textColor = .black
            $0.attributedPlaceholder = .init(string: "메세지 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.chatName)])
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
            $0.backgroundColor = .white
            $0.addLeftPadding()
        }
        sendButton.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: chatView Layout
    func layout() {
        view.addSubview(chatView)
        view.addSubview(bottomView)
        bottomView.addSubview(textField)
        bottomView.addSubview(sendButton)
        
        chatView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(142)
            $0.top.equalTo(chatView.snp.bottom)
        }
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(13)
            $0.trailing.equalToSuperview().offset(-58)
            $0.width.equalTo(300)
            $0.height.equalTo(35)
        }
        sendButton.snp.makeConstraints {
            $0.centerY.equalTo(textField.snp.centerY)
            $0.leading.equalTo(textField.snp.trailing).offset(15)
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
    }
    
    @objc func keykey(sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print("키보드 높이 : ",keyboardHeight)
    }
    
    @objc func keyboardWillShow(sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let constraintHeight = (keyboardHeight + 48)
        
        UIView.animate(withDuration: 4) {
            self.bottomView.snp.updateConstraints {
                $0.height.equalTo(constraintHeight)
                self.scrollBottom()
            }
            
            self.bottomView.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(sender: Notification) {

        UIView.animate(withDuration: 4) {
            self.bottomView.snp.updateConstraints {
                $0.height.equalTo(142)
            }
            self.bottomView.layoutIfNeeded()
        }
        
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
    }
    
    // MARK: EditingChanged TextField
    @objc func textFieldDidChange() {
        let textCount = textField.text?.count
        
        guard let count = textCount else { return }
        
        if count > 0 {
            sendButton.backgroundColor = UIColor.appColor(.sendMessage)
        } else {
            sendButton.backgroundColor = UIColor.appColor(.messageSendButton)
        }
        chatView.reloadData()
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
        self.textField.endEditing(true)
    }
}

extension ChattingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.endEditing(true)
    }
}


extension ChattingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleHeight = self.frame.map { UIScreen.main.bounds.height - $0.origin.y }

    }
}
