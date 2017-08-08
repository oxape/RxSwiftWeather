//
//  OXPHomeViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/8.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import SnapKit
import DGElasticPullToRefresh
import FontAwesomeKit

class OXPHomeViewController: OXPBaseViewController {

    let scrollView = UIScrollView()
    let weatherContainer = UIView()
    let weatherIcon = UIImageView()
    let weatherLabel = UILabel()
    let temperatureLabel = UILabel()
    let contentView = UIView()
    
    let viewModel = OXPWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let plusIcon = FAKFontAwesome.plusIcon(withSize: 20)
        plusIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let rightBarItem = UIBarButtonItem.init(image: plusIcon?.image(with: CGSize(width: 22, height: 22)), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarItem
        rightBarItem.rx.tap.asDriver(onErrorJustReturn: ())
            .drive(onNext: {
            [weak self] in
            self?.present(UINavigationController.init(rootViewController: OXPCityListViewController()), animated: true, completion: nil)
        }).addDisposableTo(self.disposeBag)
        self.navigationController?.navigationBar.lt_setElementsAlpha(alpha: 0.6)
    }

    override func setupViews() {
        let superView = self.view!
        scrollView.backgroundColor = UIColor.clear
        superView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(scrollView.snp.top).offset(-64+1*(1/UIScreen.main.scale))
            maker.left.right.equalTo(scrollView)
            //状态栏高度为20导航栏高度为44
            maker.height.equalTo(self.view.bounds.size.height)
            maker.size.bottom.equalTo(scrollView)
        }
        
        if let backgroundImage = UIImage(named: "testbackground") {
            UIGraphicsBeginImageContext(self.view.bounds.size)
            UIImage(named: "testbackground")?.draw(in: self.view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            let color = backgroundImage.averageColorInRect(CGRect(x: 0, y: 100, width: backgroundImage.size.width, height: 1))
            
            self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: color.withAlphaComponent(0.8))
        }
        
        scrollView.addSubview(weatherContainer)
        weatherContainer.snp.makeConstraints { (maker) in
            maker.top.equalTo(scrollView.snp.top).offset(16)
            maker.left.equalTo(scrollView.snp.left).offset(16)
        }
        
        weatherContainer.addSubview(weatherIcon)
        weatherIcon.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.size.equalTo(CGSize(width: 40, height: 40))
            maker.bottom.lessThanOrEqualToSuperview()
        }
        
        weatherLabel.font = UIFont.systemFont(ofSize: 18)
        weatherLabel.textColor = UIColor.white
        weatherContainer.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(weatherIcon.snp.right).offset(16)
            maker.right.equalToSuperview()
            maker.centerY.equalTo(weatherIcon.snp.centerY)
            maker.bottom.lessThanOrEqualToSuperview()
        }
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 48)
        temperatureLabel.textColor = UIColor.white
        scrollView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(weatherContainer.snp.bottom).offset(0)
            maker.left.equalTo(weatherContainer)
        }
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        scrollView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.viewModel.refresh()
            self?.scrollView.dg_stopLoading()
            }, loadingView: loadingView)
        scrollView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        //这里为透明色所有才能出现现在的效果
        scrollView.dg_setPullToRefreshBackgroundColor(scrollView.backgroundColor!)
    }
    
    override func bindEvents() {
        viewModel.weather.drive(weatherLabel.rx.text).addDisposableTo(self.disposeBag)
        viewModel.weatherImage.drive(weatherIcon.rx.image).addDisposableTo(self.disposeBag)
        viewModel.temperature.drive(temperatureLabel.rx.text).addDisposableTo(self.disposeBag)
        viewModel
            .activityIndicator
            .distinctUntilChanged()
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .addDisposableTo(self.disposeBag)
        viewModel.cityName.drive(self.rx.title).addDisposableTo(self.disposeBag)
        
        viewModel.refresh()
    }
    
    deinit {
        scrollView.dg_removePullToRefresh()
    }
}
