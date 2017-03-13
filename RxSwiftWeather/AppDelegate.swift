//
//  AppDelegate.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/5.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
//        AppDelegate.importCitiesPlist2Database()
        
        window?.rootViewController = OXPRootViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    class func importCitiesPlist2Database() {
        let path = Bundle.main.bundlePath.appending("/ThinkpageCities.plist")
        guard let dict = NSDictionary.init(contentsOfFile: path) else {
            return
        }
        let version = dict["version"] as! String
        let directory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let filpath = directory!.appending("/thinkpagecities.realm")
        let realm = try! Realm(fileURL: URL(string: filpath)!)
        if let url = realm.configuration.fileURL {
            print(url)
        }
        if let tableVersion = realm.objects(OXPTableVersionModel.self).filter("name == 'ThinkpageCities'").first {
            if let result = OXPUtils.compareVersion(pversion: version, aversion: tableVersion.version) {
                if result == .orderedDescending {
                    let models = realm.objects(OXPThinkpageCityModel.self)
                    try! realm.write {
                        realm.delete(models)
                    }
                    importCities2Database(cities: dict["cities"] as! NSArray, realm: realm)
                }
            }
        } else {
            let models = realm.objects(OXPThinkpageCityModel.self)
            try! realm.write {
                realm.delete(models)
            }
            importCities2Database(cities: dict["cities"] as! NSArray, realm: realm)
        }
    }
    
    class func importCities2Database(cities: NSArray, realm: Realm) {
        for city in cities {
            let model = city as! NSDictionary
            let cityModel = OXPThinkpageCityModel()
            
            cityModel.cityID = model["code"] as! String
            cityModel.zhName = model["zh_name"]  as! String
            cityModel.enName = model["en_name"]  as! String
            cityModel.country = model["country"] as! String
            cityModel.zhArea = model["zh_area"] as! String
            cityModel.enArea = model["zh_area"] as! String
            try! realm.write {
                realm.add(cityModel)
            }
        }
    }
    
    func importTableVersion2Database(table: String, version: String, realm: Realm) {
        let versionMoel = OXPTableVersionModel()
        versionMoel.name = table
        versionMoel.version = version
        try! realm.write {
            realm.add(versionMoel)
        }
    }
}

