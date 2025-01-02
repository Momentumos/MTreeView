//
//  NodeGroup.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//

import Foundation

public struct NodeGroup: Codable, Hashable, Sendable, Identifiable, Equatable {
    public var id: UUID
    public var title: String
    public var position: Float
    public var expanded: Bool = true
    
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

