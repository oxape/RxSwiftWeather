//
//  OXPContainerTransitionContext.swift
//  InteractiveTransitionD1
//
//  Created by oxape on 2017/9/25.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPContainerTransitionContext: NSObject, UIViewControllerContextTransitioning {
    
    //MARK: Protocol Method - Accessing the Transition Objects
    public var containerView: UIView {
        return privateContainerView
    }
    
    public func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController?{
        switch key{
        case UITransitionContextViewControllerKey.from:
            return fromViewController
        case UITransitionContextViewControllerKey.to:
            return toViewController
        default: return nil
        }
    }
    
    @objc @available(iOS 8.0, *)
    public func view(forKey key: UITransitionContextViewKey) -> UIView?{
        switch key{
        case UITransitionContextViewKey.from:
            return fromViewController.view
        case UITransitionContextViewKey.to:
            return toViewController.view
        default: return nil
        }
    }
    
    //MARK: Protocol Method - Getting the Transition Frame Rectangles
    public func initialFrame(for vc: UIViewController) -> CGRect {
        return CGRect.zero
    }
    
    public func finalFrame(for vc: UIViewController) -> CGRect {
        return vc.view.frame
    }
    
    //MARK: Protocol Method - Getting the Transition Behaviors
    public var presentationStyle: UIModalPresentationStyle{
        return .custom
    }
    
    //MARK: Protocol Method - Reporting the Transition Progress
    func completeTransition(_ didComplete: Bool) {
        if didComplete{
            toViewController.didMove(toParentViewController: containerViewController)
            
            fromViewController.willMove(toParentViewController: nil)
            fromViewController.view.removeFromSuperview()
            fromViewController.removeFromParentViewController()
        }else{
            toViewController.didMove(toParentViewController: containerViewController)
            
            toViewController.willMove(toParentViewController: nil)
            toViewController.view.removeFromSuperview()
            toViewController.removeFromParentViewController()
        }
        
        transitionEnd()
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        if animationController != nil && isInteractive == true{
            transitionPercent = percentComplete
            containerView.layer.timeOffset = CFTimeInterval(percentComplete) * transitionDuration
//            containerViewController.graduallyChangeTabButtonAppearWith(fromIndex, toIndex: toIndex, percent: percentComplete)
        }
    }
    
    func finishInteractiveTransition() {
        isInteractive = false
        let pausedTime = privateContainerView.layer.timeOffset
        privateContainerView.layer.speed = 1.0
        privateContainerView.layer.timeOffset = 0.0
        privateContainerView.layer.beginTime = 0.0
        let timeSincePause = privateContainerView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        privateContainerView.layer.beginTime = timeSincePause
        
        let displayLink = CADisplayLink(target: self, selector: #selector(OXPContainerTransitionContext.finishChangeButtonAppear(_:)))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        
        //当 SDETabBarViewController 作为一个子 VC 内嵌在其他容器 VC 内，比如 NavigationController 里时，在 SDETabBarViewController 内完成一次交互转场后
        //在外层的 NavigationController push 其他 VC 然后 pop 返回时，且仅限于交互控制，会出现 containerView 不见的情况，pop 完成后就恢复了。
        //根源在于此时 beginTime 被修改了，在转场结束后恢复为 0 就可以了。解决灵感来自于如果没有一次完成了交互转场而全部是中途取消的话就不会出现这个 Bug。
        //感谢简书用户@dasehng__ 反馈这个 Bug。
        let remainingTime = CFTimeInterval(1 - transitionPercent) * transitionDuration
        perform(#selector(OXPContainerTransitionContext.fixBeginTimeBug), with: nil, afterDelay: remainingTime)
        
    }
    
    func cancelInteractiveTransition() {
        isInteractive = false
        isCancelled = true
        let displayLink = CADisplayLink(target: self, selector: #selector(OXPContainerTransitionContext.reverseCurrentAnimation(_:)))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
//        NotificationCenter.default.post(name: Notification.Name(rawValue: SDEInteractionEndNotification), object: self)
    }
    
    public var transitionWasCancelled: Bool{
        return isCancelled
    }
    
    //MARK: Protocol Method - Getting the Rotation Factor
    @available(iOS 8.0, *)
    public var targetTransform: CGAffineTransform{
        return CGAffineTransform.identity
    }
    
    //MARK: Protocol Method - Pause Transition
    @available(iOS 10.0, *)
    public func pauseInteractiveTransition() {
        
    }
    
    init(containerViewController: OXPContainerController, containerView: UIView, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) {
        self.containerViewController = containerViewController
        privateContainerView = containerView
        fromViewController = fromVC
        toViewController = toVC
        fromIndex = containerViewController.viewControllers!.index(of: fromVC)!
        toIndex = containerViewController.viewControllers!.index(of: toVC)!
        super.init()
        //每次转场开始前都会生成这个对象，调整 toView 的尺寸适用屏幕
        toViewController.view.frame = privateContainerView.bounds
    }
    //MARK: -- 以下为内部属性和方法,不属于协议部分
    //MARK: Addtive Property
    fileprivate var animationController: UIViewControllerAnimatedTransitioning?
    //MARK: Private Property for Protocol Need
    unowned fileprivate var fromViewController: UIViewController
    unowned fileprivate var toViewController: UIViewController
    unowned fileprivate var containerViewController: OXPContainerController
    unowned fileprivate var privateContainerView: UIView
    //MARK: Property for Transition State
    public var isAnimated: Bool{
        if animationController != nil{
            return true
        }
        return false
    }
    public var isInteractive = false
    fileprivate var isCancelled = false
    fileprivate var fromIndex: Int = 0
    fileprivate var toIndex: Int = 0
    fileprivate var transitionDuration: CFTimeInterval = 0
    fileprivate var transitionPercent: CGFloat = 0
    
    //非协议方法，是启动非交互式转场的便捷方法
    func startNonInteractiveTransitionWith(_ delegate: OXPContainerControllerDelegate) {
        animationController = delegate.containerController(containerViewController, animationControllerForTransitionFromViewController: fromViewController, toViewController: toViewController)
        containerViewController.addChildViewController(toViewController)
        animationController?.animateTransition(using: self)
    }
    
    func startInteractiveTransitionWith(_ delegate: OXPContainerControllerDelegate) {
        animationController = delegate.containerController(containerViewController, animationControllerForTransitionFromViewController: fromViewController, toViewController: toViewController)
        transitionDuration = animationController!.transitionDuration(using: self)
        if containerViewController.interactive == true {
            if let interactionController = delegate.containerController?(containerViewController, interactionControllerForAnimation: animationController!) {
                interactionController.startInteractiveTransition(self)
            } else {
                fatalError("Need for interaction controller for interactive transition.")
            }
        } else {
            fatalError("ContainerTransitionContext's Property 'interactive' must be true before starting interactive transiton")
        }
    }
    
    //InteractionController's startInteractiveTransition: will call this method
    func activateInteractiveTransition(){
        isInteractive = true
        isCancelled = false
        containerViewController.addChildViewController(toViewController)
        privateContainerView.layer.speed = 0
        animationController?.animateTransition(using: self)
    }
    
    //MARK: Private Helper Method
    fileprivate func activateNonInteractiveTransition(){
        isInteractive = false
        isCancelled = false
        containerViewController.addChildViewController(toViewController)
        animationController?.animateTransition(using: self)
    }
    
    fileprivate func transitionEnd(){
        if animationController != nil && animationController!.responds(to: #selector(UIViewControllerAnimatedTransitioning.animationEnded(_:))) == true{
            animationController!.animationEnded!(!isCancelled)
        }
        //If transition is cancelled, recovery data.
        if isCancelled{
            containerViewController.restoreSelectedIndex()
            isCancelled = false
        }
    }
    
    //修复内嵌在其他容器 VC 交互返回的转场中 containerView 消失并且的转场结束后自动恢复的 Bug。
    @objc fileprivate func fixBeginTimeBug(){
        privateContainerView.layer.beginTime = 0.0
    }
    
    
    @objc fileprivate func reverseCurrentAnimation(_ displayLink: CADisplayLink){
        let timeOffset = privateContainerView.layer.timeOffset - displayLink.duration
        if timeOffset > 0{
            privateContainerView.layer.timeOffset = timeOffset
            transitionPercent = CGFloat(timeOffset / transitionDuration)
            containerViewController.graduallyChangeAppearWith(fromIndex, toIndex: toIndex, percent: transitionPercent)
        }else{
            displayLink.invalidate()
            containerView.layer.timeOffset = 0
            containerView.layer.speed = 1
            containerViewController.graduallyChangeAppearWith(fromIndex, toIndex: toIndex, percent: 0)
            
            //修复闪屏Bug: speed 恢复为1后，动画会立即跳转到它的最终状态，而 fromView 的最终状态是移动到了屏幕之外，因此在这里添加一个假的掩人耳目。
            //为何不等 completion block 中恢复 fromView 的状态后再恢复 containerView.layer.speed，事实上那样做无效，原因未知。
            if let fakeFromView = fromViewController.view.snapshotView(afterScreenUpdates: false) {
                privateContainerView.addSubview(fakeFromView)
                perform(#selector(OXPContainerTransitionContext.removeFakeFromView(_:)), with: fakeFromView, afterDelay: 1/60)
            }
        }
    }
    
    @objc fileprivate func removeFakeFromView(_ fakeView: UIView){
        fakeView.removeFromSuperview()
    }
    
    @objc fileprivate func finishChangeButtonAppear(_ displayLink: CADisplayLink){
        let percentFrame = 1 / (transitionDuration * 60)
        transitionPercent += CGFloat(percentFrame)
        if transitionPercent < 1.0{
            containerViewController.graduallyChangeAppearWith(fromIndex, toIndex: toIndex, percent: transitionPercent)
        }else{
            containerViewController.graduallyChangeAppearWith(fromIndex, toIndex: toIndex, percent: 1)
            displayLink.invalidate()
        }
    }
}
