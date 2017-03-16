//
//  HeaderView.swift
//  ScrollTitle
//
//  Created by Vasiliy Kozlov on 13/03/2017.
//  Copyright © 2017 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    } 
    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let nib = UINib(nibName: "HeaderView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setTitle(title: String, desc: String) {
        self.titleLabel.text = title
        self.descLabel.text = desc
    }
}
