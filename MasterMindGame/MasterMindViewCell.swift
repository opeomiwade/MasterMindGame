//
//  MasterMindViewCell.swift
//  MasterMindGame(Assignment 1)
//
//  Created by Ope Omiwade on 05/11/2021.
//

import UIKit

class MasterMindViewCell: UITableViewCell {

    @IBOutlet weak var ImageView1: UIImageView!
    @IBOutlet weak var ImageView2: UIImageView!
    @IBOutlet weak var ImageView3: UIImageView!
    @IBOutlet weak var ImageView4: UIImageView!
    @IBOutlet weak var bobImageView1: UIImageView!
    @IBOutlet weak var bobImageView2: UIImageView!
    @IBOutlet weak var bobImageView3: UIImageView!
    @IBOutlet weak var bobImageView4: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
