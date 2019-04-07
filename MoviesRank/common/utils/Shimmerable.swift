//
//  Shimmerable.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/6/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit

/*
 It is convenient if anything that can simmer conforms to this protocol
 */
protocol Shimmerable {
    func startShimmering(count: Int) -> Void
    func stopShimmering() -> Void
    var lightShimmerColor: UIColor {get set}
    var darkShimmerColor: UIColor {get set}
    var isShimmering: Bool {get}
}


@IBDesignable
extension UIView: Shimmerable {
    
    /*
     A way to store the custom properties
     */
    private struct UIViewCustomShimmerProperties {
        static let shimmerKey:String = "shimmer"
        static var lightShimmerColor:CGColor = UIColor.white.withAlphaComponent(0.1).cgColor
        static var darkShimmerColor:CGColor = UIColor.black.withAlphaComponent(1).cgColor
        static var isShimmering:Bool = false
        static var gradient:CAGradientLayer = CAGradientLayer()
        static var animation:CABasicAnimation = CABasicAnimation(keyPath: "locations")
    }
    
    /*
     Set shimmer properties
     */
    @IBInspectable
    var lightShimmerColor: UIColor {
        get {
            return UIColor(cgColor: UIViewCustomShimmerProperties.lightShimmerColor)
        }
        set {
            UIViewCustomShimmerProperties.lightShimmerColor = newValue.cgColor
        }
    }
    @IBInspectable
    var darkShimmerColor: UIColor {
        get {
            return UIColor(cgColor: UIViewCustomShimmerProperties.darkShimmerColor)
        }
        set {
            UIViewCustomShimmerProperties.darkShimmerColor = newValue.cgColor
        }
    }
    
    var isShimmering: Bool {
        get {
            return UIViewCustomShimmerProperties.isShimmering
        }
    }
    
    func stopShimmering() {
        guard UIViewCustomShimmerProperties.isShimmering else {return}
        self.layer.mask?.removeAnimation(forKey: UIViewCustomShimmerProperties.shimmerKey)
        self.layer.mask = nil
        UIViewCustomShimmerProperties.isShimmering = false
        self.layer.setNeedsDisplay()
    }
    
    func startShimmering(count: Int = 3) {
        guard !UIViewCustomShimmerProperties.isShimmering else {return}
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.stopShimmering()
        })
        
        UIViewCustomShimmerProperties.isShimmering = true
        
        UIViewCustomShimmerProperties.gradient.colors = [UIViewCustomShimmerProperties.darkShimmerColor, UIViewCustomShimmerProperties.lightShimmerColor, UIViewCustomShimmerProperties.darkShimmerColor];
        UIViewCustomShimmerProperties.gradient.frame = CGRect(x: CGFloat(-2*self.bounds.size.width), y: CGFloat(0.0), width: CGFloat(4*self.bounds.size.width), height: CGFloat(self.bounds.size.height))
        UIViewCustomShimmerProperties.gradient.startPoint = CGPoint(x: Double(0.0), y: Double(0.5));
        UIViewCustomShimmerProperties.gradient.endPoint = CGPoint(x: Double(1.0), y: Double(0.625));
        UIViewCustomShimmerProperties.gradient.locations = [0.4, 0.5, 0.6];
        
        UIViewCustomShimmerProperties.animation.duration = 1.0
        UIViewCustomShimmerProperties.animation.repeatCount = (count > 0) ? Float(count) : .infinity
        UIViewCustomShimmerProperties.animation.fromValue = [0.0, 0.12, 0.3]
        UIViewCustomShimmerProperties.animation.toValue = [0.6, 0.86, 1.0]
        
        UIViewCustomShimmerProperties.gradient.add(UIViewCustomShimmerProperties.animation, forKey: UIViewCustomShimmerProperties.shimmerKey)
        self.layer.mask = UIViewCustomShimmerProperties.gradient;
        
        CATransaction.commit()
    }
}
