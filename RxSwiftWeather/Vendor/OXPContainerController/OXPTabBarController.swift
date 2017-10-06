//
//  OXPTabBarController.swift
//  InteractiveTransitionD1
//
//  Created by oxape on 2017/9/25.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPTabBarController: OXPContainerController {

    var pangesture : UIPanGestureRecognizer!
    
    var panEnable: Bool = true {
        didSet {
            pangesture.isEnabled = panEnable
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pangesture = UIPanGestureRecognizer(target: self, action: #selector(OXPTabBarController.handlePan(_:)))
        view.addGestureRecognizer(pangesture)
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        if viewControllers == nil || (viewControllers?.count)! < 2 {
            return
        }
        
        guard let delegate = containerTransitionDelegate as? OXPContainerViewControllerDelegateImp else {
            return
        }
        
        let translationX =  gesture.translation(in: view).x
        let translationAbs = translationX > 0 ? translationX : -translationX
        let progress = translationAbs / view.frame.width
        switch gesture.state{
        case .began:
            interactive = true
            let velocityX = gesture.velocity(in: view).x
            if velocityX < 0{
                if selectedIndex < viewControllers!.count - 1{
                    selectedIndex += 1
                }
            }else{
                if selectedIndex > 0{
                    selectedIndex -= 1
                }
            }
        case .changed:
            delegate.interactionController.updateInteractiveTransition(progress)
        case .cancelled, .ended:
            interactive = false
            if progress > 0.4 {
                delegate.interactionController.finishInteractiveTransition()
            }else {
                delegate.interactionController.cancelInteractiveTransition()
            }
        default: break
        }
    }
}
