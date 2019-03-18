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
        NSUbiquitousKeyValueStore().set(str, forKey: "todoList")
        
        
        /*
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
   
        if let str = NSUbiquitousKeyValueStore().string(forKey: "todoList") {
            return str.split { $0 == "\n" }.map { String($0) }
        }
        
        /*
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
