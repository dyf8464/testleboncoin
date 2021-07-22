//
//  Extension+UIView.swift
//  testleboncoin
//
//  Created by zhizi yuan on 20/07/2021.
//

import UIKit

extension UIView {

    /// configure Anchor and size
    /// - Parameters:
    ///   - top: top anchor
    ///   - bottom: bottom achor
    ///   - leading: leading achor
    ///   - trailing: trailing achor
    ///   - padding: achor constants (top, bottom, left, right)
    ///   - size: widthAnchor and heightAnchor
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    /// set cornerRadius 
    /// - Parameter radius: number radius
    func setRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.masksToBounds = true
    }
}
