//
//  WelcomeViewController.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 27.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class WelcomeViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
    
    @IBOutlet weak var facebookLoginButton: FBLoginButton!
    
    var isFirstEntry: Bool {
        return UserDefaults.standard.object(forKey: AppConstraints.firstEntryKey) == nil
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        saveUserLocalDatabase(user: User())
        self.performSegue(withIdentifier: AppConstraints.bookViewControllerSegueIdentifier, sender: sender)
    }
    
    @IBAction func googleSignInPressed(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInDelegates()
        print(AppConstraints.databasePath)
        if isFirstEntry {
            SQLiteDataAccessLayer.shared.initializeDatabase()
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
    
    private func setSignInDelegates() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        facebookLoginButton.delegate = self
    }
    
    private func logIn(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                
                //TODO: show error user-friendly
                
                print(error.localizedDescription)
            } else {
                if let currentUser = Auth.auth().currentUser {
                    self.saveUserLocalDatabase(user: User(globalId: currentUser.uid, name: currentUser.displayName ?? currentUser.uid))
                    self.performSegue(withIdentifier: AppConstraints.bookViewControllerSegueIdentifier, sender: self)
                }
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveUserLocalDatabase(user: User) {
        var userRepository = UserRepository()
        do {
            let localUserId = try userRepository.insert(element: user)
            UserDefaults.standard.set("\(localUserId)", forKey: AppConstraints.userLocalIdKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Google Sign-In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            
            // TODO: show error user-friendly
            
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
 
        logIn(with: credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        logOut()
    }
    
    // MARK: Facebook Sign-In
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            
            // TODO: show error user-friendly
            
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = AccessToken.current else { return }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: authentication.tokenString)
        
        logIn(with: credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        logOut()
    }
}
