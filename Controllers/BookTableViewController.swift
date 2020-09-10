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

    private var model = [BookViewModel]() {
        didSet {
            navigationItem.rightBarButtonItem = !model.isEmpty ? self.editButtonItem : nil
            navigationItem.searchController = !model.isEmpty ? searchController : nil
        }
    }
            
    private var bookRepository = BookRepository()
    
    // MARK: Searching
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredModel = [BookViewModel]()
    
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
                    let newBookViewmodel = BookViewModel(localId: newBookIds.localId, globalId: newBookIds.globalId, name: newBookName)
                    self.model.append(newBookViewmodel)
                    self.tableView.reloadData()
                    let bdvc = BookDetailTableViewController()
                    bdvc.bookModel = newBookViewmodel
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
            let book = Book(userId: ApplicationUserSession.session!.localId, name: name)
            newAddedBook.localId = try bookRepository.insert(element: book)
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
        filteredModel = model.filter { book in
            return book.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    private func deleteBook(_ bookViewModel: BookViewModel) {
        do {
            let deletedBook = Book(id: bookViewModel.localId, userId: ApplicationUserSession.session!.localId, name: bookViewModel.name)
            try bookRepository.delete(element: deletedBook)
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
                model = try bookRepository.getAllBy(userIdentifier: ApplicationUserSession.session!.localId)
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
        let totalDataCount = isfiltering ? filteredModel.count : model.count
        if totalDataCount == 0 {
            tableView.setEmptyView(title: "You have not any song book", message: isfiltering ? "" : "A new book can be added by + button on the left corner")
        } else {
            tableView.restore()
        }
        return totalDataCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstraints.bookCellIdentifier, for: indexPath) as! BookTableViewCell
        let book = isfiltering ? filteredModel[indexPath.row] : model[indexPath.row]
        cell.model = book
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !model.isEmpty
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedBook = isfiltering ? filteredModel.remove(at: indexPath.row) : model.remove(at: indexPath.row)
            
            // TODO: delete also model if filtering is active
            
            deleteBook(deletedBook)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstraints.bookDetailViewControllerSegueIdentifier {
            if let bdvc = segue.destination as? BookDetailTableViewController, let bcv = sender as? BookTableViewCell {
                bdvc.bookModel = bcv.model
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
