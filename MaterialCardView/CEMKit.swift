//
//  CEMKit.swift
//  CEMKit-Swift
//
//  Created by Cem Olcay on 05/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC


// MARK: - AppDelegate

// let APPDELEGATE: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate


// MARK: - UIView

let UIViewAnimationDuration: TimeInterval = 1
let UIViewAnimationSpringDamping: CGFloat = 0.5
let UIViewAnimationSpringVelocity: CGFloat = 0.5


extension UIView {

    // MARK: Custom Initilizer

    convenience init (x: CGFloat,
        y: CGFloat,
        w: CGFloat,
        h: CGFloat) {
            self.init (frame: CGRect (x: x, y: y, width: w, height: h))
    }

    convenience init (superView: UIView) {
        self.init (frame: CGRect (origin: CGPoint.zero, size: superView.size))
    }
}


// MARK: Frame Extensions

extension UIView {

    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    var w: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
        }
    }

    var h: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
        }
    }


    var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }

    var right: CGFloat {
        get {
            return self.x + self.w
        } set (value) {
            self.x = value - self.w
        }
    }

    var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }

    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (value) {
            self.y = value - self.h
        }
    }


    var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }

    var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: value)
        }
    }


    func leftWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }

    func rightWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }

    func topWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }

    func bottomWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }

}


// MARK: Transform Extensions

extension UIView {

    func setRotationX (_ x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)

        self.layer.transform = transform
    }

    func setRotationY (_ y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)

        self.layer.transform = transform
    }

    func setRotationZ (_ z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)

        self.layer.transform = transform
    }

    func setRotation (
        _ x: CGFloat,
        y: CGFloat,
        z: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
            transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
            transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)

            self.layer.transform = transform
    }


    func setScale (
        _ x: CGFloat,
        y: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DScale(transform, x, y, 1)

            self.layer.transform = transform
    }

}


// MARK: Layer Extensions

extension UIView {

    func setAnchorPosition (_ anchorPosition: AnchorPosition) {
        print(anchorPosition.rawValue)
        self.layer.anchorPoint = anchorPosition.rawValue
    }

    func setCornerRadius (_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func addShadow (
        _ offset: CGSize,
        radius: CGFloat,
        color: UIColor,
        opacity: Float,
        cornerRadius: CGFloat? = nil) {
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius
            self.layer.shadowOpacity = opacity
            self.layer.shadowColor = color.cgColor

            if let r = cornerRadius {
                self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
            }
    }

    func addBorder (
        _ width: CGFloat,
        color: UIColor) {
            self.layer.borderWidth = width
            self.layer.borderColor = color.cgColor
            self.layer.masksToBounds = true
    }

    func drawCircle (
        _ fillColor: UIColor,
        strokeColor: UIColor,
        strokeWidth: CGFloat) {
            let path = UIBezierPath (roundedRect: CGRect (x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)

            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = fillColor.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = strokeWidth

            self.layer.addSublayer(shapeLayer)
    }

    func drawStroke (
        _ width: CGFloat,
        color: UIColor) {
            let path = UIBezierPath (roundedRect: CGRect (x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)

            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = width

            self.layer.addSublayer(shapeLayer)
    }

    func drawArc (
        _ from: CGFloat,
        to: CGFloat,
        clockwise: Bool,
        width: CGFloat,
        fillColor: UIColor,
        strokeColor: UIColor,
        lineCap: String) {
            let path = UIBezierPath (arcCenter: self.center, radius: self.w/2, startAngle: degreesToRadians(from), endAngle: degreesToRadians(to), clockwise: clockwise)

            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = fillColor.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = width

            self.layer.addSublayer(shapeLayer)
    }

}


// MARK: Animation Extensions

extension UIView {

    func spring (
        _ animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
            spring(UIViewAnimationDuration,
                animations: animations,
                completion: completion)
    }

    func spring (
        _ duration: TimeInterval,
        animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
            UIView.animate(withDuration: UIViewAnimationDuration,
                delay: 0,
                usingSpringWithDamping: UIViewAnimationSpringDamping,
                initialSpringVelocity: UIViewAnimationSpringVelocity,
                options: UIViewAnimationOptions.allowAnimatedContent,
                animations: animations,
                completion: completion)
    }

    func animate (
        _ duration: TimeInterval,
        animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
            UIView.animate(withDuration: duration,
                animations: animations,
                completion: completion)
    }

    func animate (
        _ animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
            animate(
                UIViewAnimationDuration,
                animations: animations,
                completion: completion)
    }

    func pop () {
        setScale(1.1, y: 1.1)
        spring(0.2, animations: { [unowned self] () -> Void in
            self.setScale(1, y: 1)
            })
    }
}


// MARK: Render Extensions

extension UIView {

    func toImage () -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }
}


// MARK: Gesture Extensions

extension UIView {

    func addTapGesture (
        _ tapNumber: Int,
        target: AnyObject, action: Selector) {
            let tap = UITapGestureRecognizer (target: target, action: action)
            tap.numberOfTapsRequired = tapNumber
            addGestureRecognizer(tap)
            isUserInteractionEnabled = true
    }

    func addTapGesture (
        _ tapNumber: Int,
        action: ((UITapGestureRecognizer)->())?) {
            let tap = BlockTap (tapCount: tapNumber,
                fingerCount: 1,
                action: action)
            addGestureRecognizer(tap)
            isUserInteractionEnabled = true
    }

    func addSwipeGesture (
        _ direction: UISwipeGestureRecognizerDirection,
        numberOfTouches: Int,
        target: AnyObject,
        action: Selector) {
            let swipe = UISwipeGestureRecognizer (target: target, action: action)
            swipe.direction = direction
            swipe.numberOfTouchesRequired = numberOfTouches
            addGestureRecognizer(swipe)
            isUserInteractionEnabled = true
    }

    func addSwipeGesture (
        _ direction: UISwipeGestureRecognizerDirection,
        numberOfTouches: Int,
        action: ((UISwipeGestureRecognizer)->())?) {
            let swipe = BlockSwipe (direction: direction,
                fingerCount: numberOfTouches,
                action: action)
            addGestureRecognizer(swipe)
            isUserInteractionEnabled = true
    }

    func addPanGesture (
        _ target: AnyObject,
        action: Selector) {
            let pan = UIPanGestureRecognizer (target: target, action: action)
            addGestureRecognizer(pan)
            isUserInteractionEnabled = true
    }

    func addPanGesture (_ action: ((UIPanGestureRecognizer)->())?) {
        let pan = BlockPan (action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }

    func addPinchGesture (
        _ target: AnyObject,
        action: Selector) {
            let pinch = UIPinchGestureRecognizer (target: target, action: action)
            addGestureRecognizer(pinch)
            isUserInteractionEnabled = true
    }

    func addPinchGesture (_ action: ((UIPinchGestureRecognizer)->())?) {
        let pinch = BlockPinch (action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
    }

    func addLongPressGesture (
        _ target: AnyObject,
        action: Selector) {
            let longPress = UILongPressGestureRecognizer (target: target, action: action)
            addGestureRecognizer(longPress)
            isUserInteractionEnabled = true
    }

    func addLongPressGesture (_ action: ((UILongPressGestureRecognizer)->())?) {
        let longPress = BlockLongPress (action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }
}



// MARK: - UIScrollView

extension UIScrollView {

    var contentHeight: CGFloat {
        get {
            return contentSize.height
        } set (value) {
            contentSize = CGSize (width: contentSize.width, height: value)
        }
    }

    var contentWidth: CGFloat {
        get {
            return contentSize.height
        } set (value) {
            contentSize = CGSize (width: value, height: contentSize.height)
        }
    }

    var offsetX: CGFloat {
        get {
            return contentOffset.x
        } set (value) {
            contentOffset = CGPoint (x: value, y: contentOffset.y)
        }
    }

    var offsetY: CGFloat {
        get {
            return contentOffset.y
        } set (value) {
            contentOffset = CGPoint (x: contentOffset.x, y: value)
        }
    }
}


// MARK: - UIViewController

extension UIViewController {

    var top: CGFloat {
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.top
            }

            if let nav = self.navigationController {
                if nav.isNavigationBarHidden {
                    return view.top
                } else {
                    return nav.navigationBar.bottom
                }
            } else {
                return view.top
            }
        }
    }

    var bottom: CGFloat {
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.bottom
            }

            if let tab = tabBarController {
                if tab.tabBar.isHidden {
                    return view.bottom
                } else {
                    return tab.tabBar.top
                }
            } else {
                return view.bottom
            }
        }
    }


    var tabBarHeight: CGFloat {
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.tabBarHeight
            }

            if let tab = self.tabBarController {
                return tab.tabBar.frame.size.height
            }

            return 0
        }
    }


    var navigationBarHeight: CGFloat {
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.navigationBarHeight
            }

            if let nav = self.navigationController {
                return nav.navigationBar.h
            }

            return 0
        }
    }

    var navigationBarColor: UIColor? {
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.navigationBarColor
            }

            return navigationController?.navigationBar.tintColor
        } set (value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }

    var navBar: UINavigationBar? {
        get {
            return navigationController?.navigationBar
        }
    }


    var applicationFrame: CGRect {
        get {
            return CGRect (x: view.x, y: top, width: view.w, height: bottom - top)
        }
    }


    func push (_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    func pop () {
        navigationController?.popViewController(animated: true)
    }

    func present (_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }

    func dismiss (_ completion: (()->Void)?) {
        self.dismiss(animated: true, completion: completion)
    }
}

import ObjectiveC
// MARK: - UILabel

private var UILabelAttributedStringArray: UInt8 = 0

extension UILabel {

    var attributedStrings: [NSAttributedString]? {
        get {
            return objc_getAssociatedObject(self, &UILabelAttributedStringArray) as? [NSAttributedString]
        }
        set {
            objc_setAssociatedObject(self, &UILabelAttributedStringArray, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


    func addAttributedString (
        _ text: String,
        color: UIColor,
        font: UIFont) {
            let att = NSAttributedString (text: text, color: color, font: font)
            self.addAttributedString(att)
    }

    func addAttributedString (_ attributedString: NSAttributedString) {
        var att: NSMutableAttributedString?

        if let a = self.attributedText {
            att = NSMutableAttributedString (attributedString: a)
            att?.append(attributedString)
        } else {
            att = NSMutableAttributedString (attributedString: attributedString)
            attributedStrings = []
        }

        attributedStrings?.append(attributedString)
        self.attributedText = NSAttributedString (attributedString: att!)
    }



    func updateAttributedStringAtIndex (_ index: Int,
        attributedString: NSAttributedString) {

            if let _ = attributedStrings?[index] {
                attributedStrings?.remove(at: index)
                attributedStrings?.insert(attributedString, at: index)

                let updated = NSMutableAttributedString ()
                for att in attributedStrings! {
                    updated.append(att)
                }

                self.attributedText = NSAttributedString (attributedString: updated)
            }
    }

    func updateAttributedStringAtIndex (_ index: Int,
        newText: String) {
            if let att = attributedStrings?[index] {
                let newAtt = NSMutableAttributedString (string: newText)

                att.enumerateAttributes(in: NSMakeRange(0, att.string.characters.count-1),
                    options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired,
                    using: { (attribute, range, stop) -> Void in
                        for (key, value) in attribute {
                            newAtt.addAttribute(key , value: value, range: range)
                        }
                    }
                )

                updateAttributedStringAtIndex(index, attributedString: newAtt)
            }
    }



    func getEstimatedSize (
        _ width: CGFloat = CGFloat.greatestFiniteMagnitude,
        height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
            return sizeThatFits(CGSize(width: width, height: height))
    }

    func getEstimatedHeight () -> CGFloat {
        return sizeThatFits(CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)).height
    }

    func getEstimatedWidth () -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: h)).width
    }



    func fitHeight () {
        self.h = getEstimatedHeight()
    }

    func fitWidth () {
        self.w = getEstimatedWidth()
    }

    func fitSize () {
        self.fitWidth()
        self.fitHeight()
        sizeToFit()
    }



    // Text, TextColor, TextAlignment, Font

    convenience init (
        frame: CGRect,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: frame)
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font

            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: height))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font

            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font

            self.numberOfLines = 0
            self.fitHeight()
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        padding: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font

            self.numberOfLines = 0
            self.h = self.getEstimatedHeight() + 2*padding
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: CGRect (x: x, y: y, width: 10.0, height: 10.0))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font

            self.numberOfLines = 0
            self.fitSize()
    }



    // AttributedText

    convenience init (
        frame: CGRect,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: frame)
            self.attributedText = attributedText
            self.textAlignment = textAlignment

            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: height))
            self.attributedText = attributedText
            self.textAlignment = textAlignment

            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.attributedText = attributedText
            self.textAlignment = textAlignment

            self.numberOfLines = 0
            self.fitHeight()
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        padding: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.attributedText = attributedText
            self.textAlignment = textAlignment

            self.numberOfLines = 0
            self.fitHeight()
            self.h += padding*2
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: 10.0, height: 10.0))
            self.attributedText = attributedText
            self.textAlignment = textAlignment

            self.numberOfLines = 0
            self.fitSize()
    }

}



// MARK: NSAttributedString

extension NSAttributedString {

    enum NSAttributedStringStyle {
        case plain
        case underline (NSUnderlineStyle, UIColor)
        case strike (UIColor, CGFloat)

        func attribute () -> [NSString: NSObject] {
            switch self {

            case .plain:
                return [:]

            case .underline(let styleName, let color):
                return [NSUnderlineStyleAttributeName as NSString: styleName.rawValue as NSObject, NSUnderlineColorAttributeName as NSString: color]

            case .strike(let color, let width):
                return [NSStrikethroughColorAttributeName as NSString: color, NSStrikethroughStyleAttributeName as NSString: width as NSObject]
            }
        }
    }

    func addAtt (_ attribute: [NSString: NSObject]) -> NSAttributedString {
        let mutable = NSMutableAttributedString (attributedString: self)
        let c = string.characters.count

        for (key, value) in attribute {
            mutable.addAttribute(key as String, value: value, range: NSMakeRange(0, c))
        }

        return mutable
    }

    func addStyle (_ style: NSAttributedStringStyle) -> NSAttributedString {
        return addAtt(style.attribute())
    }



    convenience init (
        text: String,
        color: UIColor,
        font: UIFont,
        style: NSAttributedStringStyle = .plain) {
            var atts: [String: AnyObject] = [NSFontAttributeName as String: font, NSForegroundColorAttributeName as String: color]
            for (key, value) in style.attribute() {
                atts.updateValue(value, forKey:key as String)
            }

            self.init (string: text, attributes: atts)
    }

    convenience init (image: UIImage) {
        let att = NSTextAttachment ()
        att.image = image
        self.init (attachment: att)
    }


    class func withAttributedStrings (_ mutableString: (NSMutableAttributedString)->()) -> NSAttributedString {
        let mutable = NSMutableAttributedString ()
        mutableString (mutable)
        return mutable
    }
}



// MARK: - String

extension String {
    subscript (i: Int) -> String {
        return String(Array(self.characters)[i])
    }
}



// MARK: - UIFont

enum FontType: String {
    case Regular = "Regular"
    case Bold = "Bold"
    case DemiBold = "DemiBold"
    case Light = "Light"
    case UltraLight = "UltraLight"
    case Italic = "Italic"
    case Thin = "Thin"
    case Book = "Book"
    case Roman = "Roman"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case CondensedMedium = "CondensedMedium"
    case CondensedExtraBold = "CondensedExtraBold"
    case SemiBold = "SemiBold"
    case BoldItalic = "BoldItalic"
    case Heavy = "Heavy"
}

enum FontName: String {
    case HelveticaNeue = "HelveticaNeue"
    case Helvetica = "Helvetica"
    case Futura = "Futura"
    case Menlo = "Menlo"
    case Avenir = "Avenir"
    case AvenirNext = "AvenirNext"
    case Didot = "Didot"
    case AmericanTypewriter = "AmericanTypewriter"
    case Baskerville = "Baskerville"
    case Geneva = "Geneva"
    case GillSans = "GillSans"
    case SanFranciscoDisplay = "SanFranciscoDisplay"
    case Seravek = "Seravek"
}

extension UIFont {

    class func PrintFontFamily (_ font: FontName) {
        let arr = UIFont.fontNames(forFamilyName: font.rawValue)
        for name in arr {
            print(name)
        }
    }

    class func Font (
        _ name: FontName,
        type: FontType,
        size: CGFloat) -> UIFont {
            return UIFont (name: name.rawValue + "-" + type.rawValue, size: size)!
    }

    class func HelveticaNeue (
        _ type: FontType,
        size: CGFloat) -> UIFont {
            return Font(.HelveticaNeue, type: type, size: size)
    }

    class func AvenirNext (
        _ type: FontType,
        size: CGFloat) -> UIFont {
            return UIFont.Font(.AvenirNext, type: type, size: size)
    }

    class func AvenirNextDemiBold (_ size: CGFloat) -> UIFont {
        return AvenirNext(.DemiBold, size: size)
    }

    class func AvenirNextRegular (_ size: CGFloat) -> UIFont {
        return AvenirNext(.Regular, size: size)
    }
}



// MARK: - UIImageView

extension UIImageView {

    convenience init (
        frame: CGRect,
        imageName: String) {
            self.init (frame: frame, image: UIImage (named: imageName)!)
    }

    convenience init (
        frame: CGRect,
        image: UIImage) {
            self.init (frame: frame)
            self.image = image
            self.contentMode = .scaleAspectFit
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        image: UIImage) {
            self.init (frame: CGRect (x: x, y: y, width: width, height: image.aspectHeightForWidth(width)), image: image)
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        height: CGFloat,
        image: UIImage) {
            self.init (frame: CGRect (x: x, y: y, width: image.aspectWidthForHeight(height), height: height), image: image)
    }


    func imageWithUrl (_ url: String) {
        imageRequest(url, success: { (image) -> Void in
            if let _ = image {
                self.image = image
            }
        })
    }

    func imageWithUrl (_ url: String, placeholder: UIImage) {
        self.image = placeholder
        imageRequest(url, success: { (image) -> Void in
            if let _ = image {
                self.image = image
            }
        })
    }

    func imageWithUrl (_ url: String, placeholderNamed: String) {
        self.image = UIImage (named: placeholderNamed)
        imageRequest(url, success: { (image) -> Void in
            if let _ = image {
                self.image = image
            }
        })
    }
}



// MARK: - UIImage

extension UIImage {

    func aspectResizeWithWidth (_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    func aspectResizeWithHeight (_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }


    func aspectHeightForWidth (_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }

    func aspectWidthForHeight (_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
}



// MARK: - UIColor

extension UIColor {

    class func randomColor () -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())

        return UIColor(red: randomRed,
            green: randomGreen,
            blue: randomBlue,
            alpha: 1.0)
    }

    class func RGBColor (
        _ r: CGFloat,
        g: CGFloat,
        b: CGFloat) -> UIColor {
            return UIColor (red: r / 255.0,
                green: g / 255.0,
                blue: b / 255.0,
                alpha: 1)
    }

    class func RGBAColor (
        _ r: CGFloat,
        g: CGFloat,
        b: CGFloat,
        a: CGFloat) -> UIColor {
            return UIColor (red: r / 255.0,
                green: g / 255.0,
                blue: b / 255.0,
                alpha: a)
    }

    class func BarTintRGBColor (
        _ r: CGFloat,
        g: CGFloat,
        b: CGFloat) -> UIColor {
            return UIColor (red: (r / 255.0) - 0.12,
                green: (g / 255.0) - 0.12,
                blue: (b / 255.0) - 0.12,
                alpha: 1)
    }

    class func Gray (_ gray: CGFloat) -> UIColor {
        return self.RGBColor(gray, g: gray, b: gray)
    }

    class func Gray (_ gray: CGFloat, alpha: CGFloat) -> UIColor {
        return self.RGBAColor(gray, g: gray, b: gray, a: alpha)
    }
}



// MARK - UIScreen

extension UIScreen {

    class var Orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
    }

    class var ScreenWidth: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(Orientation) {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }

    class var ScreenHeight: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(Orientation) {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }

    class var StatusBarHeight: CGFloat {
        get {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}



// MARK: - Array

extension Array {
    mutating func removeObject<U: Equatable> (_ object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }

        if(index != nil) {
            self.remove(at: index!)
        }
    }
}



// MARK: - CGSize

func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize (width: left.width + right.width, height: left.height + right.height)
}

func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize (width: left.width - right.width, height: left.width - right.width)
}



// MARK: - CGPoint

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint (x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint (x: left.x - right.x, y: left.y - right.y)
}


enum AnchorPosition: CGPoint {
    case topLeft        = "{0, 0}"
    case topCenter      = "{0.5, 0}"
    case topRight       = "{1, 0}"

    case midLeft        = "{0, 0.5}"
    case midCenter      = "{0.5, 0.5}"
    case midRight       = "{1, 0.5}"

    case bottomLeft     = "{0, 1}"
    case bottomCenter   = "{0.5, 1}"
    case bottomRight    = "{1, 1}"
}

extension CGPoint: ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }

    public init(unicodeScalarLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }
}



// MARK: - CGFloat

func degreesToRadians (_ angle: CGFloat) -> CGFloat {
    return (CGFloat (M_PI) * angle) / 180.0
}


func normalizeValue (
    _ value: CGFloat,
    min: CGFloat,
    max: CGFloat) -> CGFloat {
        return (max - min) / value
}


func convertNormalizedValue (
    _ normalizedValue: CGFloat,
    min: CGFloat,
    max: CGFloat) -> CGFloat {
        return ((max - min) * normalizedValue) + min
}


func clamp (
    _ value: CGFloat,
    minimum: CGFloat,
    maximum: CGFloat) -> CGFloat {
        return min (maximum, max(value, minimum))
}


func aspectHeightForTargetAspectWidth (
    _ currentHeight: CGFloat,
    currentWidth: CGFloat,
    targetAspectWidth: CGFloat) -> CGFloat {
        return (targetAspectWidth * currentHeight) / currentWidth
}


func aspectWidthForTargetAspectHeight (
    _ currentHeight: CGFloat,
    currentWidth: CGFloat,
    targetAspectHeight: CGFloat) -> CGFloat {
        return (targetAspectHeight * currentWidth) / currentHeight
}



// MARK: - Dictionary

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>,
    right: Dictionary<KeyType, ValueType>) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
}



// MARK: - Dispatch

func delay (
    _ seconds: Double,
    queue: DispatchQueue = DispatchQueue.main,
    after: @escaping ()->()) {

        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
}



// MARK: - DownloadTask

func urlRequest (
    _ url: String,
    success: @escaping (Data?)->Void,
    error: ((NSError)->Void)? = nil) {
        NSURLConnection.sendAsynchronousRequest(
            URLRequest (url: URL (string: url)!),
            queue: OperationQueue.main,
            completionHandler: { response, data, err in
                if let e = err {
                    error? (e as NSError)
                } else {
                    success (data)
                }
        })
}

func imageRequest (
    _ url: String,
    success: @escaping (UIImage?)->Void) {
        urlRequest(url, success: { (data) -> Void in
            if let d = data {
                success (UIImage (data: d))
            }
        })
}

func jsonRequest (
    _ url: String,
    success: @escaping ((Any?)->Void),
    error: ((NSError)->Void)?) {
        urlRequest(
            url,
            success: { (data)->Void in
                let json: Any? = dataToJsonDict(data)
                success (json)
            },
            error: { (err)->Void in
                if let e = error {
                    e (err)
                }
        })
}

func dataToJsonDict (_ data: Data?) -> Any? {

    if let d = data {
        var error: NSError?
        let json: Any?
        do {
            json = try JSONSerialization.jsonObject(
                with: d,
                options: JSONSerialization.ReadingOptions.allowFragments)
        } catch let error1 as NSError {
            error = error1
            json = nil
        }

        if let _ = error {
            return nil
        } else {
            return json
        }
    } else {
        return nil
    }
}



// MARK: - UIAlertController

@available(iOS 8.0, *)
func alert (
    _ title: String,
    message: String,
    cancelAction: ((UIAlertAction?)->Void)? = nil,
    okAction: ((UIAlertAction?)->Void)? = nil) -> UIAlertController {
        let a = UIAlertController (title: title, message: message, preferredStyle: .alert)

        if let ok = okAction {
            a.addAction(UIAlertAction(title: "OK", style: .default, handler: ok))
            a.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction))
        } else {
            a.addAction(UIAlertAction(title: "OK", style: .cancel, handler: cancelAction))
        }

        return a
}

@available(iOS 8.0, *)
func actionSheet (
    _ title: String,
    message: String,
    actions: [UIAlertAction]) -> UIAlertController {
        let a = UIAlertController (title: title, message: message, preferredStyle: .actionSheet)

        for action in actions {
            a.addAction(action)
        }

        return a
}



// MARK: - UIBarButtonItem

func barButtonItem (
    _ imageName: String,
    size: CGFloat,
    action: @escaping (AnyObject)->()) -> UIBarButtonItem {
        let button = BlockButton (frame: CGRect(x: 0, y: 0, width: size, height: size))
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.actionBlock = action

        return UIBarButtonItem (customView: button)
}

func barButtonItem (
    _ imageName: String,
    action: @escaping (AnyObject)->()) -> UIBarButtonItem {
        return barButtonItem(imageName, size: 20, action: action)
}

func barButtonItem (
    _ title: String,
    color: UIColor,
    action: @escaping (AnyObject)->()) -> UIBarButtonItem {
        let button = BlockButton (frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(color, for: UIControlState())
        button.actionBlock = action
        button.sizeToFit()

        return UIBarButtonItem (customView: button)
}



// MARK: - BlockButton

open class BlockButton: UIButton {

    // init (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
    //     super.init (frame: CGRectMake (x, y, w, h))
    // }
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var actionBlock: ((_ sender: BlockButton) -> ())? {
        didSet {
            self.addTarget(self, action: #selector(BlockButton.action(_:)), for: UIControlEvents.touchUpInside)
        }
    }

    func action (_ sender: BlockButton) {
        actionBlock! (sender)
    }
}



// MARK: - BlockWebView

open class BlockWebView: UIWebView, UIWebViewDelegate {

    var didStartLoad: ((URLRequest) -> ())?
    var didFinishLoad: ((URLRequest) -> ())?
    var didFailLoad: ((URLRequest, NSError) -> ())?

    var shouldStartLoadingRequest: ((URLRequest) -> (Bool))?

    // override init!(frame: CGRect) {
    //     super.init(frame: frame)
    //     delegate = self
    // }
    //
    // required init?(coder aDecoder: NSCoder) {
    //     super.init(coder: aDecoder)
    // }


    open func webViewDidStartLoad(_ webView: UIWebView) {
        didStartLoad? (webView.request!)
    }

    open func webViewDidFinishLoad(_ webView: UIWebView) {
        didFinishLoad? (webView.request!)
    }

    open func webView(
        _ webView: UIWebView,
        didFailLoadWithError error: Error) {
            didFailLoad? (webView.request!, error as NSError)
    }

    open func webView(
        _ webView: UIWebView,
        shouldStartLoadWith request: URLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            if let should = shouldStartLoadingRequest {
                return should (request)
            } else {
                return true
            }
    }

}



// MARK: BlockTap

open class BlockTap: UITapGestureRecognizer {

    fileprivate var tapAction: ((UITapGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (
        tapCount: Int,
        fingerCount: Int,
        action: ((UITapGestureRecognizer) -> Void)?) {
            self.init()
            self.numberOfTapsRequired = tapCount
            self.numberOfTouchesRequired = fingerCount
            self.tapAction = action
            self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
    }

    func didTap (_ tap: UITapGestureRecognizer) {
        tapAction? (tap)
    }

}


// MARK: BlockPan

open class BlockPan: UIPanGestureRecognizer {

    fileprivate var panAction: ((UIPanGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (action: ((UIPanGestureRecognizer) -> Void)?) {
        self.init()
        self.panAction = action
        self.addTarget(self, action: #selector(BlockPan.didPan(_:)))
    }

    func didPan (_ pan: UIPanGestureRecognizer) {
        panAction? (pan)
    }
}



// MARK: BlockSwipe

open class BlockSwipe: UISwipeGestureRecognizer {

    fileprivate var swipeAction: ((UISwipeGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (direction: UISwipeGestureRecognizerDirection,
        fingerCount: Int,
        action: ((UISwipeGestureRecognizer) -> Void)?) {
            self.init()
            self.direction = direction
            numberOfTouchesRequired = fingerCount
            swipeAction = action
            addTarget(self, action: #selector(BlockSwipe.didSwipe(_:)))
    }

    func didSwipe (_ swipe: UISwipeGestureRecognizer) {
        swipeAction? (swipe)
    }
}



// MARK: BlockPinch

open class BlockPinch: UIPinchGestureRecognizer {

    fileprivate var pinchAction: ((UIPinchGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (action: ((UIPinchGestureRecognizer) -> Void)?) {
        self.init()
        pinchAction = action
        addTarget(self, action: #selector(BlockPinch.didPinch(_:)))
    }

    func didPinch (_ pinch: UIPinchGestureRecognizer) {
        pinchAction? (pinch)
    }
}



// MARK: BlockLongPress

open class BlockLongPress: UILongPressGestureRecognizer {

    fileprivate var longPressAction: ((UILongPressGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (action: ((UILongPressGestureRecognizer) -> Void)?) {
        self.init()
        longPressAction = action
        addTarget(self, action: #selector(BlockLongPress.didLongPressed(_:)))
    }

    func didLongPressed (_ longPress: UILongPressGestureRecognizer) {
        longPressAction? (longPress)
    }
}
