//
//  VC_Authentification.swift
//  bk_s4_35_todo_v2
//
//  Created by Benedikt Kurz on 09.04.19.
//  Copyright © 2019 Benedikt Kurz. All rights reserved.
//

import UIKit
import Firebase

class VC_Authentification: UIViewController {

    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignOn: UIButton!
    
    @IBAction func btnSignOn(_ sender: UIButton) {
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseApp.configure()
        
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
