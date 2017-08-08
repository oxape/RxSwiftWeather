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
    fileprivate let animationDuration:CGFloat = 0.25
    fileprivate var menuOffsetInContentShow:CGFloat {
        return self.view.bounds.size.width * 0.25
    }
    fileprivate var edgeRecognizer:UIScreenEdgePanGestureRecognizer!
    fileprivate var pagRecognizer:UIPanGestureRecognizer!
    fileprivate var startPoint = CGPoint(x: 0, y: 0)
    fileprivate var percent:CGFloat = 0
    var menuShow = false
    var menuViewController:UIViewController? {
        willSet {
            if menuViewController != nil {
                self.hideViewController(viewController: menuViewController!)
            }
        }
        didSet {
            if menuViewController != nil {
                let menu = menuViewController!
                self.addChildViewController(menu)
                menuViewContainer.addSubview(menu.view)
                menu.view.frame = menuViewContainer.frame
                menu.view.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
                menu.didMove(toParentViewController: self)
            }
            self.view.setNeedsUpdateConstraints()
        }
    }
    var contentViewController:UIViewController? {
        willSet {
            if contentViewController != nil {
                self.hideViewController(viewController: contentViewController!)
            }
        }
        didSet {
            if contentViewController != nil {
                let content = contentViewController!
                self.addChildViewController(content)
                contentViewContainer.addSubview(content.view)
                content.view.frame = contentViewContainer.frame
                content.view.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
                content.didMove(toParentViewController: self)
            }
            self.view.setNeedsUpdateConstraints()
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
        self.menuViewContainer.translatesAutoresizingMaskIntoConstraints = false;
        self.contentViewContainer.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(menuViewContainer)
        self.view.addSubview(contentViewContainer)
        
        edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(OXPSideMenu.screenEdgePanGesture(recognizer:)))
        edgeRecognizer.edges = .left
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(edgeRecognizer)
        
        pagRecognizer = UIPanGestureRecognizer(target: self, action: #selector(OXPSideMenu.panGesture(recognizer:)))
        self.contentViewContainer.isUserInteractionEnabled = true
        self.contentViewContainer.addGestureRecognizer(pagRecognizer)
        pagRecognizer.isEnabled = false
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.view.removeConstraints(constraints)
        constraints.removeAll()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[menu]|", options:[], metrics: nil, views: ["menu": menuViewContainer]))
        constraints.append(NSLayoutConstraint.init(item: menuViewContainer, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint.init(item: menuViewContainer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.75, constant: 0))
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[content]|", options:[], metrics: nil, views: ["content": contentViewContainer]))
        constraints.append(NSLayoutConstraint.init(item: contentViewContainer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0))
        if (menuShow) {
            constraints.append(NSLayoutConstraint.init(item: contentViewContainer, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -menuOffsetInContentShow))
        } else {
            constraints.append(NSLayoutConstraint.init(item: contentViewContainer, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0))
        }
        self.view.addConstraints(constraints)
    }
    
    func screenEdgePanGesture(recognizer: UIScreenEdgePanGestureRecognizer) {
        if (recognizer.state == .began) {
            startPoint = recognizer.location(in: self.view)
            menuShow = true
            self.view.layer.speed = 0
            self.view.layer.timeOffset = 0
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: .curveLinear, animations: {
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else if (recognizer.state == .changed) {
            let point = recognizer.location(in: self.view)
            percent = abs(point.x-startPoint.x)/abs(self.view.bounds.size.width - menuOffsetInContentShow - abs(startPoint.x))
            if point.x < startPoint.x {
                percent = 0
            }
            self.view.layer.timeOffset = CFTimeInterval(percent * animationDuration)
        } else if (recognizer.state == .ended || recognizer.state == .cancelled || recognizer.state == .failed) {
            let displayLink = CADisplayLink(target: self, selector: #selector(OXPSideMenu.edgeDisplayLinkTick(link:)))
            displayLink.isPaused = false
            displayLink.add(to: RunLoop.main, forMode: .commonModes)
            recognizer.isEnabled = false
        }
    }
    
    func panGesture(recognizer: UIScreenEdgePanGestureRecognizer) {
        if (recognizer.state == .began) {
            startPoint = recognizer.location(in: self.view)
            menuShow = false
            self.view.layer.speed = 0
            self.view.layer.timeOffset = 0
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: .curveLinear, animations: {
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else if (recognizer.state == .changed) {
            let point = recognizer.location(in: self.view)
            percent = abs(point.x-startPoint.x)/abs(startPoint.x)
            if (point.x > startPoint.x) {
                percent = 0
            }
            self.view.layer.timeOffset = CFTimeInterval(percent * animationDuration)
        } else if (recognizer.state == .ended || recognizer.state == .cancelled || recognizer.state == .failed) {
            let displayLink = CADisplayLink(target: self, selector: #selector(OXPSideMenu.panDisplayLinkTick(link:)))
            displayLink.isPaused = false
            displayLink.add(to: RunLoop.main, forMode: .commonModes)
            recognizer.isEnabled = false
        }
    }
    
    func edgeDisplayLinkTick(link: CADisplayLink) {
        continueAnimation(link: link, percent: percent)
        resumeAnimation(link: link, menuHidden: false)
    }
    
    func panDisplayLinkTick(link: CADisplayLink) {
        continueAnimation(link: link, percent: percent)
        resumeAnimation(link: link, menuHidden: true)
    }
    
    func continueAnimation(link:CADisplayLink, percent:CGFloat) {
        if (percent > 0.3) {
            self.view.layer.timeOffset += link.duration
        } else {
            self.view.layer.timeOffset -= link.duration
        }
    }
    
    func resumeAnimation(link:CADisplayLink, menuHidden:Bool) {
        //menuHidden代表动画初始的方向,比如当前动画本就是为了隐藏菜单,虽然最后取消隐藏,那动画的初始方向就是menuHidden = true
        if (self.view.layer.timeOffset < 0) {
            self.view.layer.timeOffset = 0
            link.invalidate()
            self.view.layer.speed = 1
            if (menuHidden) {
                self.showMenuViewController(animated: false)
            } else  {
                self.hidMenuViewController(animated: false)
            }
        } else if (self.view.layer.timeOffset > CFTimeInterval(animationDuration)) {
            self.view.layer.timeOffset = CFTimeInterval(animationDuration)
            link.invalidate()
            self.view.layer.speed = 1
            if (menuHidden) {
                self.hidMenuViewController(animated: false)
            } else {
                self.showMenuViewController(animated: false)
            }
        }
    }
    
    func showMenuViewController(animated: Bool) {
        menuShow = true
        if animated {
            UIView.animate(withDuration: TimeInterval(animationDuration), animations: {
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            }) { _ in
                self.pagRecognizer.isEnabled = true
                self.edgeRecognizer.isEnabled = false
            }
        } else {
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
            self.pagRecognizer.isEnabled = true
            self.edgeRecognizer.isEnabled = false
        }
    }
    
    func hidMenuViewController(animated: Bool) {
        menuShow = false
        if animated {
            UIView.animate(withDuration: TimeInterval(animationDuration), animations: {
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            }) { _ in
                self.pagRecognizer.isEnabled = false
                self.edgeRecognizer.isEnabled = true
            }
        } else {
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
            self.pagRecognizer.isEnabled = false
            self.edgeRecognizer.isEnabled = true
        }
    }

    func hideViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}

