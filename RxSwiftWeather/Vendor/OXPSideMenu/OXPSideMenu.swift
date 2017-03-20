//
//  OXPSideMenu.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/20.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPSideMenu : UIViewController {
    fileprivate let menuViewContainer = UIView()
    fileprivate let contentViewContainer = UIView()
    fileprivate let animationDuration = 0.25
    fileprivate let menuOffsetInContentShow = CGFloat(60)
    var menuShow = false
    var menuViewController:UIViewController? {
        didSet {
            if oldValue != nil {
                self.hideViewController(viewController: oldValue!)
            }
            if menuViewController != nil {
                let menu = menuViewController!
                self.addChildViewController(menu)
                menuViewContainer.addSubview(menu.view)
                menu.view.frame = menuViewContainer.frame
                menu.view.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
                menu.didMove(toParentViewController: self)
            }
        }
    }
    var contentViewController:UIViewController? {
        didSet {
            if oldValue != nil {
                self.hideViewController(viewController: oldValue!)
            }
            if contentViewController != nil {
                let content = contentViewController!
                self.addChildViewController(content)
                contentViewContainer.addSubview(content.view)
                content.view.frame = menuViewContainer.frame
                content.view.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
                content.didMove(toParentViewController: self)
            }
        }
    }
    var constraints = Array<NSLayoutConstraint>()
    
    init() {
        //self init
        super.init(nibName: nil, bundle: nil)
        //custom init
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(menuViewContainer)
        self.view.addSubview(contentViewContainer)
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanGesture(recognizer:)))
        self.view.addGestureRecognizer(recognizer)
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints.removeAll()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[menu]|", options:[], metrics: nil, views: ["menu": menuViewContainer]))
        constraints.append(NSLayoutConstraint.init(item: menuViewContainer, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint.init(item: menuViewContainer, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -menuOffsetInContentShow))
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[content]|", options:[], metrics: nil, views: ["content": contentViewContainer]))
        constraints.append(NSLayoutConstraint.init(item: contentViewContainer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0))
        if (menuShow) {
            constraints.append(NSLayoutConstraint.init(item: contentViewContainer, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -menuOffsetInContentShow))
        } else {
            constraints.append(NSLayoutConstraint.init(item: contentViewContainer, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0))
        }
    }
    
    func screenEdgePanGesture(recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.edges == .left {
            NSLog("%@", NSStringFromCGPoint(recognizer.translation(in: self.view)))
        }
    }

    func hideViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}

