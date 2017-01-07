//
//  MaterialCardView.swift
//  MaterialCardView
//
//  Created by Cem Olcay on 22/01/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

enum MaterialAnimationTimingFunction {
    case swiftEnterInOut
    case swiftExitInOut

    func timingFunction () -> CAMediaTimingFunction {
        switch self {

        case .swiftEnterInOut:
            return CAMediaTimingFunction (controlPoints: 0.4027, 0, 0.1, 1)

        case .swiftExitInOut:
            return CAMediaTimingFunction (controlPoints: 0.4027, 0, 0.2256, 1)
        }
    }
}

enum MaterialRippleLocation {
    case center
    case touchLocation
}


extension UIView {

    func addRipple (_ action: (()->Void)?) {
        addRipple(true, action: action)
    }

    func addRipple (
        _ withOverlay: Bool,
        action: (()->Void)?) {
            addRipple(
                UIColor.Gray(51, alpha: 0.1),
                duration: 0.9,
                location: .touchLocation,
                withOverlay: withOverlay,
                action: action)
    }

    func addRipple (
        _ color: UIColor,
        duration: TimeInterval,
        location: MaterialRippleLocation,
        withOverlay: Bool,
        action: (()->Void)?) {

            let ripple = RippleLayer (
                superLayer: layer,
                color: color,
                animationDuration: duration,
                location: location,
                withOverlay: withOverlay,
                action: action)

            addTapGesture(1, action: { [unowned self] (tap) -> () in
                ripple.animate(tap.location (in: self))
                action? ()
                })
    }
}

@objc open class RippleLayer: CALayer {


    // MARK: Properties

    var color: UIColor!
    var animationDuration: TimeInterval!
    var location: MaterialRippleLocation! = .touchLocation

    var action: (()->Void)?
    var overlay: CALayer?



    // MARK: Animations

    lazy var rippleAnimation: CAAnimation = {
        let scale = CABasicAnimation (keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 15

        let opacity = CABasicAnimation (keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1
        opacity.autoreverses = true
        opacity.duration = self.animationDuration / 2

        let anim = CAAnimationGroup ()
        anim.animations = [scale, opacity]
        anim.duration = self.animationDuration
        anim.timingFunction = MaterialAnimationTimingFunction.swiftEnterInOut.timingFunction()

        return anim
        } ()

    lazy var overlayAnimation: CABasicAnimation = {
        let overlayAnim = CABasicAnimation (keyPath: "opacity")
        overlayAnim.fromValue = 1
        overlayAnim.toValue = 0
        overlayAnim.duration = self.animationDuration
        overlayAnim.timingFunction = MaterialAnimationTimingFunction.swiftEnterInOut.timingFunction()

        return overlayAnim
        } ()



    // MARK: Lifecylce

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    init (
        superLayer: CALayer,
        color: UIColor,
        animationDuration: TimeInterval,
        location: MaterialRippleLocation,
        withOverlay: Bool,
        action: (()->Void)?) {

            super.init()
            self.color = color
            self.animationDuration = animationDuration
            self.location = location
            self.action = action

            initRipple(superLayer)

            if withOverlay {
                initOverlay(superLayer)
            }
    }



    // MARK: Setup

    func initOverlay (_ superLayer: CALayer) {
        overlay = CALayer ()
        overlay!.frame = superLayer.frame
        overlay!.backgroundColor = UIColor.Gray(0, alpha: 0.05).cgColor
        overlay!.opacity = 0
        superLayer.addSublayer(overlay!)
    }

    func initRipple (_ superLayer: CALayer) {
        let size = min(superLayer.frame.size.width, superLayer.frame.size.height) / 2
        frame = CGRect (x: 0, y: 0, width: size, height: size)
        backgroundColor = color.cgColor
        opacity = 0
        cornerRadius = size/2

        masksToBounds = true
        superLayer.masksToBounds = true
        superLayer.addSublayer(self)
    }



    // MARK: Animate

    func animate (_ touchLocation: CGPoint) {

        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        if location == .touchLocation {
            position = touchLocation
        } else {
            position = superlayer!.position
        }
        CATransaction.commit()

        let animationGroup = rippleAnimation as! CAAnimationGroup
        if let over = overlay {
            over.add(overlayAnimation, forKey: "overlayAnimation")
        }

        add(animationGroup, forKey: "rippleAnimation")
    }

}


extension UIColor {

    class func CardHeaderColor () -> UIColor {
        return Gray(242)
    }

    class func CardCellColor () -> UIColor {
        return Gray(249)
    }

    class func CardBorderColor () -> UIColor {
        return Gray(200)
    }


    class func RippleColor () -> UIColor {
        return UIColor.Gray(51, alpha: 0.1)
    }

    class func ShadowColor () -> UIColor {
        return UIColor.Gray(51)
    }


    class func TitleColor () -> UIColor {
        return Gray(51)
    }

    class func TextColor () -> UIColor {
        return Gray(144)
    }
}

extension UIFont {

    class func TitleFont () -> UIFont {
        return AvenirNextDemiBold(15)
    }

    class func TextFont () -> UIFont {
        return AvenirNextRegular(13)
    }
}


@objc open class MaterialCardAppearance : NSObject {

    var headerBackgroundColor: UIColor
    var cellBackgroundColor: UIColor
    var borderColor: UIColor

    var titleFont: UIFont
    var titleColor: UIColor

    var textFont: UIFont
    var textColor: UIColor

    var shadowColor: UIColor
    var rippleColor: UIColor
    var rippleDuration: TimeInterval

    init (
        headerBackgroundColor: UIColor,
        cellBackgroundColor: UIColor,
        borderColor: UIColor,
        titleFont: UIFont,
        titleColor: UIColor,
        textFont: UIFont,
        textColor: UIColor,
        shadowColor: UIColor,
        rippleColor: UIColor,
        rippleDuration: TimeInterval) {

            self.headerBackgroundColor = headerBackgroundColor
            self.cellBackgroundColor = cellBackgroundColor
            self.borderColor = borderColor

            self.titleFont = titleFont
            self.titleColor = titleColor

            self.textFont = textFont
            self.textColor = textColor

            self.shadowColor = shadowColor
            self.rippleColor = rippleColor
            self.rippleDuration = rippleDuration
    }
}

@objc open class MaterialCardCell: UIView {


    // MARK: Constants

    let itemPadding: CGFloat = 16



    // MARK: Properties

    fileprivate var parentCard: MaterialCardView!

    var bottomLine: UIView?



    // MARK: Lifecyle

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init (card: MaterialCardView) {
        super.init(frame: CGRect(x: 0, y: 0, width: card.w, height: 0))
        parentCard = card
    }



    // MARK: Create

    func addTitle (_ title: String) {
        let title = UILabel (
            x: itemPadding,
            y: h,
            width: parentCard.w - itemPadding*2,
            padding: itemPadding,
            text: title,
            textColor: parentCard.appearance.titleColor,
            textAlignment: .left,
            font: parentCard.appearance.titleFont)
        addView(title)
    }

    func addText (_ text: String) {
        let text = UILabel (
            x: itemPadding,
            y: h,
            width: parentCard.w - itemPadding*2,
            padding: itemPadding,
            text: text,
            textColor: parentCard.appearance.textColor,
            textAlignment: .left,
            font: parentCard.appearance.textFont)
        addView(text)
    }

    func addView (_ view: UIView) {
        addSubview(view)
        h += view.h
    }


    func drawBottomLine () {
        if let _ = bottomLine {
            return
        }

        bottomLine = UIView (x: 0, y: h - 1, w: w, h: 1)
        bottomLine!.backgroundColor = parentCard.appearance.borderColor
        addSubview(bottomLine!)
    }

    func removeBottomLine () {
        if let l = bottomLine {
            l.removeFromSuperview()
            bottomLine = nil
        }
    }
}

@objc open class MaterialCardView: UIView {


    // MARK: Constants

    open let cardRadius: CGFloat = 3
    open let rippleDuration: TimeInterval = 0.9
    open let shadowOpacity: Float = 0.5
    open let shadowRadius: CGFloat = 1.5
    open let estimatedRowHeight: CGFloat = 53
    open let estimatedHeaderHeight: CGFloat = 40



    // MARK: Properties

    open var appearance: MaterialCardAppearance!
    open var items: [MaterialCardCell] = []
    open var contentView: UIView!



    // MARK: Lifecylce

    // required public init?(coder aDecoder: NSCoder) {
    //     super.init(coder: aDecoder)
    // }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    public convenience init(frame: CGRect, value: MaterialCardAppearance?) {
      self.init(frame: frame);
      h = 0
      if let valueConst = value {
        // http://stackoverflow.com/questions/27096863/how-to-check-for-an-undefined-or-null-variable-in-swift
        self.appearance = value
      } else {
        self.appearance = defaultAppearance()
      }

      self.contentView = UIView (superView: self)
      addSubview(self.contentView)
    }



    // MARK: Setup

    func defaultAppearance () -> MaterialCardAppearance {
        return MaterialCardAppearance (
            headerBackgroundColor: UIColor.CardHeaderColor(),
            cellBackgroundColor: UIColor.CardCellColor(),
            borderColor: UIColor.CardBorderColor(),
            titleFont: UIFont.TitleFont(),
            titleColor: UIColor.TitleColor(),
            textFont: UIFont.TextFont(),
            textColor: UIColor.TextColor(),
            shadowColor: UIColor.ShadowColor(),
            rippleColor: UIColor.RippleColor(),
            rippleDuration: rippleDuration)
    }



    // MARK: Card

    func updateFrame () {
        var current = 0
        var currentY: CGFloat = 0
        for item in items {
            item.y = currentY
            currentY += item.h

            item.removeBottomLine()
            current += 1
            if current < items.count {
                item.drawBottomLine()
            }
        }

        self.contentView.size = size
        materialize()
    }

    open func materialize () {

        self.contentView.backgroundColor = self.backgroundColor;

        addShadow(
            CGSize (width: 0, height: 1),
            radius: self.shadowRadius,
            color: UIColor.ShadowColor(),
            opacity: self.shadowOpacity,
            cornerRadius: self.cardRadius)

        self.contentView.setCornerRadius(self.cardRadius)
    }

    open func shadowRadiusAnimation (_ to: CGFloat) {

        let radiusAnim = CABasicAnimation (keyPath: "shadowRadius")
        radiusAnim.fromValue = layer.shadowRadius
        radiusAnim.toValue = to
        radiusAnim.duration = rippleDuration
        radiusAnim.timingFunction = MaterialAnimationTimingFunction.swiftEnterInOut.timingFunction()
        radiusAnim.autoreverses = true

        let offsetAnim = CABasicAnimation (keyPath: "shadowOffset")
        offsetAnim.fromValue = NSValue (cgSize: layer.shadowOffset)
        offsetAnim.toValue = NSValue (cgSize: layer.shadowOffset + CGSize (width: 0, height: to))
        offsetAnim.duration = rippleDuration
        offsetAnim.timingFunction = MaterialAnimationTimingFunction.swiftEnterInOut.timingFunction()
        offsetAnim.autoreverses = true

        let anim = CAAnimationGroup ()
        anim.animations = [radiusAnim, offsetAnim]
        anim.duration = rippleDuration*2
        anim.timingFunction = MaterialAnimationTimingFunction.swiftEnterInOut.timingFunction()

        layer.add(anim, forKey: "shadowAnimation")
    }

    override open func addRipple(_ action: (() -> Void)?) {
        self.contentView.addRipple(
            self.appearance.rippleColor,
            duration: self.appearance.rippleDuration,
            location: .touchLocation,
            withOverlay: false,
            action: { [unowned self] sender in
                self.shadowRadiusAnimation(6)
                action? ()
            })
    }



    // MARK: Add Cell

    open func addHeader (_ title: String) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = self.appearance.headerBackgroundColor

        cell.addTitle(title)
        cell.h = max (cell.h, estimatedHeaderHeight)

        items.insert(cell, at: 0)
        add(cell)
    }

    open func addHeaderView (_ view: UIView) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = self.appearance.headerBackgroundColor

        cell.addView(view)

        items.insert(cell, at: 0)
        add(cell)
    }


    open func addFooter (_ title: String) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = self.appearance.headerBackgroundColor

        cell.addTitle(title)
        cell.h = max (cell.h, estimatedHeaderHeight)

        items.insert(cell, at: items.count)
        add(cell)
    }

    open func addFooterView (_ view: UIView) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = self.appearance.headerBackgroundColor

        cell.addView(view)

        items.insert(cell, at: items.count)
        add(cell)
    }


    open func addCell (_ text: String, action: (()->Void)? = nil) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = self.appearance.cellBackgroundColor

        cell.addText(text)
        cell.h = max (cell.h, estimatedRowHeight)

        if let act = action {
            cell.addRipple(
                self.appearance.rippleColor,
                duration: self.appearance.rippleDuration,
                location: .touchLocation,
                withOverlay: true,
                action: act)
        }

        items.append(cell)
        add(cell)
    }

    open func addCellView (_ view: UIView, action: (()->Void)? = nil) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = self.appearance.cellBackgroundColor

        cell.addView(view)

        if let act = action {
            cell.addRipple(
                self.appearance.rippleColor,
                duration: self.appearance.rippleDuration,
                location: .touchLocation,
                withOverlay: true,
                action: act)
        }

        items.append(cell)
        add(cell)
    }

    open func addCell (_ cell: MaterialCardCell) {
        cell.backgroundColor = self.appearance.cellBackgroundColor

        items.append(cell)
        add(cell)
    }


    fileprivate func add (_ cell: MaterialCardCell) {
        self.contentView.addSubview(cell)
        h += cell.h

        updateFrame()
    }



    // MARK: Remove Cell

    func removeCellAtIndex (_ index: Int) {
        if index < items.count {
            let cell = items[index]
            removeCell(cell)
        }
    }

    func removeCell (_ cell: MaterialCardCell) {
        cell.removeFromSuperview()
        items.removeObject(cell)

        h -= cell.h
        updateFrame()
    }
}
