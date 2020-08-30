//
//  BookTableViewCell.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    var model: BookViewModel? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var songCount: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    
    private func updateCell() {
        if let book = model {
            name?.text = book.name
            songCount?.text = "\(book.songCount)"
            createdDate?.text = book.createdDate.description
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
