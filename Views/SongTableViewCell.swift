//
//  SongTableViewCell.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    var song: Song? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
       selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
       accessoryType = selected ? .checkmark : .none
    }
    
    @IBOutlet weak var lblSongName: UILabel!
    
    @IBOutlet weak var lblSongCategories: UILabel!
    
    private func updateCell() {
        if let songModel = song {
            lblSongName?.text = songModel.name
            if let categories = songModel.categories {
                lblSongCategories.text = categories.printItems(with: ",")
            } else {
                lblSongCategories.text = "No Category"
            }
        }
    }
}
