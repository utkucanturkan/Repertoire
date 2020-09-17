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
        
    @IBAction func skipSignIn(_ sender: UIButton) {
        saveUserLocalDatabase(user: UserEntity())
        self.performSegue(withIdentifier: AppConstraints.bookViewControllerSegueIdentifier, sender: sender)
    }
    
    @IBAction func googleSignInPressed(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInDelegates()
        initializeLocalDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func initializeLocalDatabase() {
        if ApplicationUserSession.session == nil {
            SQLiteDataAccessLayer.shared.initializeDatabase()
        }
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
                    self.saveUserLocalDatabase(user: UserEntity(globalId: currentUser.uid, name: currentUser.displayName ?? currentUser.uid))
                    self.performSegue(withIdentifier: AppConstraints.bookViewControllerSegueIdentifier, sender: self)
                }
            }
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func initializeUserSession(with localId: Int64, of user: UserEntity) {
        do {
            let userSession = ApplicationUserSession(localId: localId, globalId: user.globalId, userName: user.name)
            try UserDefaults.standard.setEncodable(object: userSession, with: AppConstraints.userSessionKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveUserLocalDatabase(user: UserEntity) {
        var userRepository = UserRepository()
        do {
            let userLocalId = try userRepository.insert(element: user)
            initializeUserSession(with: userLocalId, of: user)
            logOut()             // to remove the information of the firebase auth from the keychain
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Google Sign-In
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            
            // TODO: show error user-friendly, SignInError
            
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        logIn(with: credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        logOut()
    }
    
    // MARK: Facebook Sign-In
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            
            // TODO: show error user-friendly, SignInError
                        
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
