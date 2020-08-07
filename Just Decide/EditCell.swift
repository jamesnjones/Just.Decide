//
//  EditCell.swift
//  Just Decide
//
//  Created by James Jones on 20/07/2020.
//  Copyright © 2020 James Jones. All rights reserved.
//

import UIKit

class EditCell: UITableViewCell {

    @IBOutlet weak var editLabel: UILabel!
    
    var reuseID = "EditCell"
 
    func setSlices(slice: CarnivalWheel) {
        editLabel.text = slice.title
    }
}
