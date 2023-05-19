//
//  BaseYorkAlertTransitionAnimator.swift
//  DemoLearn
//
//  Created by Ray on 2023/5/12.
//

import UIKit

open class BaseSHAlertTransitionAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    open var bgView: UIView?
    open var contentView: BaseSHAlertContentView?
    /// 相对于竖屏的左右间距 来固定宽度
    open var edgeInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    open var callBack: ((_ bottomLayout: NSLayoutConstraint?)->Void)?
    open var style: BaseSHAlertViewController.Style = .actionSheet
    
    
    private override init() {
        super.init()
    }
    
    public convenience init(bgView: UIView, contentView: BaseSHAlertContentView, edgeInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8), style: BaseSHAlertViewController.Style = .actionSheet, callBack: ((_ bottomLayout: NSLayoutConstraint?)->Void)?) {
        self.init()
        self.bgView = bgView
        self.edgeInsets = edgeInsets
        self.contentView = contentView
        self.callBack = callBack
        self.style = style
    }
    deinit {
        print("deinit \(self)")
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
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
        guard let toVCView = contentView else {
            return
        }
        containerView.addSubview(toVCView)
        toVCView.contentStack.addArrangedSubview(toVC.view)
        toVCView.translatesAutoresizingMaskIntoConstraints = false
        toVC.view.translatesAutoresizingMaskIntoConstraints = false
        switch self.style {
        case .actionSheet:
            do {
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
                self.callBack?(bottom)
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
        case .alert:
            do {
                let widthFloat = min(containerView.bounds.size.width, containerView.bounds.size.height) - (self.edgeInsets.left + self.edgeInsets.right)
                let widthLayout = NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: widthFloat)
                containerView.addConstraint(widthLayout)
                
                let centerX = NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
                containerView.addConstraint(centerX)
                
                
                let centerY = NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
                containerView.addConstraint(centerY)
                
                
                let bottom = NSLayoutConstraint.init(item:  containerView.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: toVCView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
                
                containerView.addConstraint(bottom)
                
                
                
                
//                高度
                containerView.addConstraint(NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 20))
                
//
                containerView.addConstraint(NSLayoutConstraint.init(item: toVCView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: containerView.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: -(self.edgeInsets.top + self.edgeInsets.bottom )))
                
                containerView.layoutIfNeeded()
                // 缩放比例（1表示不缩放）
                let scale: CGFloat = 1.2
                toVCView.transform = CGAffineTransform(scaleX: scale, y: scale)
                containerView.alpha = 0
                
                // Animate the transition.
                UIView.animate(withDuration: transitionDuration(using: transitionContext),
                               delay: 0,
                               usingSpringWithDamping: 2,
                               initialSpringVelocity: 0,
                               options: .curveEaseInOut,
                               animations: {
                    toVCView.transform = .identity
                    containerView.alpha = 1
                },
                               completion: { finished in
                    transitionContext.completeTransition(finished)
                }
                )
            }
        }
        
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}

open class BaseYorkAlertDismissTransitionAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    open weak var bgView: UIView?
    open weak var contentView: BaseSHAlertContentView?
    open weak var bottomLayout: NSLayoutConstraint?
    open var style: BaseSHAlertViewController.Style = .actionSheet
    
    deinit {
        print("deinit \(self)")
    }
    private override init() {
        super.init()
    }
    
    convenience init(bgView: UIView, contentView: BaseSHAlertContentView, bottomLayout: NSLayoutConstraint?, style: BaseSHAlertViewController.Style = .actionSheet) {
        self.init()
        self.bgView = bgView
        self.contentView = contentView
        self.bottomLayout = bottomLayout
        self.style = style
    }
    
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get the "from" and "to" view controllers and their views.
        guard let toVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        print("fromVC ==\(toVC)")
        let containerView = transitionContext.containerView
        switch self.style {
        case .actionSheet:
            do {
                self.bottomLayout?.constant = containerView.bounds.size.height
                // Animate the transition.
                UIView.animate(withDuration: transitionDuration(using: transitionContext),
                               delay: 0,
                               usingSpringWithDamping: 2,
                               initialSpringVelocity: 0,
                               options: .curveEaseInOut,
                               animations: {
                    self.bgView?.backgroundColor = .gray.withAlphaComponent(0)
                    containerView.layoutIfNeeded()
                },
                               completion: { finished in
                    self.bgView?.removeFromSuperview()
                    self.contentView?.removeFromSuperview()
                    transitionContext.completeTransition(finished)
                }
                )
            }
        case .alert:
            do {
                // Animate the transition.
                UIView.animate(withDuration: transitionDuration(using: transitionContext),
                               delay: 0,
                               usingSpringWithDamping: 2,
                               initialSpringVelocity: 0,
                               options: .curveEaseInOut,
                               animations: {
                    containerView.alpha = 0
                },
                               completion: { finished in
                    self.bgView?.removeFromSuperview()
                    self.contentView?.removeFromSuperview()
                    transitionContext.completeTransition(finished)
                }
                )
            }
            
        }
        
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}
