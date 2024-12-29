//
//  HistoryCompactCollectionViewCell.swift
//  Latvijas Radio
//
//  Created by andriy kruglyanko on 15.12.2024.
//  Copyright © 2024 Latvijas Radio. All rights reserved.
//

import UIKit

class HistoryCompactCollectionViewCell: UICollectionViewCell {

    static var TAG = String(describing: HistoryCompactCollectionViewCell.classForCoder())

    @IBOutlet weak var buttonDeleteFromHistory: UIButton!
    @IBOutlet weak var imageGenericPreview: UIImageView!
    @IBOutlet weak var textGenericPreview: UILabelLabel3!
    @IBOutlet weak var descrGenericPreview: UILabelLabel3!
    @IBOutlet weak var buttonChannel: UIButtonOctonary!
    @IBOutlet weak var buttonBroadcast: UIButtonOctonary!
}
