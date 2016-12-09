//
//  UINavigationBarExtension.swift
//  creams
//
//  Created by Rawlings on 08/12/2016.
//  Copyright © 2016 jiangren. All rights reserved.
//

import UIKit


extension UINavigationBar {
    private struct AssociatedKeys {
        static var overlayKey = "overlayKey"
    }
    
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}


extension UINavigationBar {
    
    func lt_setBackgroundColor(backgroundColor: UIColor) {
        if overlay == nil {
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            overlay = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height+20))
            overlay?.isUserInteractionEnabled = false
            overlay?.autoresizingMask = UIViewAutoresizing.flexibleWidth
            subviews.first?.insertSubview(overlay!, at: 0)
        }
        overlay?.backgroundColor = backgroundColor
    }
    
    
    func lt_setTranslationY(translationY: CGFloat) {
        transform = CGAffineTransform.init(translationX: 0, y: translationY)
    }
    
    
    func lt_setElementsAlpha(alpha: CGFloat) {
        for (_, element) in subviews.enumerated() {
            if element.isKind(of: NSClassFromString("UINavigationItemView") as! UIView.Type) ||
                element.isKind(of: NSClassFromString("UINavigationButton") as! UIButton.Type) ||
                element.isKind(of: NSClassFromString("UINavBarPrompt") as! UIView.Type)
            {
                element.alpha = alpha
            }
            
            if element.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView") as! UIView.Type) {
                element.alpha = element.alpha == 0 ? 0 : alpha
            }
        }
        
        items?.forEach({ (item) in
            if let titleView = item.titleView {
                titleView.alpha = alpha
            }
            for BBItems in [item.leftBarButtonItems, item.rightBarButtonItems] {
                BBItems?.forEach({ (barButtonItem) in
                    if let customView = barButtonItem.customView {
                        customView.alpha = alpha
                    }
                })
            }
        })
    }
    
    
    func lt_reset() {
        setBackgroundImage(nil, for: UIBarMetrics.default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
}
