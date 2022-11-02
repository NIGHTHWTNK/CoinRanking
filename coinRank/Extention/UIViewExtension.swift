//
//  UIViewExtension.swift
//  BNK48
//
//  Created by Jeerapon on 14/9/2561 BE.
//  Copyright © 2561 Chompunut Soijit. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            if let border = layer.borderColor {
                return UIColor(cgColor: border)
            }

            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowViewColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.masksToBounds = false
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    var frameWidth: CGFloat {
        get {
            return frame.width
        }
        set {
            frame = CGRect(origin: frame.origin, size: CGSize(width: newValue, height: frame.size.height))
        }
    }

    var frameHeight: CGFloat {
        get {
            return frame.height
        }
        set {
            frame = CGRect(origin: frame.origin, size: CGSize(width: frame.size.width, height: newValue))
        }
    }

    func superviewOf<T: UIView>(_ type: T.Type) -> T? {
        return superview as? T ?? superview?.superviewOf(type)
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func addShadow(x: CGFloat = 0, y: CGFloat = 2, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 4.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = radius
    }

    func bounceAnimate(completionHandler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.09, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(withDuration: 0.09, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { _ in
                completionHandler()
            })
        })
    }

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        layer.add(animation, forKey: nil)
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func fitInView(_ container: UIView!, at index: Int? = nil) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        if let index = index {
            container.insertSubview(self, at: index)
        } else {
            container.addSubview(self);
        }
        
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        return view
    }
    
//    func addAppLogLongPressGesture() {
//        #if DEV
//        let reconizer = UILongPressGestureRecognizer(target: self, action: #selector(showAppLogCollector(sender:)))
//        self.addGestureRecognizer(reconizer)
//        self.isUserInteractionEnabled = true
//        #endif
//    }
//
//    @objc
//    private func showAppLogCollector(sender: UILongPressGestureRecognizer) {
//        if (sender.state == .began) {
//            AppAlert.logCollector()
//        }
//    }
}
