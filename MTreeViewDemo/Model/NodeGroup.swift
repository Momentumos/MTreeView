//
//  NodeGroup.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//

import Foundation

struct NodeGroup: Codable, Hashable, Sendable, Identifiable, Equatable {
    var id: UUID
    var title: String
    var position: Float
    var expanded: Bool = true
    
    init(id: UUID, title: String, position: Float, expanded: Bool = true) {
        self.id = id
        self.title = title
        self.position = position
        self.expanded = expanded
    }
    
    init(){
        self.id = .init()
        self.title = ""
        self.position = 0.0
        self.expanded = true
    }
}

