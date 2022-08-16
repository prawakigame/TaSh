//
//  CollectionViewCell.swift
//  TaSh
//
//  Created by katsuma saito on 2021/01/08.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
//    var testData : testData?
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            // cellの枠の太さ
            self.layer.borderWidth = 1.0
            // cellの枠の色
            self.layer.borderColor = UIColor.black.cgColor
            // cellを丸くする
            self.layer.cornerRadius = 8.0
    }
    
    
    
}
