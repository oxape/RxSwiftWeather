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
    var searchResults:Observable<[OXPCitiesSectionModel]>? = nil
    var cityModels:[OXPThinkpageCityModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.showsCancelButton = true
        self.view.backgroundColor = UIColor.white
        self.navigationItem.titleView = searchBar
        searchBar.isTranslucent = true
        searchBar.backgroundColor = UIColor(white: 0.1, alpha: 1)
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: UIColor(white: 0.1, alpha: 1))
        let realm = try! Realm()
        let results = realm.objects(OXPThinkpageCityModel.self)
        for city in results {
            print(city.cityID + " " + city.zhName + " " + city.zhArea + " " + city.country)
        }
    }

    override func setupViews() {
        let superView = self.view!
        superView.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(superView)
        }
        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            //TODO zhArea为""的处理,本地化处理
            cell.textLabel?.text = item.zhName+", "+item.zhArea+", "+item.country
            cell.textLabel?.backgroundColor = UIColor.white
            return cell
        }
    }
    
    override func bindEvents() {
        searchBar.rx.textDidBeginEditing.subscribe({
            print($0)
        }).addDisposableTo(disposeBag)
        searchResults = searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest ({
                [weak self] query in
                return self!.queryCities(query: query).asDriver(onErrorJustReturn: [])
            }).do(onNext: {
                [weak self] cities in
                self?.cityModels = cities
            }).map({ cities in
                [OXPCitiesSectionModel.init(items: cities)]
            }).observeOn(MainScheduler.instance).shareReplay(1)
        searchResults!.bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        
        searchBar.rx.cancelButtonClicked.asDriver().drive(onNext: {
            [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).addDisposableTo(self.disposeBag)
        
        tableView.rx.itemSelected.map { (indexPath) -> OXPThinkpageCityModel? in
            self.cityModels?[indexPath.row]
            }.filter {$0 != nil}.subscribe(onNext: {
                (cityModel) in
                guard let realm = try? Realm() else {
                    return
                }
                try! realm.write {
                    realm.add(cityModel!.copy() as! Object, update: true)
                }
                self.searchBar.resignFirstResponder()
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateCities"), object: nil)
                }
            }).addDisposableTo(self.disposeBag)
    }
    //TODO 转换成ViewModel
    func queryCities(query: String) -> Observable<[OXPThinkpageCityModel]> {
        return Observable<[OXPThinkpageCityModel]>.create({
            observer in
            //TODO DispatchQueue.global(qos: .default).async
            if (!query.isEmpty) {
                let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let path = directory.appending("/thinkpagecities.realm")
                let realm = try! Realm(fileURL: URL(string: path)!)
                let predicate = NSPredicate(format: "zhName CONTAINS[c] %@ or enName CONTAINS[c] %@", query, query)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
