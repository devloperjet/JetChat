//
//  PGActionSheet.swift
//  PGActionSheet
//
//  Created by piggybear on 2017/10/2.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import UIKit

class PGActionSheet: BottomPopupViewController {
    
    // MARK: - Setter
    
    var textFont: UIFont? {
        didSet {
            guard let font = textFont else {
                return
            }
            
            titleFont = font
            tableView.reloadData()
        }
    }
    
    var cancelTextFont: UIFont? {
        didSet {
            guard let font = textFont else {
                return
            }
            
            cancelBtn.titleLabel?.font = font
        }
    }
    
    var textColor: UIColor? {
        didSet {
            guard let _ = textColor else {
                return
            }
        }
    }
    
    var cancelTextColor: UIColor? {
        didSet {
            guard let _ = textColor else {
                return
            }
        }
    }
    
    // MARK: - Private
    
    private let bottomSpace: CGFloat = 6
    private let cancelHeight: CGFloat = 44
    private let bottomSafeHeight: CGFloat = 34
    
    // MARK: - lazy var

    public var handler: ((_ index: Int)->Void)?
    
    private var titleFont: UIFont? = nil
    
    private var dataSource: [String] = []
    private var isShowCancel: Bool = true
    
    private var cellHeight: CGFloat {
        return 55
    }
    
    private var tableHeight: CGFloat {
        return CGFloat(dataSource.count) * cellHeight
    }
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: bottomSpace, width: kScreenW, height: cancelHeight)
        button.setTitle("取消".rLocalized(), for: .normal)
        button.titleLabel?.font = .PingFangRegular(14)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(dissAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerBtnView: UIView = {
        let height = bottomSpace + cancelHeight
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: height))
        footerView.backgroundColor = .colorWithHexStr("F7F7F7")
        footerView.addSubview(cancelBtn)
        return footerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: tableHeight))
        tableView.delegate = self
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor = .white
        tableView.register(cellWithClass: PGTableViewTitleCell.self)
        return tableView
    }()
    
    // MARK: - Life cycle
    
    required public init(isShowCancel: Bool = false, actionTitles: [String]) {
        self.dataSource = actionTitles
        self.isShowCancel = isShowCancel
        super.init(nibName: nil, bundle: nil)
        
        buildUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        view.backgroundColor = .white
        if isShowCancel {
            tableView.tableFooterView = footerBtnView
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.reloadData()
    }
    
    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    override var popupHeight: CGFloat { makePopHeight() }
    
    override var popupTopCornerRadius: CGFloat { return 8 }
    
    override var popupPresentDuration: Double { return 0.25 }
    
    override var popupDismissDuration: Double { return 0.25 }
    
    override var popupShouldDismissInteractivelty: Bool { return false }
    
    override var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }
    
    private func makePopHeight() -> CGFloat {
        if isShowCancel {
            return tableHeight + footerBtnView.height + bottomSafeHeight
        }else {
            return tableHeight + bottomSafeHeight
        }
    }
    
    // MARK: - Action
    
    @objc func dissAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource && UITableViewDelegate

extension PGActionSheet: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PGTableViewTitleCell.self)
        if dataSource.count > indexPath.row {
            cell.title = dataSource[safe: indexPath.row]
            cell.titleFont = titleFont
            if indexPath.row == dataSource.count - 1 {
                cell.hideLine = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            handler?(indexPath.row)
        }
        
        dissAction()
    }
}

