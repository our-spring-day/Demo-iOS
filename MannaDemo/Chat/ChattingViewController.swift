//
//  ChatViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import UIKit

class ChattingViewController: UIViewController {
    static let shared = ChattingViewController()
    var keyboardShown:Bool = true
    var messageInput = ChatMessageView()
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let chatView = UITableView()
    var chatMessage: [ChatMessage] = []
    let textField = UITextField().then {
        $0.textColor = .black
        $0.attributedPlaceholder = .init(string: "메세지 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.chatName)])
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        $0.backgroundColor = .white
        $0.addLeftPadding()
    }
    lazy var sendButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                 width: MannaDemo.convertWidth(value: 40),
                                                 height: MannaDemo.convertHeight(value: 40)))
        .then {
            $0.setImage(UIImage(named: "finger"), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
            $0.backgroundColor = UIColor.appColor(.messageSendButton)
            $0.layer.cornerRadius = $0.frame.size.width/2
            $0.clipsToBounds = true
        }
    // MARK: inputAccessroyView init
    
    var accView: UIView!
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? {
        if accView == nil {
            accView = CustomView()
            accView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.845515839)
            textField.borderStyle = .roundedRect
            accView.addSubview(textField)
            accView.addSubview(sendButton)
            accView.autoresizingMask = .flexibleHeight
            
            textField.do {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.leadingAnchor.constraint(equalTo: accView.leadingAnchor, constant: MannaDemo.convertWidth(value: 13)).isActive = true
                $0.widthAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 304)).isActive = true
                $0.topAnchor.constraint(equalTo: accView.topAnchor).isActive = true
                $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertHeight(value: 43)).isActive = true
                $0.bottomAnchor.constraint(equalTo:accView.layoutMarginsGuide.bottomAnchor, constant: -3).isActive = true
            }
            sendButton.do {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10).isActive = true
                $0.topAnchor.constraint(equalTo: accView.topAnchor).isActive = true
                $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertHeight(value: 43)).isActive = true
                $0.bottomAnchor.constraint(equalTo:accView.layoutMarginsGuide.bottomAnchor, constant: -3).isActive = true
            }
        }
        return accView
    }
    
    // MARK: CustomView
    class CustomView: UIView {
        override var intrinsicContentSize: CGSize {
            return CGSize.zero
        }
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        attirbute()
        layout()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: viewWillDisappear removeObserver
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
            $0.keyboardDismissMode = .interactive
        }
        sendButton.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: chatView Layout
    func layout() {
        view.addSubview(chatView)
        chatView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MannaDemo.convertHeight(value: 43)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }
    }
    
    // MARK: TableView tap hide keyboard action
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        
        
        
        var compareDate: Date?
        var compareHour: String?
        var compareMinute: String?
        
        let hourFormatter = DateFormatter()
        let minuteFormatter = DateFormatter()
        
        hourFormatter.locale = Locale(identifier: "ko")
        minuteFormatter.locale = Locale(identifier: "ko")
        
        hourFormatter.dateFormat = "HH"
        minuteFormatter.dateFormat = "mm"
        
        if indexPath.row > 1 {
            compareDate = Date(timeIntervalSince1970: TimeInterval(chatMessage[indexPath.row - 1].timeStamp / 1000))
            compareHour = hourFormatter.string(from: compareDate!)
            compareMinute = minuteFormatter.string(from: compareDate!)
        }
        
        var currentDate = Date(timeIntervalSince1970: TimeInterval(chatMessage[indexPath.row].timeStamp / 1000))
        var currentHour = hourFormatter.string(from: currentDate)
        var currentMinute = minuteFormatter.string(from: currentDate)
        
        
        if let comparedhour = compareHour, let comparedMinute = compareMinute{
            if "\(currentHour) : \(currentMinute)" != "\(comparedhour) : \(comparedMinute)" {
                if Int(currentHour)! >= 0 && Int(currentHour)! < 12 {
                    cell.timeStamp.text = "오전 \(currentHour) : \(currentMinute)"
                } else {
                    
                    cell.timeStamp.text = "오후 \(Int(currentHour)! - 12) : \(currentMinute)"
                }
            } else {
                cell.timeStamp.text = ""
            }
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollBottom() {
        if ChattingViewController.shared.chatMessage.count != 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessage.count - 1, section: 0)
                self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}

extension ChattingViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(sender: Notification) {
        
        if keyboardShown == false {
            view.frame.origin.y = -(MannaDemo.convertHeight(value: 258))
            keyboardShown = true
        } else {
            keyboardShown = false
        }
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
