//
//  ViewController.swift
//  bk_s4_35_todo_v2
//
//  Created by Benedikt Kurz on 14.12.18.
//  Copyright © 2018 Benedikt Kurz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newButton: UIButton!
    
    
    var todoList = Todo.load() {
        
        //print("Property Observer wurde ausgeführt")
        
        didSet {
          Todo.save(todoList)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // delegate: Um referenzen auf goloabl für die app verfügbare Daten einzurichgen
        // In einer selbst programmierten Klasse (meist VC) die Methode eines fremden Objekts verarbeitet werden muss. Diese Methode ist in einem Delegation-Protokoll definiert. Die eigene Klasse muss diese Protkoll implementieren um, damit der Methodenaufruf möglich ist
       // tableView.delegate = self
        
        
        
        todoList = Todo.load()
        print("App wurde ")
        
        

        tableView.dataSource = self
        
        
        //handleLongPress: Ruft das Popup auf
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration=1.2
        
        // Gesture Recoginzer: Kann verschiedene Fingerbewegungnen erkennen
        tableView.addGestureRecognizer(lpgr)
        
        
    }
    
    
    @IBAction func editButton(_ sender: UIButton) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            newButton.isEnabled = true
            editButton.setTitle("Bearbeiten", for: UIControl.State())
            print(UIControl.State())
            
            
        } else {
            // Edit starten
            tableView.setEditing(true, animated: true)
            newButton.isEnabled = false
            editButton.setTitle("OK", for: UIControl.State())
            print(UIControl.State())
        }
    }
    
    
    @IBAction func addItem(_ sender: UIButton) {
        // Popup soll direkt darunter angezeigt werden
        showPopup(sender: sender, mode: "new")
        
        
    }
    
    
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        // nur das Ereignis .began ist hier von interesse
        if gesture.state != .began { return }
        
        // wohin hat der Benutzer gedrückt?
        let pt = gesture.location(in: tableView)
        
        if let path = tableView.indexPathForRow(at: pt), let row = (path as NSIndexPath?)?.row,
            let cell = tableView.cellForRow(at: path) {
            showPopup(sender: cell, mode: "edit", text: todoList[row], row: row)
        }
        
    }
    
    
    // Anzeigen des Popup-Feldes
    func showPopup(sender: UIView, mode:String, text:String="", row:Int=0) {
        if !(mode=="edit" || mode=="new") { return }
        
        // Eingabe-Popup vorbereiten
        let popVC = storyboard?.instantiateViewController(withIdentifier: "NewPopup") as! NewPopupVC
        
        // Eingabe des Popups vorbereiten
        popVC.mode = mode
        popVC.currentText = text
        popVC.currentRow = row
        popVC.modalPresentationStyle = .popover
        
        // Presentation Controller konfigurieren
        let popPC = popVC.popoverPresentationController!
        popPC.sourceView = sender
        popPC.sourceRect = sender.bounds
        popPC.delegate = self
        popPC.permittedArrowDirections = [.up, .down]
        
        print("blub")
        
        present(popVC, animated: true, completion: nil)
        
    }
    
    
    //Hinzufügen oder ändern eines Listeneintrags
    @IBAction func unwindToMainVC(_ segue: UIStoryboardSegue) {
        if let src = segue.source as? NewPopupVC, let txt = src.txt.text {
            let trimtext = txt.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimtext != "" {
                if src.mode == "new" {
                    todoList.append(trimtext)
                    //Stelle an dem der neue Eintrag gesetzt wird
                    let path = IndexPath(row: todoList.count-1, section: 0)
                    //Eintrag wird eingeblendet
                    tableView.insertRows(at: [path], with: .automatic)
                    //Da Eintrag am Ende ist, stellt dies sicher, das er auch wirklich eingeblendet wird
                    tableView.scrollToRow(at: path, at: .top, animated: true)
                    
                }
            }
            // modifizieren der entsprechenden Listenzeile anstatt das ganze ToDo-Array
            else if src.mode == "edit" {
                // vorhandenen Eintrag ändern
                todoList[src.currentRow] = trimtext
                let path = IndexPath(row: src.currentRow, section: 0)
                // ... und neu zeichnen
                tableView.reloadRows(at: [path], with: .automatic)
                
            }
        }
    }
    
    
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension ViewController: UITableViewDataSource {
    // numbers Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    
    // alle Einträge sind veränderlich (für Delegate on Swipe)
    // gibt an, welcher Listeneintrag veränderlich ist, Eintrag kann mit einer Streichbewegung nach links gelöscht werden
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Cell For Row At --> Darstellung der Tabellenzeichen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProtoCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row]
        return cell
    }
    
    
    // NUmber of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Einträge löschen und editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Löschen im Array
            todoList.remove(at: indexPath.row)
            // Löschen in der table View --> kann auch mehrere Einträge gleichzeitig löschen und erwartet deswegen einen Array
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Verschieben für alle Elemente erlauben - canMoveRowAt
    // Bei true: Rechts ein dreifacher Balken angezeigt wird, mit denen sich die Einträge verschieben lassen
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Verschieben durchführen
    // Aufruf, wenn tatsächlich ein Element verschoben wurde. Dazu wird das todoList-Array entsprechend synchronisiert
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // Speichern des Items zuerst in einer Variablen
        let item = todoList[sourceIndexPath.row]
        
        // Löschen des Elements an einer Stelle
        todoList.remove(at: sourceIndexPath.row)
        
        // Einfügend des Elements an einer anderen Stelle
        todoList.insert(item, at: destinationIndexPath.row)
        
        
    }
}
