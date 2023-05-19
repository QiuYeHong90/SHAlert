//
//  BaseYorkAlertViewController.swift
//  DemoLearn
//
//  Created by Ray on 2023/5/12.
//

import UIKit

open class BaseSHAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    open var bgView: UIView = .init()
    open lazy var contentView: BaseSHAlertContentView = BaseSHAlertContentView.init()
    open var bottomLayout: NSLayoutConstraint?
    open var style: Style
    
    
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.style = .actionSheet
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initCommon()
    }
    
    public required init?(coder: NSCoder) {
        self.style = .actionSheet
        super.init(coder: coder)
        
        initCommon()
    }
    public init(style: BaseSHAlertViewController.Style) {
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
        self.initCommon()
    }
    
    open func initCommon() {
        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = self
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configBgView()
        
    }
    
    open func configBgView() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapDismiss))
        self.bgView.addGestureRecognizer(tap)
        self.bgView.backgroundColor = .gray.withAlphaComponent(0.7)
    }
    
    @objc open func tapDismiss() {
        self.dismiss(animated: true)
    }
    // MARK: UIViewControllerTransitioningDelegate methods
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch self.style {
        case .actionSheet:
            return BaseSHAlertTransitionAnimator.init(bgView: self.bgView, contentView: self.contentView, edgeInsets: UIEdgeInsets.zero, style: .actionSheet) { [weak self] bottomLayout in
                self?.bottomLayout = bottomLayout
            }
        case .alert:
            return BaseSHAlertTransitionAnimator.init(bgView: self.bgView, contentView: self.contentView, edgeInsets: UIEdgeInsets.init(top: 47, left: 60, bottom: 47, right: 60), style: .alert, callBack: nil)
        }
        
        
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch self.style {
        case .actionSheet:
            return BaseYorkAlertDismissTransitionAnimator.init(bgView: self.bgView, contentView: self.contentView,bottomLayout: self.bottomLayout, style: self.style)
        case .alert:
            return BaseYorkAlertDismissTransitionAnimator.init(bgView: self.bgView, contentView: self.contentView,bottomLayout: self.bottomLayout, style: self.style)
        }
    }
    deinit {
        print("deinit \(self)")
    }
}
extension BaseSHAlertViewController {

    
    @available(iOS 8.0, *)
    public enum Style : Int, @unchecked Sendable {
        case actionSheet = 0
        case alert = 1
    }
}


open class BaseSHAlertContentView: UIView {
    open lazy var contentStackScroll: UIScrollView = .init()
    open lazy var contentStack: UIStackView = UIStackView.init()
    open var  layoutHeight: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    func initCommon() {
        contentStack.axis = .horizontal
        self.addSubview(contentStackScroll)
        contentStackScroll.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),
                            
                            ])
        
        
        contentStackScroll.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        let heightLayout = NSLayoutConstraint.init(item: contentStack, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        layoutHeight = heightLayout
        heightLayout.priority = .defaultLow
        contentStackScroll.addConstraints([
            NSLayoutConstraint.init(item: contentStack, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: contentStack, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: contentStack, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: contentStack, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: contentStack, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentStackScroll, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0),
            
            heightLayout
                            ])
        
    }
}


