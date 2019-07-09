//
//  CharacterListTableViewCell.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

class CharacterListTableCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
    }
    
}
