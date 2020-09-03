//
//  BookTableViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 27.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit
import SQLite
import Firebase

class BookTableViewController: UITableViewController {

    var books = [BookViewModel]() {
        didSet {
            tableView?.reloadData()
        }
    }
        
    var userSession: ApplicationUserSession? {
        return try? UserDefaults.standard.getDecodable(with: AppConstraints.userSessionKey, by: ApplicationUserSession.self)
    }
    
    // MARK: Searching
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredBooks = [BookViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isfiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Books"
        getBooksOfCurrentUser()
        
        // SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search any book of song"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func filterModelForSearchText(_ searchText: String) {
        filteredBooks = books.filter { (book) in
            return book.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    private func getBooksOfCurrentUser() {
        if let user = userSession {
            if user.islocal {
                let bookRepository = BookRepository()
                do {
                    books = try bookRepository.getAllBy(userIdentifier: user.localId)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                
                // TODO: get books from firebase cloud store
                
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isfiltering ? filteredBooks.count : books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstraints.bookCellIdentifier, for: indexPath) as! BookTableViewCell
        let book = isfiltering ? filteredBooks[indexPath.row] : books[indexPath.row]
        cell.model = book
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == AppConstraints.bookDetailViewControllerSegueIdentifier {
            if let bdvc = segue.destination as? BookDetailTableViewController, let bcv = sender as? BookTableViewCell {
                bdvc.model = bcv.model
            }
        }
        
    }
    

}

extension BookTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterModelForSearchText(searchBar.text!)
    }
}
