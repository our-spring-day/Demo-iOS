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
    var inputBar: InputBar { get set }
    var chatBottomState: Bool { get set }
    func scrollBottom()
    func viewLoadScrollBottom()
    var topBar: TopBar { get set }
    var bottomBar: BottomBar { get set }
}

class ChattingViewController: UIViewController, chattingView {
    let disposeBag = DisposeBag()
    
    var chatBottomState: Bool = true
    
    private var didSetupViewConstraints = false
    static let shared = ChattingViewController()
    var chatView = UITableView()
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var tempHeight: CGFloat?
    var chatMessage: [ChatMessage] = []
    var maxY: CGFloat = 0
    var inputBar = InputBar().then {
        $0.backgroundColor = .red
    }
    var scrollButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40)).then {
        $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        $0.setImage(UIImage(named: "bottom"), for: .normal)
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize.zero
        $0.isHidden = true
        $0.addTarget(self, action: #selector(scrollBottom), for: .touchUpInside)
    }
    let background = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    }
    lazy var sendButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                 width: MannaDemo.convertWidth(value: 17),
                                                 height: MannaDemo.convertHeight(value: 17)))
        .then {
            $0.setImage(UIImage(named: "good"), for: .normal)
            $0.addTarget(self, action: #selector(scrollBottom), for: .touchUpInside)
        }
    var topBar = TopBar()
    var bottomBar = BottomBar()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        attirbute()
        layout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadScrollBottom()
    }
    
    @objc func scrollBottom() {
        if chatMessage.count != 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessage.count - 1, section: 0)
                self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            scrollButton.isHidden = true
        }
    }
    
    func viewLoadScrollBottom() {
        if chatMessage.count != 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessage.count - 1, section: 0)
                self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
            scrollButton.isHidden = true
        }
    }
    
    // MARK: RxKeyboard bind
    
    func bind() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let `self` = self else { return }
                if keyboardVisibleHeight > 90 {
                    self.inputBar.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.snp.bottom).offset(-keyboardVisibleHeight)
                    }
                }
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { keyboardVisibleHeight in
                self.chatView.contentOffset.y += (keyboardVisibleHeight - 95)
            })
            
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.isHidden
            .filter { $0 == true }
            .drive(onNext: { ishiddn in
                UIView.animate(withDuration: 0) {
                    self.inputBar.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.snp.bottom).offset(-90)
                    }
                    self.chatView.contentOffset.y -= (291 - 95)
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: chatView Attribute
    
    func attirbute() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        self.do {
            $0.title = "설정"
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
        topBar.do {
            $0.alpha = 0.85
            $0.backgroundColor = .white
            $0.dismissButton.addTarget(self, action: #selector(didClickedDismissButton), for: .touchUpInside)
            $0.dismissButton.tag = 1
            $0.title.text = "채팅"
        }
        bottomBar.do {
            $0.chatButton.backgroundColor = UIColor(named: "buttonbackgroundgray")
            $0.chatButton.addTarget(self, action: #selector(didClickedDismissButton), for: .touchUpInside)
            $0.chatButton.tag = 1
        }
    }
    
    // MARK: DISMISS ACTION
    @objc func didClickedDismissButton() {
        print("fd")
//        view.isHidden = true
    }
    // MARK: chatView Layout
    func layout() {
        self.view.addSubview(self.chatView)
        self.view.addSubview(self.inputBar)
        self.view.addSubview(self.background)
        self.view.addSubview(self.scrollButton)
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.bottomBar)
        
        self.chatView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(background.snp.top)
        }
        self.inputBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(0)
            $0.bottom.equalTo(view.snp.bottom).offset(-90)
        }
        self.background.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(0)
            $0.top.equalTo(self.inputBar.snp.top)
        }
        self.scrollButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(inputBar.snp.top).offset(-20)
        }
        self.bottomBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(0)
            $0.top.equalTo(inputBar.snp.bottom).offset(30)
        }
        self.topBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view)
            $0.height.equalTo(MannaDemo.convertWidth(value: 94))
        }
        self.view.bringSubviewToFront(inputBar)
        self.view.bringSubviewToFront(bottomBar)
    }
}


// MARK: Chat data setting

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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == chatMessage.count {
            print("do something")
            chatBottomState = true
        } else {
            print("not something")
            chatBottomState = false
        }
    }
}

extension ChattingViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        maxY = maxY < chatView.contentOffset.y ? chatView.contentOffset.y : maxY
        
        if maxY - chatView.contentOffset.y > 800 {
            scrollButton.isHidden = false
        } else {
            scrollButton.isHidden = true
        }
    }
}
