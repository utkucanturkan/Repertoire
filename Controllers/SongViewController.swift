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

class SongViewController: UIViewController, UITextViewDelegate {

    var mode: songViewControllerMode = .view {
        didSet {
            // TODO: run instructions with respect to songMode
            initializeUIs()
        }
    }
    
    var song: Song?
    
    private var scrollView = UIScrollView()
    private var songNameTextView = UITextView()
    private var songContentTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SongViewController"
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func rotated() {
        scrollView.updateContentSizeHeight()
    }

    
    private func initializeUIs() {
        scrollView.clearSubViews()
        scrollView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize SongNameTextView
        songNameTextView.frame = CGRect(x: 0, y: 0, width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 0)
        songNameTextView.delegate = self
        songNameTextView.text = self.mode == .add ? AppConstraints.songNameTextViewPlaceholder : song?.name
        songNameTextView.textColor = .gray
        songNameTextView.isEditable = mode != .view
        songNameTextView.backgroundColor = .orange
        songNameTextView.font = UIFont.systemFont(ofSize: 50)
        songNameTextView.isScrollEnabled = false
        songNameTextView.sizeToFit()
        songNameTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize SongContentTextView
        songContentTextView.frame = CGRect(x: 0, y: 0, width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 0)
        songContentTextView.delegate = self
        songContentTextView.text = self.mode == .add ? AppConstraints.songContentTextViewPlaceholder : song?.content
        songContentTextView.textColor = .lightGray
        songContentTextView.isEditable = mode != .view
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
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
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
