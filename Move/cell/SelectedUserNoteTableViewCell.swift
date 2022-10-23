//
//  SelectedUserNoteTableViewCell.swift
//  Move
//
//  Created by 송경진 on 2022/10/23.
//

import UIKit

class SelectedUserNoteTableViewCell: UITableViewCell {

    @IBOutlet var date: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
