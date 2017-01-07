//
//  ViewController.swift
//  MaterialCardView
//
//  Created by Cem Olcay on 22/01/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        materialDemo()
    }

    func materialDemo () {
        
        let scroll = UIScrollView (frame: view.frame)
        view.addSubview(scroll)
        
        let r = CGRect(x: 10, y: UIScreen.StatusBarHeight + 10, width: UIScreen.ScreenWidth - 40, height: 40)
        
        let c = MaterialCardView(frame: r, value: nil)
        
        scroll.addSubview(c)
        
//        c.addHeader("Header")
        c.addCell("Item 1") { sender in print("item 1 tapped") }
        c.addCell("Item 2") { sender in print("item 2 tapped") }
//        c.addCell("Item 3") { sender in print("item 3 tapped") }
//        
//        
//        let cc = MaterialCardView (x: 10, y: c.bottomWithOffset(10), w: c.w, h: 40)
//        scroll.addSubview(cc)
//        
//        cc.addHeader("Header")
//        cc.addCell("Item 1") { sender in print("item 1 tapped") }
//        cc.addCell("Item 2") { sender in print("item 2 tapped") }
//        cc.addCell("Item 3") { sender in print("item 3 tapped") }
//        
//        
//        let ccc = MaterialCardView (x: 10, y: cc.bottomWithOffset(10), w: c.w, h: 40)
//        ccc.addCell("\n\nPlain Material Card\n\n")
//        
//        ccc.addRipple { () -> Void in
//            print("all card ripples")
//        }
//        
//        scroll.addSubview(ccc)
//        scroll.contentHeight = ccc.bottomWithOffset(10)
    }
    
    func addFooter (_ c: MaterialCardView) {
        let container = UIView (x: 0, y: 0, w: c.w, h: 0)
        
        let label = UILabel (
            x: 10,
            y: 0,
            width: c.w - 10,
            padding: 10,
            attributedText: NSAttributedString.withAttributedStrings({ (att: NSMutableAttributedString) -> () in
                att.append(NSAttributedString (
                    text: "Footer Label",
                    color: UIColor.TitleColor(),
                    font: UIFont.TitleFont(),
                    style: .plain))
                att.append(NSAttributedString (
                    text: "\nsome attributed string",
                    color: UIColor.TextColor(),
                    font: UIFont.TextFont(),
                    style: .underline(NSUnderlineStyle.styleSingle, UIColor.black)))
            }),
            textAlignment: .center)
        
        container.addSubview(label)
        container.h = label.h
    
        c.addFooterView(container)
    }
}

