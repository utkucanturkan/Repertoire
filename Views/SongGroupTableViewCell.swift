//
//  BookTableViewCell.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class SongGroupTableViewCell: UITableViewCell {
    
    private let DATE_FORMAT = "MM/dd/yyyy"
    
    var songGroup: SongGroup? {
        didSet {
            updateCell()
        }
    }
    
    private var songTypeImageIdentifier: String {
        return songGroup?.type == .book ? "book" : "newspaper"
    }
    
    @IBOutlet weak var songTypeImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var songCount: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    
    private func updateCell() {
        if let songGroup = songGroup {
            name?.text = songGroup.name
            songCount?.text = songGroup.songCount == 0 ? "No Song" : "\(songGroup.songCount) song(s)"
            createdDate?.text = songGroup.createdDate.format(as: DATE_FORMAT)
            songTypeImageView.image = UIImage(systemName: songTypeImageIdentifier)
        }
    }
}
