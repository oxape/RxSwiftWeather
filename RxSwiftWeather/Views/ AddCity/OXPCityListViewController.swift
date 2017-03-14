//
//  OXPCityListViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/12.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RealmSwift

class OXPCityListViewController: OXPBaseViewController {

    let tableView = UITableView()
    let searchBar = UISearchBar()
    let dataSource = RxTableViewSectionedAnimatedDataSource<OXPCitiesSectionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.titleView = searchBar
    }

    override func setupViews() {
        let superView = self.view!
        superView.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(superView)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            //TODO zhArea为""的处理,本地化处理
            cell.textLabel?.text = item.zhName+", "+item.zhArea+", "+item.country
            
            return cell
        }
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
    }
    
    override func bindEvents() {
         let results = searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest ({
                [weak self] query in
                return self!.queryCities(query: query).asDriver(onErrorJustReturn: [])
            }).map({ cities in
                [OXPCitiesSectionModel.init(items: cities)]
            }).observeOn(MainScheduler.instance)
        results.bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
    }
    //TODO 转换成ViewModel
    func queryCities(query: String) -> Observable<[OXPThinkpageCityModel]> {
        return Observable<[OXPThinkpageCityModel]>.create({
            observer in
            //TODO DispatchQueue.global(qos: .default).async
            if (!query.isEmpty) {
                let path = Bundle.main.bundlePath.appending("/thinkpagecities.realm")
                let realm = try! Realm.init(fileURL: URL(string: path)!)
                let predicate = NSPredicate(format: "zhName CONTAINS %@ or enName CONTAINS %@", query, query)
                let results = realm.objects(OXPThinkpageCityModel.self).filter(predicate)
                var cities:[OXPThinkpageCityModel] = []
                for city in results {
                    cities.append(city)
                }
                observer.onNext(cities)
                observer.onCompleted()
            } else {
                observer.onNext([])
                observer.onCompleted()
            }
            return Disposables.create();
        })
    }
}

extension OXPCityListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
