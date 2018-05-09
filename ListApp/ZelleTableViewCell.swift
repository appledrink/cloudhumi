//
//  ZelleTableViewCell.swift
//  ListApp
//
//  Created by MacbookUNI on 22.11.17.
//  Copyright © 2017 MacbookUNI. All rights reserved.
//

import UIKit

class ZelleTableViewCell: UITableViewCell {

    weak var delegate: CellDelegate?
    
    @IBOutlet var Button: UIButton!
    
    @IBOutlet weak var TempLabel: UILabel!
    
    @IBOutlet weak var HumLabel: UILabel!
    
    @IBAction func updateIP(_ sender: UIButton) {
        delegate?.sendIP(self)
    
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    

        func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
}
