//
//  BookDetailTableViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class SongTableViewController: UITableViewController {
    private let SEARCHBAR_PLACEHOLDER = "Search a song"
    
    private var TABLEVIEW_EMPTY_VIEW: (title: String, message: String) {
        return ("You have not any song", "A new song can be added by + button on the right corner")
    }
        
    var tableMode: SongTableProtocol! = SongTableDefault()
    
    private var groupIdentifier: Int64? {
        return self.tableMode.songGroup?.localId
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    private lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSongBarButtonTapped))
    
    private var songRepository = SongRepository()
    
    private var songs = [Song]() {
        didSet {
            navigationItem.searchController = !songs.isEmpty ? searchController : nil
            navigationItem.rightBarButtonItem = !songs.isEmpty && tableMode is DeletableTable ? self.editButtonItem : nil
            if !songs.isEmpty {
                setTableSectionTitles()
            }
        }
    }
    
    private var filteredSong = [Song]()
    
    private var songSections = [String: [Song]]()
    
    private var songSectionTitles = [String]()
    
    private var isSearchBarEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    
    private var isfiltering: Bool { return searchController.isActive && !isSearchBarEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        initializeSearchController()
        setLeftBarButtonItems()
        getSongs()
    }
    
    private func setTitle() {
        self.title = tableMode.songGroup != nil ? "\(tableMode.songGroup?.name ?? "") Songs" : "All Songs"
    }
    
    private func initializeSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SEARCHBAR_PLACEHOLDER
        definesPresentationContext = true
    }
    
    private func setLeftBarButtonItems() {
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.backBarButtonItem = backBarButton
        self.navigationItem.leftBarButtonItem = (tableMode is AddedableTable) ? addBarButton : nil
    }
    
    @objc func addNewSongBarButtonTapped() {
        let storyboard = UIStoryboard(name: AppConstraints.storyboardName, bundle: nil)
        if let songGroup = tableMode.songGroup {
            
            if songGroup.type == .book {
                let alert = UIAlertController(title: "New Songs", message: "What do you want to add?", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Category", style: .default, handler: { (UIAlertAction) in
                  
                }))
                
                alert.addAction(UIAlertAction(title: "Song", style: .default, handler: { (UIAlertAction) in
                    if let stvc = storyboard.instantiateViewController(identifier: AppConstraints.songTableViewControllerStoryboardId) as? SongTableViewController {
                        stvc.tableMode = SongTableOfNewSongForGroup(songGroup: songGroup)
                        self.navigationController?.pushViewController(stvc, animated: true)
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            } else if songGroup.type == .category {
                if let stvc = storyboard.instantiateViewController(identifier: AppConstraints.songTableViewControllerStoryboardId) as? SongTableViewController {
                    stvc.tableMode = SongsTableOfGroup(songGroup: songGroup)
                    self.navigationController?.pushViewController(stvc, animated: true)
                }
            }
        } else {
            if let svc = storyboard.instantiateViewController(identifier: AppConstraints.songDetailTableViewControllerStoryboardId) as? SongDetailTableViewController {
                //svc.mode = .add
                self.navigationController?.pushViewController(svc, animated: true)
            }
        }
    }
    
    private func setTableSectionTitles() {
        songs.forEach { song in
            let firstLetterOfSongName = song.name.prefix(1).uppercased()
            if var songs = songSections[firstLetterOfSongName] {
                songs.append(song)
                songSections[firstLetterOfSongName] = songs
                
            } else {
                songSections[firstLetterOfSongName] = [song]
            }
        }
        songSectionTitles = songSections.keys.sorted(by: <)
    }
    
    private func getSongs() {
        if ApplicationUserSession.session!.islocal {
            do {
                songs = try songRepository.getAll(by: groupIdentifier)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            // TODO: get from firebase cloud store
        }
    }
    
    private func deleteSong(_ song: Song) {
        do {
            try songRepository.delete(element: SongEntity.create(from: song))
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
        return songSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return songSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return songSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalSongCount = 0
        
        if isfiltering {
            totalSongCount = filteredSong.count
        } else {
            totalSongCount = songSections[songSectionTitles[section]]?.count ?? 0
        }

        if totalSongCount == .zero {
            tableView.setEmptyView(title: TABLEVIEW_EMPTY_VIEW.title,
                                   message: isfiltering ? "" : TABLEVIEW_EMPTY_VIEW.message)
        } else {
            tableView.restore()
        }
        
        return totalSongCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstraints.songCellIdentifier, for: indexPath) as! SongTableViewCell

        if isfiltering {
            cell.song = filteredSong[indexPath.row]
        } else {
            cell.song = songSections[songSectionTitles[indexPath.section]]![indexPath.row]
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableMode is DeletableTable
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

        print("FROM \(fromIndexPath)")
        print("TO \(to)")
        
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return tableMode is MovableTable
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case AppConstraints.addSongViewControllerIdentifier:
            if let svc = segue.destination as? OLDSongViewController {
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
