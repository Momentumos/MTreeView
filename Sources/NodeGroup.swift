//
//  NodeGroup.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//

import Foundation
import CoreTransferable

public protocol NodeGroup: Codable, Hashable, Sendable, Identifiable, Equatable {
    var id: UUID { get set }
    var title: String { get set }
    var position: Float { get set }
    var expanded: Bool { get set }
}

