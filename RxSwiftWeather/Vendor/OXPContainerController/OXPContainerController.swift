//
//  OXPContainerController.swift
//  InteractiveTransitionD1
//
//  Created by oxape on 2017/9/25.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPContainerController: UIViewController {
    //MARK: Normal Property
    private let containerView = UIView()
    //MARK: Property for Transition
    var interactive = false
    weak var containerTransitionDelegate: OXPContainerControllerDelegate?
    
    private var containerTransitionContext: OXPContainerTransitionContext?
    //MARK: Property like UITabBarController
    fileprivate(set) var viewControllers: [UIViewController]?
    fileprivate var shouldReserve = false
    fileprivate var priorSelectedIndex: Int = NSNotFound
    var selectedIndex: Int = NSNotFound {
        willSet {
            if shouldReserve {
                shouldReserve = false
            } else {
                transitionViewControllerFromIndex(selectedIndex, toIndex: newValue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Class Life Method
    init(viewControllers: [UIViewController]) {
        assert(viewControllers.count > 0, "can't init with 0 child VC")
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        for childVC in viewControllers{
            //适应屏幕旋转的最简单的办法，在转场开始前设置子 view 的尺寸为容器视图的尺寸。
            childVC.view.translatesAutoresizingMaskIntoConstraints = true
            childVC.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = UIColor.black
        rootView.isOpaque = true
        
        self.view = rootView
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.black
        containerView.isOpaque = true
        rootView.addSubview(containerView)
        
        rootView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: rootView, attribute: .width, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: rootView, attribute: .height, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: rootView, attribute: .left, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: rootView, attribute: .top, multiplier: 1, constant: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Setting this property in other method before this one will make a bug: when you go back to this initial selectedIndex, no transition animation.
        if viewControllers != nil && viewControllers!.count > 0 && selectedIndex == NSNotFound{
            selectedIndex = 0
        }
    }

    private func transitionViewControllerFromIndex(_ fromIndex: Int, toIndex: Int) {
        if viewControllers == nil || fromIndex == toIndex || fromIndex < 0 || toIndex < 0 || toIndex >= viewControllers!.count || (fromIndex >= viewControllers!.count && fromIndex != NSNotFound){
            return
        }
        //called when init
        if fromIndex == NSNotFound{
            let selectedVC = viewControllers![toIndex]
            addChildViewController(selectedVC)
            containerView.addSubview(selectedVC.view)
            selectedVC.didMove(toParentViewController: self)
            changeAppearAtIndex(toIndex)
            return
        }
        //条件绑定
        if let transitionDelegate = containerTransitionDelegate {
            let fromVC = viewControllers![fromIndex]
            let toVC = viewControllers![toIndex]
            containerTransitionContext = OXPContainerTransitionContext.init(containerViewController: self, containerView: containerView, fromViewController: fromVC, toViewController: toVC)
            if interactive {
                priorSelectedIndex = fromIndex
                containerTransitionContext?.startInteractiveTransitionWith(transitionDelegate)
            } else {
                containerTransitionContext?.startNonInteractiveTransitionWith(transitionDelegate)
                changeAppearAtIndex(toIndex)
            }
        } else {
            let newSelectedVC = viewControllers![toIndex];
            self.addChildViewController(newSelectedVC)
            containerView.addSubview(newSelectedVC.view);
            newSelectedVC.didMove(toParentViewController: self)
            UIView.animate(withDuration: 0.25, animations: {
                
            }) { (finished) in
                let priorSelectedVC = self.viewControllers![fromIndex]
                priorSelectedVC.willMove(toParentViewController: nil)
                priorSelectedVC.view.removeFromSuperview()
                priorSelectedVC.removeFromParentViewController()
            }
        }
    }
    
    //MARK: Restore data and change button appear
    func restoreSelectedIndex(){
        shouldReserve = true
        selectedIndex = priorSelectedIndex
    }
    
    fileprivate func changeAppearAtIndex(_ selectedIndex: Int){
        
    }
    
    //Only work in interactive transition
    func graduallyChangeAppearWith(_ fromIndex: Int, toIndex: Int, percent: CGFloat){
        
    }
}
