//
//  NSButton.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//


import UIKit

@IBDesignable class NSButton: UIButton {

    //MARK:- Var Declaration
    //Set Paddings
    @IBInspectable var paddingTop: CGFloat = 0
    @IBInspectable var paddingBottom: CGFloat = 0
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    //Set Font Size Initial
    @IBInspectable var fontSize: CGFloat = 15

    
    //Font Size Add For iPad
    @IBInspectable var iPadFontSize: CGFloat = 5
    
    //Font Size Add when >320
    @IBInspectable var iPhoneFontSize: CGFloat = 2
    
    //Set Back Ground image
    @IBInspectable var backgroundImage: UIImage = UIImage()
    
    //Set Border Color
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    //Set Border Width
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    //Set Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        self.setUp()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.setUp()
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    func setUp() {
        //Set BackGround UIImage
//        self.setBackgroundImage(backgroundImage, for: .normal)
        
        //Set Insects Of Text
        self.titleEdgeInsets = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        
        //Set Font Name and Font size
        self.titleLabel?.font = UIFont(name: self.titleLabel!.font.fontName, size: UIDevice.current.model == "iPad" ? fontSize + iPadFontSize : (ScreenSize.ScreenWidth > 320 ? fontSize + iPhoneFontSize : fontSize))
    }

}
