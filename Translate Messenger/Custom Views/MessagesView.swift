//
//  MessagesView.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/24/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit

class MessagesView: BaseView {
    
    // MARK:- Properties
    
    var data: [Message] = [] {
        didSet {
            self.messagesTableView.reloadData()
        }
    }
    
    let reuseIdentifier = "MessagesCellId"
    lazy var messagesTableView: UITableView = {
        let tbv = UITableView()
        tbv.register(ChatCell.self, forCellReuseIdentifier: reuseIdentifier)
        tbv.estimatedRowHeight = 10
        tbv.delegate = self
        tbv.dataSource = self
        tbv.backgroundColor = .clear
        tbv.isScrollEnabled = true
        tbv.separatorStyle = .none
        tbv.allowsSelection = false
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()
    
    // MARK:- Setup
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        [messagesTableView].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [
            messagesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messagesTableView.topAnchor.constraint(equalTo: topAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
    
    // MARK:- Actions
    
    func addMessage(message: Message) {
        data.append(message)
        let lastCell = messagesTableView.cellForRow(at: IndexPath(row: data.count - 1, section: 0))
        if let lastCell = lastCell as? ChatCell {
            lastCell.animate()
        }
    }
    
    func scrollToBottom() {
        let contentOffsetY = messagesTableView.contentSize.height - messagesTableView.frame.height + messagesTableView.contentInset.bottom
        
        var offset: CGPoint!
        if contentOffsetY <= 0 {
            offset = CGPoint(x: 0.0, y: 0.0)
        } else {
            offset = CGPoint(x: 0.0, y: contentOffsetY)
        }
        messagesTableView.setContentOffset(offset, animated: true)
    }
    
}

extension MessagesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        cell.message = data[indexPath.row]
        return cell
    }
}
