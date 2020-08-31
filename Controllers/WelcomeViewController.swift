//
//  WelcomeViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 27.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    var isFirstEntry: Bool {
        return UserDefaults.standard.object(forKey: AppConstraints.firstEntryKey) == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isFirstEntry {
            
            // TODO: create local databases (SQLite)
            let repositories: [Initializable] = [UserRepository(), BookRepository(), SongRepository(), BookSongRepository()]
            
            for repository in repositories {
                try? repository.createTable()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
