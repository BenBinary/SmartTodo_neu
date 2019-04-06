//
//  Entries.swift
//  bk_s4_35_todo_v2
//
//  Created by Benedikt Kurz on 28.03.19.
//  Copyright © 2019 Benedikt Kurz. All rights reserved.
//

import Foundation

struct Entries: Codable {
    
    
    var entries:[String]
    
    
    init(_ data: [String]) {
      
        
        self.entries = data
        
    }
    
}

struct Entry: Codable {
    
    var Text:String
    
    
    init(_ data: String) {
        self.Text = data
    }
}
