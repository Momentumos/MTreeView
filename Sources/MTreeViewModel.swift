//
//  TreeData.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//

import Foundation

@MainActor
public final class MTreeViewModel: ObservableObject, Sendable  {
    
    @Published private var nodeGroups: [any NodeGroup] = []
    @Published private var nodes: [any Node] = []
    
    @Published var nodeGroupFrames: [UUID: CGRect] = [:]
    @Published var nodeFrames: [UUID: CGRect] = [:]
    
    @Published var scrollOffset: CGFloat = .zero
    @Published var scrollStartOffset: CGFloat = .zero
    @Published var draggedTranslation: CGSize = .zero
    @Published var draggedLocation: CGPoint = .zero
    @Published var draggingItemId: UUID? = nil
    
    var groupHeight: CGFloat
    var nodeHeight: CGFloat
    var childNodeLeadingPadding: CGFloat
    
    public init(groupHeight: CGFloat, nodeHeight: CGFloat, childNodeLeadingPadding: CGFloat){
        self.groupHeight = groupHeight
        self.nodeHeight = nodeHeight
        self.childNodeLeadingPadding = childNodeLeadingPadding
    }
    
    var draggingOverGroup: UUID? {
        if draggedLocation == .zero {
            nil
        }else{
            isDraggingGroup ?
            nodeGroupFrames.first { (uuid, frame) in
                frame.contains(draggedLocation)
            }?.key
            : nil
        }
    }
    
    var draggingOverNode: UUID? {
        if draggedLocation == .zero {
            nil
        }else{
            isDraggingGroup ? nil :
            nodeFrames.sorted { (first, second) in
                first.value.origin.x > second.value.origin.x
            }.first { (uuid, frame) in
                frame.contains(draggedLocation)
            }?.key
        }
    }
    
    var isDraggingGroup: Bool {
        nodeGroups.contains(where: {$0.id == draggingItemId})
    }
    
    func findNextItemToScrollto(direction: MScrollDirection, point: CGPoint) -> UUID? {
        let targetNodePoint = CGPoint(x: point.x, y: point.y + (direction == .up ? -nodeHeight : nodeHeight))
        let targetGroupPoint = CGPoint(x: point.x, y: point.y + (direction == .up ? -groupHeight : groupHeight))
        return nodeFrames.first { (uuid, frame) in
            frame.contains(targetNodePoint)
        }?.key ?? nodeGroupFrames.first { (uuid, frame) in
            frame.contains(targetGroupPoint)
        }?.key
    }
    
    func getSingleNode(with id: UUID) -> (any Node)? {
        nodes.first {$0.id == id}
    }
    
    func getSingleGroup(with id: UUID) -> (any NodeGroup)? {
        nodeGroups.first {$0.id == id}
    }
    
    public func toggleGroupExpansion(with id: UUID?) {
        if let index = nodeGroups.firstIndex(where: {$0.id == id}) {
            nodeGroups[index].expanded.toggle()
        }
    }
    
    public func toggleNodeExpansion(with id: UUID?) {
        if let index = nodes.firstIndex(where: {$0.id == id}) {
            nodes[index].expanded.toggle()
        }
    }
    
    
    public func setNodeGroups(nodeGroups: [any NodeGroup]) {
        self.nodeGroups = nodeGroups
    }
    
    public func setNodes(nodes: [any Node]) {
        self.nodes = nodes
    }
    
    public func groupHasChildren(groupId: UUID?) -> Bool {
        nodes.count(where: {$0.groupId == groupId}) > 0
    }
    public func nodeHasChildren(nodeId: UUID?) -> Bool {
        nodes.count(where: {$0.parentNodeId == nodeId}) > 0
    }
    public func nodeIsFirstLevel(node: (any Node)?) -> Bool {
        if node?.parentNodeId == nil {
            return true
        }
        let parent = nodes.first(where: {$0.id == node?.parentNodeId})
        if parent?.parentNodeId == nil {
            return true
        }
        return false
    }
    // List all groups
    func listGroups() -> [any NodeGroup] {
        return nodeGroups
            .sorted(by: { $0.position < $1.position })
    }
    
    
    // List all nodes in a group
    func listNodes(in groupId: UUID?, with parentNodeId: UUID?) -> [any Node] {
        return nodes
            .filter { $0.groupId == groupId && $0.parentNodeId == parentNodeId }
            .sorted(by: { $0.position < $1.position })
    }
    
    
    // Move a node to a new group or reorder within the same group
    func moveNode(_ nodeId: UUID, toGroup newGroupId: UUID?, before: UUID? = nil, after: UUID? = nil) {
        guard let nodeIndex = nodes.firstIndex(where: { $0.id == nodeId }) else { return }
        
        // Update group reference
        nodes[nodeIndex].groupId = newGroupId
        
        // Update position
        if let beforeId = before, let beforeNode = nodes.first(where: { $0.id == beforeId }) {
            nodes[nodeIndex].position = beforeNode.position - 0.1
        } else if let afterId = after, let afterNode = nodes.first(where: { $0.id == afterId }) {
            nodes[nodeIndex].position = afterNode.position + 0.1
        }
    }
    
    // Delete a node
    func deleteNode(_ nodeId: UUID) {
        if let nodeIndex = nodes.firstIndex(where: { $0.id == nodeId }) {
            nodes.remove(at: nodeIndex)
        }
    }
    
    // Delete a group and all its nodes
    func deleteGroup(_ groupId: UUID) {
        // Remove all nodes in the group
        nodes.removeAll { $0.groupId == groupId }
        
        // Remove the group itself
        if let groupIndex = nodeGroups.firstIndex(where: { $0.id == groupId }) {
            nodeGroups.remove(at: groupIndex)
        }
    }
}
