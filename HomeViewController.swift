//
//  HomeViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 27.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstEntry(false)
    }
    
    private func setFirstEntry(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: AppConstraints.firstEntryKey)
        print("[INFO] - \(AppConstraints.firstEntryKey) is set \(state.description)")
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
