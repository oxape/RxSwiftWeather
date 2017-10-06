//
//  OXPContainerControllerDelegate.swift
//  InteractiveTransitionD1
//
//  Created by oxape on 2017/9/25.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

@objc protocol OXPContainerControllerDelegate {
    func containerController(_ containerController: OXPContainerController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?

    @objc optional func containerController(_ containerContrller: OXPContainerController, interactionControllerForAnimation animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
}

class OXPContainerViewControllerDelegateImp: NSObject, OXPContainerControllerDelegate {
    
    var interactionController = OXPPercentDrivenInteractiveTransition()
    
    func containerController(_ containerController: OXPContainerController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromIndex = containerController.viewControllers!.index(of: fromVC)!
        let toIndex = containerController.viewControllers!.index(of: toVC)!
        let tabChangeDirection: TabOperationDirection = toIndex < fromIndex ? TabOperationDirection.left : TabOperationDirection.right
        let transitionType = OXPTransitionType.tabTransition(tabChangeDirection)
        let slideAnimationController = SlideAnimationController(type: transitionType)
        return slideAnimationController
    }
    
    func containerController(_ containerController: OXPContainerController, interactionControllerForAnimation animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
