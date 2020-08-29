//
//  BookTableViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 27.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit
import SQLite

class BookTableViewController: UITableViewController {
    
    private func setFirstEntry(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: AppConstraints.firstEntryKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    var isMemberShipDone = false {
        didSet {
            if isMemberShipDone {
                createDatabase()
            }
        }
    }
    
    private func createDatabase() {
        let db = try? Connection("\(AppConstraints.databasePath)/db.sqlite3")
        
        // default expressions
        let created = Expression<Date>("created")
        let updated = Expression<Date?>("updated")
        let status = Expression<Bool>("status")
        
        let users = Table("users")
        let userId = Expression<Int64>("id")
        let userName = Expression<String>("userName")
        
        try? db?.run(users.create(ifNotExists: true) { t in
            t.column(userId, primaryKey: .autoincrement)
            t.column(userName)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
        })
        
        let books = Table("books")
        let bookId = Expression<Int64>("id")
        let bookName = Expression<String>("name")
        let bookUserId = Expression<Int64>("user_Id")
        
        try? db?.run(books.create(ifNotExists: true) { t in
            t.column(bookId, primaryKey: .autoincrement)
            t.column(bookName, unique: true)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
            t.column(userId)
            t.foreignKey(bookUserId, references: users, userId, delete: .cascade)
        })
        
        
        // Songs
        let songs = Table("songs")
        let songId = Expression<Int64>("id")
        let songName = Expression<String>("name")
        let songContent = Expression<String>("content")
        let mediaUrl = Expression<String?>("mediaUrl")
        
        try? db?.run(songs.create(ifNotExists: true) { t in
            t.column(songId, primaryKey: .autoincrement)
            t.column(songName, unique: true)
            t.column(songContent)
            t.column(mediaUrl)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
        })
        
        
        //BookSong
        let bookSong = Table("bookSong")
        let bookSongId = Expression<Int64>("id")
        let bookFK = Expression<Int64>("bookId")
        let songFK = Expression<Int64>("songId")
        
        try? db?.run(bookSong.create(ifNotExists: true){ t in
            t.column(bookSongId, primaryKey: .autoincrement)
            t.column(bookFK)
            t.column(songFK)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstEntry(false)
        self.title = "Books"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
