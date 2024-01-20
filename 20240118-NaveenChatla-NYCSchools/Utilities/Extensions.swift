//
//  Extensions.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import Foundation
import UIKit

//MARK: - CORNER RADIUS EXTENSION FOR UIVIEW
extension UIView {
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.systemIndigo.cgColor
        layer.shadowOpacity = 2
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

extension NSObject {
    func showToast(message: String) {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
                return
            }
            if let rootViewController = keyWindow.rootViewController {
                let toastLabel = UILabel(frame: CGRect(x: 10, y: rootViewController.view.frame.size.height-125, width: rootViewController.view.frame.size.width - 20, height: 35))
                toastLabel.backgroundColor = UIColor(named: "707070")
                toastLabel.textColor = UIColor.white
                toastLabel.textAlignment = .center
                toastLabel.font = UIFont(name: "Montserrat-Light", size: 13.0)
                toastLabel.text = message
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 18
                toastLabel.clipsToBounds  =  true
                rootViewController.view.addSubview(toastLabel)
                
                UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveEaseOut, animations: {
                    toastLabel.alpha = 0.0
                }, completion: { (isCompleted) in
                    UIView.animate(withDuration: 3.0, delay: 2.0, options: .curveEaseIn, animations: {
                        toastLabel.alpha = 0.0
                    }, completion: {(isCompleted) in
                        toastLabel.removeFromSuperview()
                    })
                })
            }
        }
    }
    
    
}
