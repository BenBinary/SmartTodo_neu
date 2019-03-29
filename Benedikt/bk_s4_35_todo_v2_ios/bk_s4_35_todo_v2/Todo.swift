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
        
        /*
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

        
        //Enkodieren des Arrays
        let encoder = JSONEncoder()
        let fm = FileManager()
        if let jsondata = try? encoder.encode(array) {
            
            if let jsonstr = String(data: jsondata, encoding: .utf8) {
                
                // Bekommen der URL für die JSON-Datei im Bundle
                if let url = docUrl(for: "entries.json") {
                    
                    do {
                     
                        try? jsonstr.write(to: url, atomically: false, encoding: .utf8)
                        print("Daten erfolgreich gespeichert")
                        
                    } catch {
                        print(error)
                        print("Daten nicht erfolgreich gespeichert")}
                }
                
            } else {  print("Fehler beim serialisieren") }
        } else { print("Fehler beim enkodieren")}
        
        */
        
        
        // Alter Block um die Themen zu speichern mithilfe einer normalen Text-Datei
         
         if let url = docUrl(for: "todo.txt") {
         do {
         // Array in eine Zeichenkette umwandeln
         let str = data.joined(separator: "\n")
         try str.write(to: url, atomically: true, encoding: .utf8)
         } catch {
         print(error)
         }
         }
        
    }
    
    
    static func load() -> [String] {
        
        
        print("Load-Funktion")
        
        var fm = FileManager.default
        
        var decoder = JSONDecoder()
        
        /*
        if let str = NSUbiquitousKeyValueStore().string(forKey: "todoList") {
            return str.split { $0 == "\n" }.map { String($0) }
        }
        */
        
        // Alte Speicherung
        //  if let url = Bundle.main.url(forResource: "entries", withExtension: "json")
        
        
        
        /*
        if let url = docUrl(for: "entries.json") {
            
            
            // Falls am Anfang keine Datei exisitiert
            print("Existiert die Datei bereits?: \((fm.fileExists(atPath: url.absoluteString)))")
            print(try? url.checkResourceIsReachable())
            
            if (!fm.fileExists(atPath: url.absoluteString)) {
                
                print("Datei exisitiert nicht")
            
                var entry_1 = Entry("Hallo")
                var entry_2 = Entry("das")
                var entry_3 = Entry("ist der dritte Eintrag")
                
                
                var entries = Entries([entry_1, entry_2, entry_3])
                var encoder = JSONEncoder()

                if let jsondata = try? encoder.encode(entries) {
                    
                    if let jsonstr = String(data: jsondata, encoding: .utf8) {
                        
                        do {
                            try jsonstr.write(to: url, atomically: false, encoding: .utf8)
                            print("Initial Daten wurden erfogleich gepseichert")
                        } catch {
                            
                            print("Initial Datei konnte nicht gespeichert werden")
                        }
                    }
                    
                } else { print("Die Initial-Datei existiert bereits")}
            }
            
            
            // Laden der Daten
            if let data = try? Data(contentsOf: url) {
                
                if let jsonData = try? decoder.decode(Entries.self, from: data) {
                    
                    print(jsonData.entries)
                    
                    var value : [String] = []
                    
                    //Anfügen disere an ein neues String-Array
                    for i in 0..<jsonData.entries.count {
                        
                        value.append(jsonData.entries[i].Text)
                        
                    }
                    
                    print("Diese Daten wurden eingelesen \(value)")
                    return value
                    
                    
                } else { print("Fehler beim Dekodieren ")}
                
            } else { print("Fehler beim Einlesen der Datem") }
            
        } else { print("Fehler beim Finden der Datei") }
        */
        
        
       //  Erster Versuch über eine Text-Datei
         
         if let url = docUrl(for: "todo.txt") {
         do {
         let str = try String(contentsOf: url, encoding: .utf8)
         return str.split { $0 == "\n" }.map { String($0) }
         } catch {
         print(error)
         }
         }
        
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
