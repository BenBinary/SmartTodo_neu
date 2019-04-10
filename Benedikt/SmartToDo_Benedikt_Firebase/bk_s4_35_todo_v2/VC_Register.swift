//
//  VC_Register.swift
//  bk_s4_35_todo_v2
//
//  Created by Benedikt Kurz on 09.04.19.
//  Copyright © 2019 Benedikt Kurz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class VC_Register: UIViewController {
    
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE]
            //self.setTitleDisplay(user)
            //self.tableView.reloadData()
            // [END_EXCLUDE]
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)        
        Auth.auth().removeStateDidChangeListener(handle!)

    }
    
    @IBAction func btnRegister(_ sender: UIButton) {

        if let email = txtEmail.text, let password = txtPassword.text {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if user != nil {
                   
                    print("Nutzer angelegt")
                    
                } else {
                    print(error)
                }
                
                
            })
        }
        
        
        
//        let actionCodeSettings = ActionCodeSettings()
//        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//        actionCodeSettings.url = URL(string: "kuku.de")
//
//
//        if let email = txtEmail.text {
//
//            Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
//
//        }
//
        
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
