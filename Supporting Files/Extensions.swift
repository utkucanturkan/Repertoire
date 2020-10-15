//
//  Extensions.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func printItems(with deliminator: Character) -> String {
        var stringRepresentation = ""
        self.forEach { element in
            stringRepresentation += "\(element)\(deliminator.description) "
        }
        return stringRepresentation.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters)
    }
}

extension Date {
    func format(as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension UserDefaults {
    func setEncodable<Object>(object item: Object, with key:String) throws where Object: Encodable {
        do {
            let object = try JSONEncoder().encode(item)
            set(object, forKey: key)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getDecodable<Object>(with key: String, by type: Object.Type) throws -> Object where Object: Decodable {
        guard let object = data(forKey: key) else {
            throw ObjectSavableError.noValue
        }
        
        do {
            return try JSONDecoder().decode(type, from: object)
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.textColor = UIColor.lightGray
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        // Constraints
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
