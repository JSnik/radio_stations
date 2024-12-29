//
//  Header1CollectionReusableView.swift
//  Latvijas Radio
//
//  Created by andriy kruglyanko on 19.12.2024.
//  Copyright © 2024 Latvijas Radio. All rights reserved.
//

import UIKit

class Header1CollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var label1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label1.text = "history_search".localized()

        let customFont = UIFont.systemFont(ofSize: 17.0)
        label1.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: 17.0))
        if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {

            label1.font = UIFont(descriptor: artistDescriptor,
                                size: 17.0)
        }
        label1.adjustsFontForContentSizeCategory = true
        label1.alpha = 0.9  // Equivalent to .opacity(0.9)
        label1.translatesAutoresizingMaskIntoConstraints = false
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        self.backgroundColor = .green //UIColor.yellow
////        let label = UILabel()
//        label1.text = "history_search".localized()
//
//        let customFont = UIFont.systemFont(ofSize: 17.0)
//        label1.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: 17.0))
//        if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {
//
//            label1.font = UIFont(descriptor: artistDescriptor,
//                                size: 17.0)
//        }
//        label1.adjustsFontForContentSizeCategory = true
//
//        //                    label.font = UIFont.preferredFont(forTextStyle: .headline)  // Equivalent to .font(.headline)
//        //            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        //label.font.withWeight(.bold)  // Equivalent to .fontWeight(.bold)
//        label1.alpha = 0.9  // Equivalent to .opacity(0.9)
//        label1.translatesAutoresizingMaskIntoConstraints = false
//
//        // Add label to the view
////        self.addSubview(label)
//
//        // Set up the constraints
////        NSLayoutConstraint.activate([
////            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
////            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
////            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
////            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
////        ])
//        // Customize here
//
//     }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

     }

}
