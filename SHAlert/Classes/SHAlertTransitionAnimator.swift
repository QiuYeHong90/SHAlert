//
//  YORKAlertTransitionAnimator.swift
//  DemoLearn
//
//  Created by Ray on 2023/5/11.
//

import UIKit

class SHAlertTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var bgView: UIView?
    var edgeInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    
    
    private override init() {
        super.init()
    }
    
    convenience init(bgView: UIView, edgeInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)) {
        self.init()
        self.bgView = bgView
        self.edgeInsets = edgeInsets
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get the "from" and "to" view controllers and their views.
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        print("fromVC ==\(fromVC)")
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        
        if let bgView = self.bgView {
            bgView.removeFromSuperview()
            containerView.addSubview(bgView)
            bgView.frame = containerView.bounds
            bgView.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.addConstraints([
                NSLayoutConstraint.init(item: bgView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
                NSLayoutConstraint.init(item: bgView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
                NSLayoutConstraint.init(item: bgView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
                NSLayoutConstraint.init(item: bgView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),
            
            ])
        }
        
        // Add the "to" view controller's view to the container.
        containerView.addSubview(toVC.view)
        toVC.view.translatesAutoresizingMaskIntoConstraints = false
        guard let toVCView = toVC.view else {
            return
        }
        let widthFloat = min(containerView.bounds.size.width, containerView.bounds.size.height) - (self.edgeInsets.left + self.edgeInsets.right)
        let widthLayout = NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: widthFloat)
        containerView.addConstraint(widthLayout)
        
        let centerX = NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        containerView.addConstraint(centerX)
        
        
        let bottom = NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.edgeInsets.bottom == 0 ? containerView : containerView.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: containerView.bounds.height)
        
        containerView.addConstraint(bottom)
        
        
        
        containerView.addConstraint(NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 20))
        
        
        containerView.addConstraint(NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: self.edgeInsets.bottom == 0 ? containerView : containerView.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: -(self.edgeInsets.top + self.edgeInsets.bottom )))
        
        containerView.layoutIfNeeded()
        
        bottom.constant = -self.edgeInsets.bottom
        // Animate the transition.
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 2,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            containerView.layoutIfNeeded()
        },
                       completion: { finished in
            transitionContext.completeTransition(finished)
        }
        )
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}
