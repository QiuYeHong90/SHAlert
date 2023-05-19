//
//  YORKAlertController.swift
//  DemoLearn
//
//  Created by Ray on 2023/5/11.
//

import UIKit

extension SHAlertAction {

    
    @available(iOS 8.0, *)
    public enum Style {

        
        case `default`

        case cancel

        case destructive
        
        case custom(actionView: UIView)
    }
}

open class SHAlertAction : NSObject {
    
    
    
    public convenience init(title: String?, style: SHAlertAction.Style, handler: ((SHAlertAction) -> Void)? = nil) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
        
    }
    
    private override init() {
        super.init()
    }

    
    private(set) var title: String?

    private(set) var style: SHAlertAction.Style = .default

    var isEnabled: Bool = true
    
    var handler: ((SHAlertAction) -> Void)?
}

extension SHAlertController {

    
    @available(iOS 8.0, *)
    public enum Style : Int, @unchecked Sendable {

        
        case actionSheet = 0

        case alert = 1
    }
}


open class SHAlertController: UIViewController, UIViewControllerTransitioningDelegate {

    open var actions: [SHAlertAction] = []
    open var preferredStyle: Style = .actionSheet
    open var message: String?
    open var bgView: UIView = .init()
    
    
    
    lazy var effectView: UIVisualEffectView = {
        let blur =  UIBlurEffect.init(style: UIBlurEffect.Style.extraLight)
        let effectView = UIVisualEffectView.init(effect: blur)
        
        return effectView
    }()
    
    
    var topStack: UIStackView = UIStackView.init()
    lazy var titleLabel: UILabel = {
        let titleL = UILabel.init()
        titleL.font = UIFont.boldSystemFont(ofSize: 17)
        titleL.textAlignment = .center
        titleL.numberOfLines = 0
        return titleL
    }()
    
    lazy var messgeLabel: UILabel = {
        let titleL = UILabel.init()
        titleL.font = UIFont.boldSystemFont(ofSize: 12)
        titleL.textAlignment = .center
        titleL.numberOfLines = 0
        return titleL
    }()
    
    lazy var contentView: UIView = UIView.init()
    
    var contentBottom: NSLayoutConstraint?
    
    
    lazy var contentStack: SHContentActionView = SHContentActionView.init()
    
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
        
        self.titleLabel.text = self.title
        self.messgeLabel.text = self.message
        
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentBottom = NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([
            NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
            contentBottom!,
                                 ])
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.layer.cornerRadius = 13
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(effectView)
        
        
        effectView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.effectView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.effectView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.effectView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.effectView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),])
        
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapDismiss))
        self.bgView.addGestureRecognizer(tap)
        self.bgView.backgroundColor = .gray.withAlphaComponent(0.7)
        
        self.topStack.translatesAutoresizingMaskIntoConstraints = false
        self.topStack.axis = .vertical
        self.contentView.addSubview(self.topStack)
        self.contentView.addConstraints([
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.topStack, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -5),
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.topStack, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.topStack, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.topStack, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 77),
                                 
                                 ])
        
        self.topStack.addArrangedSubview(self.titleLabel)
        self.topStack.addArrangedSubview(self.messgeLabel)
        
        self.contentStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentStack.contentStack.axis = .vertical
        self.contentView.addSubview(self.contentStack)
        
        self.contentView.addConstraints([
            NSLayoutConstraint.init(item: self.topStack, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentStack, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -5),
            NSLayoutConstraint.init(item: self.contentView.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentStack, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentStack, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentStack, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
                                 
                                 ])
        
        var isHasCancel = false
        
        self.actions.forEach { item in
            do {
                //                line
                let lineView = UIView.init()
                lineView.backgroundColor = .lightGray
                self.contentStack.contentStack.addArrangedSubview(lineView)
                self.contentStack.addConstraint(NSLayoutConstraint.init(item: lineView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0.5))
            }
            switch item.style {
            case .custom(actionView: let actionView):
                self.contentStack.contentStack.addArrangedSubview(actionView)
                
            case .default:
                let button = SHActionView.init(type: UIButton.ButtonType.system)
                button.setTitle(item.title, for: UIControl.State.normal)
                button.action = {
                    [weak item, weak self] (_) in
                    if let itemH = item {
                        itemH.handler?(itemH)
                        self?.dismiss(animated: true)
                    }
                }
                
                self.contentStack.contentStack.addArrangedSubview(button)
                
                
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let heightLayout = NSLayoutConstraint.init(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 57)
                self.contentStack.addConstraint(heightLayout)
            case .destructive:
                let button = SHActionView.init(type: UIButton.ButtonType.system)
                button.setTitleColor(UIColor.red, for: UIControl.State.normal)
                
                button.setTitle(item.title, for: UIControl.State.normal)
                button.action = {
                    [weak item, weak self] (_) in
                    if let itemH = item {
                        itemH.handler?(itemH)
                        self?.dismiss(animated: true)
                    }
                }
                
                self.contentStack.contentStack.addArrangedSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                let heightLayout = NSLayoutConstraint.init(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 57)
                self.contentStack.addConstraint(heightLayout)
            case .cancel:
                if !isHasCancel {
                    isHasCancel = true
                    contentBottom?.constant = 57 + 8
                    
                    let button = SHActionView.init(type: UIButton.ButtonType.system)
                    button.setTitle(item.title, for: UIControl.State.normal)
                    button.action = {
                        [weak item, weak self] (_) in
                        if let itemH = item {
                            itemH.handler?(itemH)
                            self?.dismiss(animated: true)
                        }
                    }
                    button.layer.cornerRadius = 13
                    button.layer.masksToBounds = true
                    self.view.addSubview(button)
                    button.effectView.isHidden = false
                    
                    
                    button.translatesAutoresizingMaskIntoConstraints = false
                    let heightLayout = NSLayoutConstraint.init(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 57)
                    self.view.addConstraints([
                        heightLayout,
                        NSLayoutConstraint.init(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
                        NSLayoutConstraint.init(item: button, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
                        NSLayoutConstraint.init(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),
                                             
                                             ])
                    
                }
                break;
            }
        
            
        }
    }
    
    @objc func tapDismiss() {
        self.dismiss(animated: true)
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: SHAlertController.Style) {
        self.init()
        self.preferredStyle = preferredStyle
        self.title = title
        self.message = message
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open func addAction(_ action: SHAlertAction) {
        actions.append(action)
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate methods
        
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SHAlertTransitionAnimator.init(bgView: self.bgView)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    deinit {
        print("deinit \(self)")
    }
}


public protocol SHActionProtocol: UIView {
    var action: ((Self) -> Void)? {set get}
}

class SHActionView: UIButton,SHActionProtocol {
    lazy var effectView: UIVisualEffectView = {
        let blur =  UIBlurEffect.init(style: UIBlurEffect.Style.extraLight)
        let effectView = UIVisualEffectView.init(effect: blur)
        
        return effectView
    }()
    var action: ((SHActionView) -> Void)?
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = .lightGray.withAlphaComponent(0.5)
                self.effectView.alpha = 0
            } else {
                self.backgroundColor = .clear
                self.effectView.alpha = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initConfig()
    }
    
    func initConfig() {
        self.addSubview(effectView)
        effectView.isHidden = true
        effectView.isUserInteractionEnabled = false
        self.addTarget(self, action: #selector(self.btnClick), for: UIControl.Event.touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        effectView.frame = self.bounds
    }
    @objc func btnClick() {
        self.action?(self)
    }
    
}

class SHContentActionView: UIView {
    lazy var contentStackScroll: UIScrollView = .init()
    lazy var contentStack: UIStackView = UIStackView.init()
    var  layoutHeight: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    func initCommon() {
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
