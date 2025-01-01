//
//  Node.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//
import Foundation

struct Node: Codable, Hashable, Sendable, Identifiable, Equatable {
    var id: UUID
    var title: String
    var position: Float
    var groupId: UUID?
    var parentNodeId: UUID?
    var expanded: Bool = true
    
    
    init(id: UUID, title: String, position: Float, groupId: UUID?, parentNodeId: UUID?, expanded: Bool = true) {
        self.id = id
        self.title = title
        self.position = position
        self.groupId = groupId
        self.parentNodeId = parentNodeId
        self.expanded = expanded
    }
    
    init(){
        self.id = .init()
        self.title = ""
        self.position = 0.0
        self.expanded = true
    }
}
