//
//  OXPHomeViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/8.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import SnapKit

class OXPHomeViewController: OXPBaseViewController {

    let scrollView = UIScrollView()
    let weatherContainer = UIView()
    let weatherIcon = UIImageView()
    let weatherLabel = UILabel()
    let temperatureLabel = UILabel()
    let viewModel = OXPWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGray
    }

    override func createViews() {
        
        let superView = self.view!
        superView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.right.left.equalTo(superView)
            maker.top.equalTo(self.view.snp.top)
            maker.bottom.equalTo(self.view.snp.bottom)
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
        
        let button = UIButton()
        button.backgroundColor = UIColor.brown
        scrollView.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            maker.height.equalTo(30)
            maker.left.right.equalToSuperview()
        }
        button.rx.tap.bindTo(viewModel.refreshAction).addDisposableTo(self.disposeBag)
    }
    
    override func createEvent() {
        viewModel.refreshAction.onNext(())
        viewModel.weather.drive(weatherLabel.rx.text).addDisposableTo(self.disposeBag)
        viewModel.weatherImage.drive(weatherIcon.rx.image).addDisposableTo(self.disposeBag)
        viewModel.temperature.drive(temperatureLabel.rx.text).addDisposableTo(self.disposeBag)
        viewModel
            .activityIndicator
            .distinctUntilChanged()
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible).addDisposableTo(self.disposeBag)
        viewModel.cityName.drive(self.rx.title).addDisposableTo(self.disposeBag)
    }
}
