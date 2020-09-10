//
//  BookDetailTableViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class BookDetailTableViewController: UITableViewController {
    
    var bookModel: BookViewModel? {
        didSet {
            getSongs()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var songRepository = SongRepository()
    
    private var songs = [SongViewModel]() {
        didSet {
            setNavigationItems()
            navigationItem.searchController = !songs.isEmpty ? searchController : nil
        }
    }
    
    private var filteredSong = [SongViewModel]()
    
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isfiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = bookModel?.name
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a song"
        definesPresentationContext = true
        setNavigationItems()
    }
    
    private func setNavigationItems() {
        let newSongBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSongButtonTapped))
        self.navigationItem.rightBarButtonItems = [newSongBarButton]
        if !songs.isEmpty {
            if self.navigationItem.rightBarButtonItems != nil {
                self.navigationItem.rightBarButtonItems!.append(self.editButtonItem)
            }
        }
    }
    
    @objc func addNewSongButtonTapped() {
        performSegue(withIdentifier: AppConstraints.addSongViewControllerIdentifier, sender: nil)
    }

    private func getSongs() {
        if let book = bookModel {
            if ApplicationUserSession.session!.islocal {
                do {
                    //songs = try songRepository.getAll(by: book.localId)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                // TODO: get from firebase cloud store
            }
        }
    }
    
    private func filterModelForSearchText(_ searchText: String) {
        filteredSong = songs.filter { song in
            return song.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalDataCount = isfiltering ? filteredSong.count : songs.count
        if totalDataCount == 0 {
            tableView.setEmptyView(title: "You have not any song", message: isfiltering ? "" : "A new song can be added by + button on the left corner")
        } else {
            tableView.restore()
        }
        return totalDataCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstraints.songCellIdentifier, for: indexPath) as! SongTableViewCell

        cell.song = isfiltering ? filteredSong[indexPath.row] : songs[indexPath.row]

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedSong = isfiltering ? filteredSong[indexPath.row] : songs[indexPath.row]
            
            // TODO: delete song from db and model even if filtering is active
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return !isfiltering
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case AppConstraints.addSongViewControllerIdentifier:
            if let svc = segue.destination as? SongViewController {
                svc.mode = .add
            }
        default:
            break
        }
    }
    

}

extension BookDetailTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterModelForSearchText(searchBar.text!)
    }
}
