//
//  BookDetailTableViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

enum songTableViewMode {
    case list
    case add
}

class SongTableViewController: UITableViewController {
    
    var book: Book?
    
    var mode: songTableViewMode = .list
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var songRepository = SongRepository()
    
    private var songs = [Song]() {
        didSet {
            setNavigationBarButtonItems()
            navigationItem.searchController = !songs.isEmpty ? searchController : nil
        }
    }
    
    private var filteredSong = [Song]()
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isfiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a song"
        definesPresentationContext = true
        
        setNavigationBarButtonItems()
        getSongs()
    }
    
    private func setTitle() {
        self.title = (book != nil && mode == .list) ? "\(book!.name) Songs" : "All Songs"
    }
    
    // MARK: Navigation Bar Button Items
    private func setNavigationBarButtonItems() {
        setRightBarButtonItems()
        setLeftBarButtonItems()
    }
    
    private func setLeftBarButtonItems() {
        self.navigationItem.leftItemsSupplementBackButton = true
        if mode != .add {
            let addNewSongBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSongBarButtonTapped))
            self.navigationItem.leftBarButtonItem = addNewSongBarButton
        }
    }
    
    private func setRightBarButtonItems() {
        if !songs.isEmpty {
            if self.navigationItem.rightBarButtonItems != nil {
                self.navigationItem.rightBarButtonItems!.append(self.editButtonItem)
            }
        }
    }
    
    @objc func addNewSongBarButtonTapped() {
        if let book = book {
            let stvc = SongTableViewController()
            stvc.book = book
            stvc.mode = .add
            self.navigationController?.pushViewController(stvc, animated: true)
        } else {
            let svc = SongViewController()
            svc.mode = .add
            self.navigationController?.pushViewController(svc, animated: true)
        }
    }
    
    private func getSongs() {
        let bookIdentifier = mode == .add ? nil : book?.localId
        if ApplicationUserSession.session!.islocal {
            do {
                songs = try songRepository.getAll(bookIdentifier)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            // TODO: get from firebase cloud store
        }
    }
    
    private func deleteSong(_ songViewModel: Song) {
        do {
            // let song = Song(id: songViewModel.id, userId: ApplicationUserSession.session!.localId, name: songViewModel.name, content: songViewModel, mediaUrl: <#T##String#>, status: <#T##Bool#>)
            // try songRepository.delete(element: song)
            if !ApplicationUserSession.session!.islocal {
                
                // TODO: delete song from firebase cloud store
                
            }
        } catch {
            
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
            tableView.setEmptyView(title: "You have not any song", message: isfiltering ? "" : "A new song can be added by + button on the right corner")
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
            let deletedSong = isfiltering ? filteredSong.remove(at: indexPath.row) : songs.remove(at: indexPath.row)
            if isfiltering {
                var itemIndex = 0
                for item in songs {
                    if item.id == deletedSong.id {
                        songs.remove(at: itemIndex)
                    }
                    itemIndex += 1
                }
            }
            deleteSong(deletedSong)
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

extension SongTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterModelForSearchText(searchBar.text!)
    }
}
