//
//  NewPopupVC.swift
//  bk_s4_35_todo_v2
//
//  Created by Benedikt Kurz on 15.12.18.
//  Copyright © 2018 Benedikt Kurz. All rights reserved.
//

import UIKit

class NewPopupVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txt: UITextField!
    
    // zulässige Methoden "new" und "edit"
    var mode = ""
    
    // zu ändernder Text und Eintrag (nur für Edit-Mode)
    var currentText = ""
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if mode=="new" {
            // Neuer Eintrag == TT sofort einblenden
            txt.becomeFirstResponder()
        } else {
            txt.text = currentText
        }
        
        // Textfeld-Ereignisse verarbeiten
        txt.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        performSegue(withIdentifier: "SegueUnwindToMain", sender: self)
        
        return false
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
