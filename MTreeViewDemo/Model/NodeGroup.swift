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
}

