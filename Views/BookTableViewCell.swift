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
            songCount?.text = book.songCount == 0 ? "No Song" : "\(book.songCount) song(s)"
            createdDate?.text = format(date: book.createdDate, as: "MM/dd/yyyy")
        }
    }
    
    func format(date date:Date, as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
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
