//
//  Node.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//
import Foundation

public protocol Node: Codable, Hashable, Sendable, Identifiable, Equatable {
    var id: UUID { get set }
    var position: Float { get set }
    var groupId: UUID? { get set }
    var parentNodeId: UUID? { get set }
    var expanded: Bool { get set }
}

