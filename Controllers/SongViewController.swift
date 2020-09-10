//
//  SongViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 10.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

enum songViewControllerMode {
    case view
    case edit
    case add
}

class SongViewController: UIViewController, UIGestureRecognizerDelegate {

    var mode: songViewControllerMode = .view {
        didSet {
            // TODO: run instructions with respect to songMode
            print(mode)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
