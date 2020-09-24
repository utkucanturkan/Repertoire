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

class SongViewController: UIViewController {

    var mode: songViewControllerMode = .view {
        didSet {
            // TODO: run instructions with respect to songMode
            updateUI()
        }
    }
    
    var song: Song?
    
    let LOREM_IPSUM = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32."
    
    private var scrollView = UIScrollView()
    private var songNameTextView = UITextView()
    private var songContentTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateUI() {
        scrollView.clearSubViews()
        
        // Initialize ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize SongNameTextView
        songNameTextView.frame = CGRect(x: 0, y: 0, width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 0)
        songNameTextView.text = self.mode == .add ? LOREM_IPSUM : song?.name
        songNameTextView.backgroundColor = .orange
        songNameTextView.font = UIFont.systemFont(ofSize: 50)
        songNameTextView.isScrollEnabled = false
        songNameTextView.sizeToFit()
        songNameTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize SongContentTextView
        songContentTextView.frame = CGRect(x: 0, y: 0, width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 0)
        songContentTextView.text = self.mode == .add ? LOREM_IPSUM : song?.content
        songContentTextView.backgroundColor = .brown
        songContentTextView.font = UIFont.systemFont(ofSize: 50)
        songContentTextView.isScrollEnabled = false
        songContentTextView.sizeToFit()
        songContentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(songNameTextView)
        scrollView.addSubview(songContentTextView)
        
        initializeLayoutConstraints()
        scrollView.updateContentSizeHeight()
    }
    
    private func initializeLayoutConstraints() {
        // ScrollView Constraints
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        songNameTextView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        songNameTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        songNameTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        songContentTextView.topAnchor.constraint(equalTo: songNameTextView.bottomAnchor, constant: 8).isActive = true
        songContentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        songContentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        print(songNameTextView.bounds)
        print(songContentTextView.bounds)
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

extension UIView {
    func clearSubViews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}

extension UIScrollView {
    func updateContentSizeHeight() {
        self.contentSize = .zero
        for subview in self.subviews {
            self.contentSize.height += subview.bounds.height
        }
    }
}
