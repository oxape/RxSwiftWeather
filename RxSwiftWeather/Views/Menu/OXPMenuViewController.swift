//
//  OXPMenuViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/25.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPMenuViewController: OXPBaseViewController {

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
    }

    override func setupViews() {
        let superView = self.view!
        superView.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(superView)
        }
    }
}
