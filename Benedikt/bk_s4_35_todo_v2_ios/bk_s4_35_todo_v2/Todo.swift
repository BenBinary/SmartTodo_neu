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
        
        // Zweiter Verusch mit JSON-Speicherung im lokalen Verzeichnis
        let encoder = JSONEncoder()
        
        // ### Speicherung der Daten auf meinem Server ###
        
        let entries = Entries(data)
        let web = "http://87.190.44.81:3000/entries"
        
        
        let strData = "{\"Entries\": { \"entries\": [] }}"
        
        
        if let url = URL(string: web) {
            
            if let jsonData = try? encoder.encode(entries) {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                do {
                    let task = try URLSession.shared.dataTask(with: request)
                    
                    task.resume()
                } catch {
                    
                    print("Fehler beim Ausführen des Tasks")
                }
                
                
            } else { print("Daten konnten nicht enkodiert werden ")}
            
        }
        
        //if let url = docUrl(for: "todo.json")
        
        //if let url = URL(string: web)
        /*
         ### Alte lokale Speicherung der Daten ###
         
        if let url = docUrl(for: "todo.json") {
            
            if let jsonData = try? encoder.encode(entries) {
                
                
                //jsonData.write(to: url, options: Data.WritingOptions)
                
                try? jsonData.write(to: url)
                
            } else { print("Fehler beim Encodieren der Daten")}
        }
        
        */
    }
    
    
    static func load() -> [String] {
        
        
        print("Load-Funktion")
        
        // var fm = FileManager.default
        
        let decoder = JSONDecoder()
        
        // Zweiter Versuch --> Peristente Speicherung mittels JSON
        
        let web = "http://87.190.44.81:3000/entries"
        
        if let url = URL(string: web) {
            
            if let jsonData = try? Data(contentsOf: url) {
                
                if let jsonString = try? decoder.decode(Entries.self, from: jsonData) {
                    
                    print("JSON Data \(jsonData)")
                    print("JSON String \(jsonString)")
                    return jsonString.entries
                    
                } else { print("Fehler beim Dekodieren") }
                
            } else { print("Fehler beim Einlesen der Datei") }
            
            
        } else { print("Fehler bei der URL") }
        
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
