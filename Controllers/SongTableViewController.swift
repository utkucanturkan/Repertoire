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
        return ("You have not any song", "A new song can be added by + button on the left corner")
    }
        
    var table: TableProtocol! = AllSongsListingTable()
    
    private var groupIdentifier: Int64? { return self.table.songGroup?.localId }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    private lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSongBarButtonTapped))
    
    private var songRepository = SongRepository()
    
    private var songs = [Song]() {
        didSet {
            navigationItem.rightBarButtonItem = !songs.isEmpty && table is Deletable ? self.editButtonItem : nil
            setTableSectionTitles()
        }
    }
    
    private var filteredSong = [Song]()
    
    private var songSections = [String: [Song]]()
    
    private var songSectionTitles = [String]()
    
    private var totalSectionCount: Int {
        if songSectionTitles.isEmpty {
            tableView?.setEmptyView(title: TABLEVIEW_EMPTY_VIEW.title, message: isfiltering ? "" : TABLEVIEW_EMPTY_VIEW.message)
        } else {
            tableView?.restore()
        }
        return songSectionTitles.count
    }
    
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
        self.title = table.songGroup != nil ? "\(table.songGroup?.name ?? "") Songs" : "All Songs"
    }
    
    private func initializeSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SEARCHBAR_PLACEHOLDER
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setLeftBarButtonItems() {
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.backBarButtonItem = backBarButton
        self.navigationItem.leftBarButtonItem = (table is Addedable) ? addBarButton : nil
    }
    
    @objc func addNewSongBarButtonTapped() {
        let storyboard = UIStoryboard(name: AppConstraints.storyboardName, bundle: nil)
        if let songGroup = table.songGroup {
            
            if songGroup.type == .book {
                let alert = UIAlertController(title: "New Songs", message: "What do you want to add?", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Category", style: .default, handler: { (UIAlertAction) in
                  
                }))
                
                alert.addAction(UIAlertAction(title: "Song", style: .default, handler: { (UIAlertAction) in
                    if let stvc = storyboard.instantiateViewController(identifier: AppConstraints.songTableViewControllerStoryboardId) as? SongTableViewController {
                        stvc.table = NewSongAdditionTable(songGroup: songGroup)
                        self.navigationController?.pushViewController(stvc, animated: true)
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            } else if songGroup.type == .category {
                if let stvc = storyboard.instantiateViewController(identifier: AppConstraints.songTableViewControllerStoryboardId) as? SongTableViewController {
                    stvc.table = NewSongAdditionTable(songGroup: songGroup)
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
        songSections.removeAll()
        songSectionTitles.removeAll()
        if table is Indexable {
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
    }

    private func filterModelForSearchText(_ searchText: String) {
        filteredSong = songs.filter { song in
            return song.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isfiltering || !(table is Indexable) ? 1 : totalSectionCount
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isfiltering || !(table is Indexable) ? nil : songSectionTitles.isEmpty ? nil : songSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isfiltering || !(table is Indexable) ? nil : songSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalSongCount = isfiltering ? filteredSong.count : table is Indexable ? songSectionTitles.isEmpty ? 0 : songSections[songSectionTitles[section]]?.count ?? 0 : songs.count

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
        } else if table is Indexable {
            if let songsInSection = songSections[songSectionTitles[indexPath.section]] {
                cell.song = songsInSection[indexPath.row]
            }
        } else {
            cell.song = songs[indexPath.row]
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return table is Deletable
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // get deleted element
            let deletedSong = isfiltering ? filteredSong.remove(at: indexPath.row) : table is Indexable ? songSections[songSectionTitles[indexPath.section]]![indexPath.row] : songs[indexPath.row]
            
            // delete from model
            var itemIndex = 0
            for item in songs {
                if item.id == deletedSong.id {
                    songs.remove(at: itemIndex)
                }
                itemIndex += 1
            }
            
            // delete from view
            if !isfiltering && table is Indexable && tableView.numberOfRows(inSection: indexPath.section) == 1 {
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                tableView.deleteSections(indexSet, with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // Delete from remote data source
            deleteSong(deletedSong)
        }
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        print("FROM \(fromIndexPath)")
        print("TO \(to)")
        
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return table is Movable
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

// MARK: Model CRUD Operations Extension
extension SongTableViewController {
    private func getSongs() {
        if ApplicationUserSession.session!.islocal {
            do {
                songs = try songRepository.getAll(by: groupIdentifier)
                tableView.reloadData()
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
}

extension SongTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterModelForSearchText(searchBar.text!)
    }
}
