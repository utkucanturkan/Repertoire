//
//  SongTableViewCell.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    var song: SongViewModel? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var name: UILabel!
    
    private func updateCell() {
        if let songModel = song {
            name?.text = songModel.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
