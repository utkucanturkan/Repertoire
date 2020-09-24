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

    private var books = [Book]() {
        didSet {
            navigationItem.rightBarButtonItem = !books.isEmpty ? self.editButtonItem : nil
            navigationItem.searchController = !books.isEmpty ? searchController : nil
        }
    }
            
    private var bookRepository = BookRepository()
    
    // MARK: Searching
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredBooks = [Book]()
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isfiltering: Bool {
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
        searchController.searchBar.placeholder = "Search a book"
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    @IBAction func addBookButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Book", message: "Set a name of the new book", preferredStyle: .alert)
    
        alert.addTextField { textField in
            textField.placeholder = "Input a new book name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let newBookName = alert.textFields?.first?.text else { return }
            if newBookName.isValid {
                if let newBookIds = self.addNewBook(with: newBookName) {
                    let newBook = Book(localId: newBookIds.localId, globalId: newBookIds.globalId, name: newBookName)
                    self.books.append(newBook)
                    self.tableView.reloadData()
                    let bdvc = SongTableViewController()
                    bdvc.book = newBook
                    self.navigationController?.pushViewController(bdvc, animated: true)
                }
            }
        })
        
        self.present(alert, animated: true)
    }
    
    private func addNewBook(with name: String) -> (localId: Int64, globalId: String?)? {
        var newAddedBook: (localId: Int64, globalId: String?)
        newAddedBook.globalId = nil
        do {
            let bookEntity = BookEntity(userId: ApplicationUserSession.session!.localId, name: name)
            newAddedBook.localId = try bookRepository.insert(element: bookEntity)
            if !ApplicationUserSession.session!.islocal {
                
                // TODO: add a new book into the firebase cloud store, and set the globalId property of the newly added book
                
            }
            return newAddedBook
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func filterModelForSearchText(_ searchText: String) {
        filteredBooks = books.filter { book in
            return book.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    private func deleteBook(_ book: Book) {
        do {
            let deletedBookEntity = BookEntity(id: book.localId, userId: ApplicationUserSession.session!.localId, name: book.name)
            try bookRepository.delete(element: deletedBookEntity)
            if !ApplicationUserSession.session!.islocal {
                
                // TODO: delete book from firebase cloud store
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getBooksOfCurrentUser() {
        if ApplicationUserSession.session!.islocal {
            do {
                books = try bookRepository.getAllBy(userIdentifier: ApplicationUserSession.session!.localId)
                tableView.reloadData()
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
        let totalDataCount = isfiltering ? filteredBooks.count : books.count
        if totalDataCount == 0 {
            tableView.setEmptyView(title: "You have not any song book", message: isfiltering ? "" : "A new book can be added by + button on the left corner")
        } else {
            tableView.restore()
        }
        return totalDataCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstraints.bookCellIdentifier, for: indexPath) as! BookTableViewCell
        cell.book = isfiltering ? filteredBooks[indexPath.row] : books[indexPath.row]
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !books.isEmpty
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedBook = isfiltering ? filteredBooks.remove(at: indexPath.row) : books.remove(at: indexPath.row)
            if isfiltering {
                var itemIndex = 0
                for item in books {
                    if item.localId == deletedBook.localId {
                        books.remove(at: itemIndex)
                    }
                    itemIndex += 1
                }
            }
            deleteBook(deletedBook)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstraints.bookDetailViewControllerSegueIdentifier {
            if let bdvc = segue.destination as? SongTableViewController, let bcv = sender as? BookTableViewCell {
                bdvc.book = bcv.book
            }
        }
    }
}

extension BookTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterModelForSearchText(searchBar.text!)
    }
}

extension String {
    var isValid: Bool {
        return !self.isEmpty && !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
