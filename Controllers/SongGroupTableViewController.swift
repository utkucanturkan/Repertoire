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

class SongGroupTableViewController: UITableViewController {
    private let INITIAL_SELECTED_SEGMENT_INDEX: Int = .zero
    private let SONG_GROUP_TYPES: [SongGroupModelType] = [BookSongGroup(), CategorySongGroup()]
    
    private var songGroups = [SongGroup]() {
        didSet {
            navigationItem.rightBarButtonItem = !songGroups.isEmpty ? self.editButtonItem : nil
        }
    }
    
    private var filteredSongGroups = [SongGroup]()
    
    private var songGroupRepository = SongGroupRepository()
    
    private var currentSongGroup: SongGroupModelType {
        return SONG_GROUP_TYPES[segmentedController.selectedSegmentIndex]
    }
    
    private var segmentedController = UISegmentedControl()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        initializeSegmentedController()
        initializeSearchController()
        getSongGroupsOfCurrentUser()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func initializeSegmentedController() {
        segmentedController = UISegmentedControl(items: SONG_GROUP_TYPES.map{$0.name})
        segmentedController.selectedSegmentIndex = INITIAL_SELECTED_SEGMENT_INDEX
        segmentedController.sizeToFit()
        segmentedController.addTarget(self, action: #selector(segmentedControllerChanged), for: .valueChanged)
        navigationItem.titleView = segmentedController
    }
    
    private func initializeSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = currentSongGroup.searchBarPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func segmentedControllerChanged() {
        searchController.searchBar.placeholder = currentSongGroup.searchBarPlaceholder
        getSongGroupsOfCurrentUser()
    }
    
    @IBAction func addSongGroupButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: currentSongGroup.alertTitle, message: currentSongGroup.alertMessage, preferredStyle: .alert)
        
        alert.addTextField { [unowned self] textField in
            textField.placeholder = self.currentSongGroup.alertTextfieldPlaceholder
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let newSongGroupName = alert.textFields?.first?.text else { return }
            if newSongGroupName.isValid {
                if let newSongGroupDatabaseIds = self.addNewSongGroup(with: newSongGroupName) {
                    let newSongGroup = SongGroup(localId: newSongGroupDatabaseIds.localId, globalId: newSongGroupDatabaseIds.globalId, name: newSongGroupName, type: currentSongGroup.type)
                    self.songGroups.append(newSongGroup)
                    self.tableView.reloadData()
                    
                    if let stvc = storyboard?.instantiateViewController(identifier: AppConstraints.songTableViewControllerStoryboardId) as? SongTableViewController {
                        stvc.table = SongsOfGroupListingTable(songGroup: newSongGroup)
                        self.navigationController?.pushViewController(stvc, animated: true)
                    }
                }
            }
        })
        
        self.present(alert, animated: true)
    }
    
    private func addNewSongGroup(with name: String) -> (localId: Int64, globalId: String?)? {
        var newSongGroup: (localId: Int64, globalId: String?) = (.zero, nil)
        do {
            let newlyAddedSongGroup = SongGroupEntity(
                userId: ApplicationUserSession.session!.localId,
                name: name,
                type: currentSongGroup.type)
            
            newSongGroup.localId = try songGroupRepository.insert(element: newlyAddedSongGroup)
            if !ApplicationUserSession.session!.islocal {
                
                // TODO: add a new book into the firebase cloud store, and set the globalId property of the newly added book
                
            }
            return newSongGroup
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func filterModelForSearchText(_ searchText: String) {
        filteredSongGroups = songGroups.filter { songGroup in
            return songGroup.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    private func deleteSongGroup(_ songGroup: SongGroup) {
        do {
            try songGroupRepository.delete(element: SongGroupEntity.create(from: songGroup))
            if !ApplicationUserSession.session!.islocal {
                
                // TODO: delete book from firebase cloud store
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getSongGroupsOfCurrentUser() {
        if ApplicationUserSession.session!.islocal {
            do {
                songGroups = try songGroupRepository.getAllBy(userIdentifier: ApplicationUserSession.session!.localId, with: currentSongGroup.type)
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            
            // TODO: get groups from firebase cloud store
            
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalSongGroupCount = isfiltering ? filteredSongGroups.count : songGroups.count
        if totalSongGroupCount == .zero {
            tableView.setEmptyView(
                title: currentSongGroup.emptyTableview.title,
                message: isfiltering ? "" : currentSongGroup.emptyTableview.message)
        } else {
            tableView.restore()
        }
        return totalSongGroupCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstraints.bookCellIdentifier, for: indexPath) as! SongGroupTableViewCell
        cell.songGroup = isfiltering ? filteredSongGroups[indexPath.row] : songGroups[indexPath.row]
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !songGroups.isEmpty
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedSongGroup = isfiltering ? filteredSongGroups.remove(at: indexPath.row) : songGroups[indexPath.row]
            var itemIndex = 0
            for item in songGroups {
                if item.localId == deletedSongGroup.localId {
                    songGroups.remove(at: itemIndex)
                }
                itemIndex += 1
            }
            deleteSongGroup(deletedSongGroup)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstraints.bookDetailViewControllerSegueIdentifier {
            if let stvc = segue.destination as? SongTableViewController, let sgtvc = sender as? SongGroupTableViewCell {
                stvc.table = SongsOfGroupListingTable(songGroup: sgtvc.songGroup)
            }
        }
    }
}

extension SongGroupTableViewController: UISearchResultsUpdating {
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
