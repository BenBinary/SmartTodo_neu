//
//  Todo.swift
//  bk_s4_35_todo_v2
//
//  Created by Benedikt Kurz on 14.12.18.
//  Copyright © 2018 Benedikt Kurz. All rights reserved.


// Datenmodell

import Foundation

struct Todo {
    static func save(_ data: [String]) {
        
        // String-Array wird zu einem String zusammengeführt
        let str = data.joined(separator: "\n")
        
        // iCloud basierter Container beim dem Daten in einer KV-Map gespeichert werden
        //NSUbiquitousKeyValueStore().set(str, forKey: "todoList")
        
        
        
        
        
        print("Zu speichernde Daten \(data)")
        
        
        // Füllen eines Entties-Objekt das danach dekodiert wird und in die lokale JSON-Datei abgespeichert wird
        
        var array : [Entry] = []
        var s = Entry("")
        
        for i in 0..<data.count {
            
            s = Entry(data[i])
            
            array.append(s)
            
            
        }
        
        
        
        print(array)
        
        //Enkodieren des Arrays
        let encoder = JSONEncoder()
        let fm = FileManager()
        if let jsondata = try? encoder.encode(array) {
            
            if let jsonstr = String(data: jsondata, encoding: .utf8) {
                
                // Bekommen der URL für die JSON-Datei im Bundle
                if let url = Bundle.main.url(forResource: "entries", withExtension: "json") {
                    
                    do {
                       try fm.removeItem(at: url)
                        
                   try jsonstr.write(to: url, atomically: false, encoding: .utf8)
                    } catch {
                        print(error)
                        print("Daten nicht erfolgreich gespeichert")}
                }
                
            } else {  print("Fehler beim serialisieren") }
        } else { print("Fehler beim enkodieren")}
        
        
        
        /*
         Alter Block um die Themen zu speichern mithilfe einer normalen Text-Datei
         
         if let url = docUrl(for: "todo.txt") {
         do {
         // Array in eine Zeichenkette umwandeln
         let str = data.joined(separator: "\n")
         try str.write(to: url, atomically: true, encoding: .utf8)
         } catch {
         print(error)
         }
         }
         */
    }
    
    
    static func load() -> [String] {
        
        var decoder = JSONDecoder()
        
        if let str = NSUbiquitousKeyValueStore().string(forKey: "todoList") {
            return str.split { $0 == "\n" }.map { String($0) }
        }
        
        
        if let url = Bundle.main.url(forResource: "entries", withExtension: "json") {
            
            if let data = try? Data(contentsOf: url) {
                
                if let jsonData = try? decoder.decode(Entries.self, from: data) {
                    
                    print(jsonData.entries)
                    
                    var value : [String] = []
                    
                    //Anfügen disere an ein neues String-Array
                    for i in 0..<jsonData.entries.count {
                        
                        value.append(jsonData.entries[i].Text)
                        
                    }
                    
                    return value
                    
                    
                } else { print("Fehler beim Dekodieren ")}
                
            } else { print("Fehler beim Einlesen der Datem") }
            
        } else { print("Fehler beim Finden der Datei") }
        
        
        /*
         Erster Versuch über eine Text-Datei
         
         if let url = docUrl(for: "todo.txt") {
         do {
         let str = try String(contentsOf: url, encoding: .utf8)
         return str.split { $0 == "\n" }.map { String($0) }
         } catch {
         print(error)
         }
         }
         */
        return []
    }
    
    private static func docUrl(for filename: String) -> URL? {
        // sollte immer genau ein Ergebnis liefern
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let docDir = urls.first {
            return docDir.appendingPathComponent(filename)
        }
        
        return nil
    }
    
    // Fügt Daten aus einem lokalen Array und der iCloud zusammen
    // Von beiden Quellen werden die Daten mit Union als Set zusammengefügt
    static func merge(with local: [String]) -> [String] {
        
        // Auslesen der Datensätze aus der iCloud
        var icloud = [String]()
        if let str = NSUbiquitousKeyValueStore().string(forKey: "todolist") {
            icloud = str.split { $0 == "\n" }.map { String($0) }
        }
        
        // Zusammenfügen der Datensätze
        let all = Set(icloud).union(local)
        
        // Sortieren der Datensätze
        return Array(all).sorted()
        
    }
}
