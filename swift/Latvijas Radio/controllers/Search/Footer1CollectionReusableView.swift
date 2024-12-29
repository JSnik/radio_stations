//
//  Footer1CollectionReusableView.swift
//  Latvijas Radio
//
//  Created by andriy kruglyanko on 19.12.2024.
//  Copyright © 2024 Latvijas Radio. All rights reserved.
//

import UIKit

protocol ClearHistorySearchDelegate{
    func clearHistoryToClick()
}

class Footer1CollectionReusableView: UICollectionReusableView {
    var delegateClearHistorySearch: ClearHistorySearchDelegate?
    @IBOutlet weak var button1: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button1.setTitle("remove_all_history".localized(), for: .normal)
        button1.frame = CGRect(x: 16, y: 16, width: frame.width - 32, height: 44)
        button1.layer.cornerRadius = 16
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.gray.cgColor
        button1.titleLabel?.font = .systemFont(ofSize: 14)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .yellow
        //UIColor.clear

//        let button = UIButton(type: .system)
        // label1.text = "history_search".localized()
//                button1.setTitle("remove_all_history".localized(), for: .normal)
//                button1.frame = CGRect(x: 16, y: 16, width: frame.width - 32, height: 44)
//                button1.layer.cornerRadius = 16
//                button1.layer.borderWidth = 1
//                button1.layer.borderColor = UIColor.gray.cgColor
//                button1.titleLabel?.font = .systemFont(ofSize: 14)

//                addSubview(button)

     }
    
    @IBAction func clearHistoryClicked(_ sender: Any) {
        if self.delegateClearHistorySearch != nil {
            delegateClearHistorySearch?.clearHistoryToClick()
        }
    }
    
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

     }

}
