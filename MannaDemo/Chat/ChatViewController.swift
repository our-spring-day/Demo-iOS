//
//  ChatViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import UIKit

class ChatViewController: UIViewController {
    var messageInput = ChatMessageView()
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    let chatView = UITableView()
    
    var chatMessage: [ChatMessage] =
        [ChatMessage(user: "짱구", text: "이번주 토요일 더포도 스터디룸 빌렸어요 늦지말고 오세요~👀 1시부터 4시까지 입니다. 어쩌구저쩌구 세줄~~세줄~~세줄~~", isIncoming: true, sendState: false),
         ChatMessage(user: "짱구", text: "늦으면 벌금 오천만원임니다~~😉", isIncoming: true, sendState: false),
         ChatMessage(user: "영희", text: "알겠슴니다~~🙀", isIncoming: false, sendState: false),
         ChatMessage(user: "영희", text: "우리는 오늘 부자전에 가서 전이랑 제육볶음이랑 오지게 처묵처묵 할껀데 님들은 오실마실??", isIncoming: false, sendState: false),
         ChatMessage(user: "기영", text: "야야야 자냐?? 일어나 새키얌", isIncoming: true, sendState: false),
         ChatMessage(user: "기영", text: "에~이 그건 아니지 에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지", isIncoming: true, sendState: false),
         ChatMessage(user: "찬이", text: "새키얌", isIncoming: true, sendState: false),
         ChatMessage(user: "찬이", text: "우리는 오늘 부자전에 가서 전이랑 제육볶음이랑 오지게 처묵처묵 할껀데 님들은 오실마실??", isIncoming: true, sendState: false),
         ChatMessage(user: "상원", text: "에~이 그건 아니지 에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지", isIncoming: false, sendState: false),
         ChatMessage(user: "상원", text: "우리는 오늘 부자전에 가서 전이랑 제육볶음이랑 오지게 처묵처묵 할껀데 님들은 오실마실??", isIncoming: false, sendState: false),
         ChatMessage(user: "돼지", text: "야야야 자냐?? 일어나 새키얌", isIncoming: true, sendState: false),
         ChatMessage(user: "돼지", text: "에~이 그건 아니지 에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지", isIncoming: true, sendState: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messageInput.textInput.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        attirbute()
        layout()
        scrollBottom()
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
            $0.contentInset = insets
        }
        messageInput.sendButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        messageInput.textInput.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    @objc func test() {
        chatView.reloadData()
    }
    func layout() {
        view.addSubview(chatView)
        view.addSubview(messageInput)
        chatView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }
        messageInput.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertHeigt(value: 51)).isActive = true
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
        let textCount = messageInput.textInput.text?.count
        
        guard let count = textCount else { return }
        
        if count > 0 {
            messageInput.sendButton.backgroundColor = UIColor.appColor(.sendMessage)
        } else {
            messageInput.sendButton.backgroundColor = UIColor.appColor(.messageSendButton)
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatView.dequeueReusableCell(withIdentifier: ChatCell.cellID, for: indexPath) as! ChatCell
    
        cell.selectionStyle = .none
        var message = chatMessage[indexPath.row]
        cell.message.text = message.text
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
        
        return cell
    }
    
    func scrollBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatMessage.count - 1, section: 0)
            self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}

extension ChatViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -245
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}


extension ChatViewController {
    enum State {
        case show
        case hide
        
    }
    enum Constant {
        static let hideYPosition: CGFloat = UIScreen.main.bounds.height * 0.5
        static let showViewYPosition: CGFloat = UIScreen.main.bounds.height * 0.85
    }
    
    private func moveView(state: State) {
        
        var YPosition: CGFloat?
        switch state {
        case .show:
            YPosition = Constant.showViewYPosition
            break
        case .hide:
            YPosition = Constant.hideYPosition
            break
        }
        
        self.view.frame = CGRect(x: 0,
                            y: YPosition!,
                            width: self.view.frame.width,
                            height: self.view.frame.height)
    }
    
//    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.chatView)
//        let minY = self.chatView.frame.minY
//        if (minY + translation.y >= Constant.halfViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
//            self.view.frame = CGRect(x: 0,
//                                y: minY,
//                                width: self.view.frame.width,
//                                height: self.view.frame.height)
//            recognizer.setTranslation(CGPoint.zero, in: self.view)
//        }
//    }
}
