//
//  ChatViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import UIKit

class ChatViewController: UIViewController {
    let chatView = UITableView()
    var chatMessage: [ChatMessage] =
        [ChatMessage(user: "짱구", text: "새키얌", isIncoming: true, sendState: false),
         ChatMessage(user: "짱구", text: "우리는 오늘 부자전에 가서 전이랑 제육볶음이랑 오지게 처묵처묵 할껀데 님들은 오실마실??", isIncoming: true, sendState: false),
         ChatMessage(user: "영희", text: "에~이 그건 아니지 에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지", isIncoming: false, sendState: false),
         ChatMessage(user: "영희", text: "우리는 오늘 부자전에 가서 전이랑 제육볶음이랑 오지게 처묵처묵 할껀데 님들은 오실마실??", isIncoming: false, sendState: false),
         ChatMessage(user: "기영", text: "야야야 자냐?? 일어나 새키얌", isIncoming: true, sendState: false),
         ChatMessage(user: "기영", text: "에~이 그건 아니지 에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지", isIncoming: true, sendState: false),
         ChatMessage(user: "찬이", text: "새키얌", isIncoming: true, sendState: false),
         ChatMessage(user: "찬이", text: "우리는 오늘 부자전에 가서 전이랑 제육볶음이랑 오지게 처묵처묵 할껀데 님들은 오실마실??", isIncoming: true, sendState: false),
         ChatMessage(user: "돼지", text: "에~이 그건 아니지 에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지", isIncoming: false, sendState: false),
         ChatMessage(user: "돼지", text: "우리는 오늘 부자전에 가서 전이랑 제육볶음이랑 오지게 처묵처묵 할껀데 님들은 오실마실??", isIncoming: false, sendState: false),
         ChatMessage(user: "돼지", text: "야야야 자냐?? 일어나 새키얌", isIncoming: true, sendState: false),
         ChatMessage(user: "돼지", text: "에~이 그건 아니지 에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지에~이 그건 아니지", isIncoming: true, sendState: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        attirbute()
        layout()
    }
    
    func attirbute() {
        chatView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ChatCell.self, forCellReuseIdentifier: ChatCell.cellID)
            $0.separatorStyle = .none
            $0.backgroundColor = .white
        }
    }
    
    func layout() {
        view.addSubview(chatView)
        chatView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
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
}
