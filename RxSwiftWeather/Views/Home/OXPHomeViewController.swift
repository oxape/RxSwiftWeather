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

class OXPHomeViewController: OXPBaseViewController {

    let scrollView = UIScrollView()
    let weatherContainer = UIView()
    let weatherIcon = UIImageView()
    let weatherLabel = UILabel()
    let temperatureLabel = UILabel()
    let backgroundImageView = UIImageView()
    
    let viewModel = OXPWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
    }

    override func createViews() {
        let superView = self.view!
        scrollView.backgroundColor = UIColor.white
        superView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.right.left.equalTo(superView)
            maker.top.equalTo(self.view.snp.top)
            maker.bottom.equalTo(self.view.snp.bottom)
        }
        
        if let backgroundImage = UIImage(named: "testbackground") {
            let blurImage = backgroundImage.maskedVariableBlur(radius: 5)
            backgroundImageView.image = blurImage
            scrollView.addSubview(backgroundImageView)
            //        backgroundImageView.isHidden = true;
            backgroundImageView.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview()
                maker.left.right.equalTo(superView)
                maker.height.equalTo(backgroundImageView.snp.width).multipliedBy(backgroundImage.size.height/backgroundImage.size.width)
                maker.bottom.equalToSuperview()
            }
            scrollView.backgroundColor = blurImage!.averageColorInRect(CGRect(x: 0, y: 100, width: backgroundImage.size.width, height: 1))
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
        scrollView.dg_setPullToRefreshBackgroundColor(scrollView.backgroundColor!)
    }
    
    override func createEvent() {
        viewModel.weather.drive(weatherLabel.rx.text).addDisposableTo(self.disposeBag)
        viewModel.weatherImage.drive(weatherIcon.rx.image).addDisposableTo(self.disposeBag)
        viewModel.temperature.drive(temperatureLabel.rx.text).addDisposableTo(self.disposeBag)
        viewModel
            .activityIndicator
            .distinctUntilChanged()
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible).addDisposableTo(self.disposeBag)
        viewModel.cityName.drive(self.rx.title).addDisposableTo(self.disposeBag)
        
        viewModel.refresh()
    }
    
    deinit {
        scrollView.dg_removePullToRefresh()
    }
}
