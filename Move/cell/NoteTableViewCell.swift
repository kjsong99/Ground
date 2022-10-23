//
//  NoteTableViewCell.swift
//  Move
//
//  Created by 송경진 on 2022/10/23.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
