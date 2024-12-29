//
//  UILabelH4.swift
//  Latvijas Radio
//
//  Created by Sandis Putnis on 13/12/2021.
//

import UIKit

class UILabelH4: UILabelBase {
    
    override func setStyle() {
        let customFont = UIFont(name: "FuturaPT-Bold", size: 16.0)
        font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: 16.0))
        textColor = UIColor(named: ColorsHelper.BLACK)
    }
}
