//
//  MenuTransitionManager.swift
//  SlideMenu
//
//  Created by Michael Henry on 1/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    let duration = 0.5
    var isPresenting = false
    var snapshot: UIView? {
        didSet {
            if let delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: "dismiss")
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    var delegate: MenuTransitionManagerDelegate?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get references to the fromView, toView, and container view
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // set up the transform for the animation
        
        guard let container = transitionContext.containerView() else {
            return
        }
        
        let moveDown = CGAffineTransformMakeTranslation(0, container.frame.height - 150)
        let moveUp = CGAffineTransformMakeTranslation(0, -50)
        
        // add both views to container view
        
        if isPresenting {
            toView.transform = moveUp
            snapshot = fromView.snapshotViewAfterScreenUpdates(true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        // perform the animation
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresenting {
                self.snapshot?.transform = moveDown
                toView.transform = CGAffineTransformIdentity
            } else {
                self.snapshot?.transform = CGAffineTransformIdentity
                fromView.transform = moveUp
            }
            
            }, completion: { finished in
        
                transitionContext.completeTransition(true)
                
                if !self.isPresenting {
                    self.snapshot?.removeFromSuperview()
                }
        })
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

@objc protocol MenuTransitionManagerDelegate {
    func dismiss()
}
