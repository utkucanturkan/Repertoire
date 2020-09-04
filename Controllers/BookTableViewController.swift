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
        
    var userSession: ApplicationUserSession {
        return try! UserDefaults.standard.getDecodable(with: AppConstraints.userSessionKey, by: ApplicationUserSession.self)
    }
    
    var bookRepository = BookRepository()
    
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
    
    @IBAction func addBookButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Book", message: "Set a name of the new book", preferredStyle: .alert)
    
                
        alert.addTextField { textField in
            textField.placeholder = "Input a new book name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            if let newBookName = alert.textFields?.first?.text {
                if let newBookIds = self.addNewBook(with: newBookName) {
                    let bdvc = BookDetailTableViewController()
                    let newBookViewmodel = BookViewModel(localId: newBookIds.localId, globalId: newBookIds.globalId, name: newBookName)
                    bdvc.model = newBookViewmodel
                    self.books.append(newBookViewmodel)
                    self.navigationController?.pushViewController(bdvc, animated: true)
                }
            }
        })
        
        self.present(alert, animated: true)
    }
    
    private func addNewBook(with name: String) -> (localId: Int64, globalId: String?)? {
        var result: (localId: Int64, globalId: String?)
        
        // !!!!
        result.globalId = nil
        
        do {
            let newBook = Book(userId: userSession.localId, name: name)
            result.localId = try bookRepository.insert(element: newBook)
            return result
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func filterModelForSearchText(_ searchText: String) {
        filteredBooks = books.filter { (book) in
            return book.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    private func getBooksOfCurrentUser() {
        if userSession.islocal {
            do {
                books = try bookRepository.getAllBy(userIdentifier: userSession.localId)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            
            // TODO: get books from firebase cloud store
            
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

    // MARK: - Navigation
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
