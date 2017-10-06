//
//  OXPMenuViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/25.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxRealm

class OXPMenuViewController: OXPBaseViewController {

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.1, alpha: 1)
    }

    override func setupViews() {
        super.setupViews()
        
        let superView = self.view!
        superView.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(64)
            maker.left.right.bottom.equalTo(superView)
        }
        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func bindEvents() {
        super.bindEvents()
        
        guard let realm = try? Realm() else {
            return
        }
        let models = realm.objects(OXPThinkpageCityModel.self)
        Observable.collection(from: models).bindTo(tableView.rx.items(cellIdentifier: "Cell")) {
            (index, model, cell) in
            cell.textLabel?.text = model.zhName
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor.white
        }.addDisposableTo(self.disposeBag)
        tableView.rx.itemDeleted.map({
            (indexPath) in
            let model = realm.objects(OXPThinkpageCityModel.self)[indexPath.row]
            return model
        }).do(onNext: {
            _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateCities"), object: nil)
            })
        }).subscribe(realm.rx.delete()).addDisposableTo(self.disposeBag)
    }
}
