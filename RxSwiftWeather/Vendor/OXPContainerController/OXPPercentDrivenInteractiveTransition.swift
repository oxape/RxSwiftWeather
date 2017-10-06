//
//  OXPPercentDrivenInteractiveTransition.swift
//  InteractiveTransitionD1
//
//  Created by oxape on 2017/9/25.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPPercentDrivenInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {
    weak var containerTransitionContext: OXPContainerTransitionContext?
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if let context = transitionContext as? OXPContainerTransitionContext {
            containerTransitionContext = context
            containerTransitionContext?.activateInteractiveTransition()
        }else{
            fatalError("\(transitionContext) is not class or subclass of ContainerTransitionContext")
        }
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat){
        containerTransitionContext?.updateInteractiveTransition(percentComplete)
    }
    
    func cancelInteractiveTransition(){
        containerTransitionContext?.cancelInteractiveTransition()
    }
    
    func finishInteractiveTransition(){
        containerTransitionContext?.finishInteractiveTransition()
    }
}
