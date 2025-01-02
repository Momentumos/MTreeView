//
//  Node.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//
import Foundation

public struct Node: Codable, Hashable, Sendable, Identifiable, Equatable {
    public var id: UUID
    public var title: String
    public var position: Float
    public var groupId: UUID?
    public var parentNodeId: UUID?
    public var expanded: Bool = true
    
    
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
