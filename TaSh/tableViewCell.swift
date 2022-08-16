//
//  tableViewCell.swift
//  TaSh
//
//  Created by katsuma saito on 2021/01/30.
//

import UIKit

class tableViewCell: UITableViewCell {
//    @IBOutlet weak var smallTaskTextField: UITextField!
//    
//    var smallTaskName : String = ""
    
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            // cellの枠の太さ
            self.layer.borderWidth = 1.0
            // cellの枠の色
            self.layer.borderColor = UIColor.black.cgColor
            // cellを丸くする
            self.layer.cornerRadius = 8.0
        
//        smallTaskTextField.frame = CGRect(x: 34, y: 16, width: 200, height: 60)
    }
    
}


