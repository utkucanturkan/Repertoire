//
//  BookTableViewCell.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    var book: Book? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var songCount: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    
    private func updateCell() {
        if let book = book {
            name?.text = book.name
            songCount?.text = book.songCount == 0 ? "No Song" : "\(book.songCount) song(s)"
            createdDate?.text = format(date: book.createdDate, as: "MM/dd/yyyy")
        }
    }
    
    private func format(date: Date, as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
