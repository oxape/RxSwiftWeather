//
//  OXPRootViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/5.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class OXPRootViewController: OXPSideMenu {
    let bag = DisposeBag()
    override var menuShow: Bool {
        didSet {
            let tabBarCtl = self.contentViewController as! OXPTabBarController
            tabBarCtl.panEnable = !menuShow
        }
    }
    var screenEdgePanEnable: Bool {
        return false
    }
    let containerTransitionDelegate =  OXPContainerViewControllerDelegateImp()
    
    override init() {
        let menuViewCtl = OXPMenuViewController()
        let homeViewCtl = OXPBaseNavViewController(rootViewController: OXPHomeViewController())
        var viewCtls = [homeViewCtl]
        
        if let ream = try? Realm() {
            let cities = ream.objects(OXPThinkpageCityModel.self)
            for cityModel in cities {
                let cityViewCtl = OXPHomeViewController()
                cityViewCtl.cityName = cityModel.cityID
                cityViewCtl.cityShowName = cityModel.zhName
                viewCtls.append(OXPBaseNavViewController(rootViewController: cityViewCtl))
            }
        }
        super.init()
        self.menuViewController = menuViewCtl
        let contentViewCtl = TabBarController(viewControllers: viewCtls)
        contentViewCtl.containerTransitionDelegate = containerTransitionDelegate
        self.contentViewController = contentViewCtl
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "UpdateCities")).subscribe(onNext:{
            _ in
            let homeViewCtl = OXPBaseNavViewController(rootViewController: OXPHomeViewController())
            var viewCtls = [homeViewCtl]
            
            if let ream = try? Realm() {
                let cities = ream.objects(OXPThinkpageCityModel.self)
                for cityModel in cities {
                    let cityViewCtl = OXPHomeViewController()
                    cityViewCtl.cityName = cityModel.cityID
                    cityViewCtl.cityShowName = cityModel.zhName
                    viewCtls.append(OXPBaseNavViewController(rootViewController: cityViewCtl))
                }
            }
            let contentViewCtl = TabBarController(viewControllers: viewCtls)
            contentViewCtl.containerTransitionDelegate = self.containerTransitionDelegate
            self.contentViewController = contentViewCtl
        }).addDisposableTo(self.bag)
    }
}

fileprivate class TabBarController: OXPTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panEnable = !(self.sideMenu?.menuShow ?? false)
    }
}
