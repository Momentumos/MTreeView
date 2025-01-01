//
//  TreeData.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//

import Foundation

@MainActor
final class TreeViewModel: ObservableObject, Sendable  {
    
    @Published private var nodeGroups: [NodeGroup] = []
    @Published private var nodes: [Node] = []
    
    @Published var nodeGroupFrames: [UUID: CGRect] = [:]
    @Published var nodeFrames: [UUID: CGRect] = [:]
    
    @Published var scrollOffset: CGFloat = .zero
    @Published var scrollStartOffset: CGFloat = .zero
    @Published var draggedTranslation: CGSize = .zero
    @Published var draggedLocation: CGPoint = .zero
    @Published var draggingItemId: UUID? = nil
    
    let groupHeight: CGFloat = 30
    let nodeHeight: CGFloat = 30
    
    var draggingOverGroup: UUID? {
        isDraggingGroup ?
        nodeGroupFrames.first { (uuid, frame) in
            frame.contains(draggedLocation)
        }?.key
        : nil
    }
    
    var draggingOverNode: UUID? {
        isDraggingGroup ? nil :
        nodeFrames.sorted { (first, second) in
            first.value.origin.x > second.value.origin.x
        }.first { (uuid, frame) in
            frame.contains(draggedLocation)
        }?.key
    }
    
    var isDraggingGroup: Bool {
        nodeGroups.contains(where: {$0.id == draggingItemId})
    }
    
    //    var draggingOverNodesLastChild: UUID {
    //        nodes.filter({draggingOverNodes.contains($0.id)})
    //
    //    }
    
    
    func findNextItemToScrollto(direction: MScrollDirection, point: CGPoint) -> UUID? {
        let targetNodePoint = CGPoint(x: point.x, y: point.y + (direction == .up ? -nodeHeight : nodeHeight))
        let targetGroupPoint = CGPoint(x: point.x, y: point.y + (direction == .up ? -groupHeight : groupHeight))
        return nodeFrames.first { (uuid, frame) in
            frame.contains(targetNodePoint)
        }?.key ?? nodeGroupFrames.first { (uuid, frame) in
            frame.contains(targetGroupPoint)
        }?.key
    }
    
    func getSingleNode(with id: UUID) -> Node {
        nodes.first {$0.id == id} ?? .init()
    }
    
    func getSingleGroup(with id: UUID) -> NodeGroup {
        nodeGroups.first {$0.id == id} ?? .init()
    }
    
    init(){
        fillWithMockData()
    }
    func fillWithMockData(){
        let parent1 = addGroup(title: "Parent 1")
        let parent2 = addGroup(title: "Parent 2")
        let parent3 = addGroup(title: "Parent 3")
        
        _ = addNode(title: "Child 1 - 1", groupId: parent1.id)
        _ = addNode(title: "Child 1 - 2", groupId: parent1.id)
        _ = addNode(title: "Child 1 - 3", groupId: parent1.id)
        let node = addNode(title: "Child 1 - 4", groupId: parent1.id)
        _ = addNode(title: "Child 1 - 4 - 1", groupId: parent1.id, parentNodeId: node.id)
        _ = addNode(title: "Child 1 - 4 - 2", groupId: parent1.id, parentNodeId: node.id)
        let node2 = addNode(title: "Child 1 - 4 - 3", groupId: parent1.id, parentNodeId: node.id)
        _ = addNode(title: "Child 1 - 4 - 3 - 1", groupId: parent1.id, parentNodeId: node2.id)
        _ = addNode(title: "Child 1 - 4 - 3 - 1", groupId: parent1.id, parentNodeId: node2.id)
        
        _ = addNode(title: "Child 2 - 1", groupId: parent2.id)
        _ = addNode(title: "Child 2 - 2", groupId: parent2.id)
        _ = addNode(title: "Child 2 - 3", groupId: parent2.id)
        _ = addNode(title: "Child 2 - 4", groupId: parent2.id)
        
        _ = addNode(title: "Child 3 - 1", groupId: parent3.id)
        _ = addNode(title: "Child 3 - 2", groupId: parent3.id)
        _ = addNode(title: "Child 3 - 3", groupId: parent3.id)
        _ = addNode(title: "Child 3 - 4", groupId: parent3.id)
    }
    
    func setNodeGroups(nodeGroups: [NodeGroup]) {
        self.nodeGroups = nodeGroups
    }
    
    func setNodes(nodes: [Node]) {
        self.nodes = nodes
    }
    // Add a new group
    func addGroup(id: UUID = UUID(), title: String, position: Float = 0.0, expanded: Bool = true) -> NodeGroup {
        let newGroup = NodeGroup(id: id, title: title, position: position, expanded: expanded)
        nodeGroups.append(newGroup)
        return newGroup
    }
    
    // Add a new node
    func addNode(id: UUID = UUID(), title: String, position: Float = 0.0, groupId: UUID? = nil, parentNodeId: UUID? = nil, expanded: Bool = true) -> Node {
        let newNode = Node(id: id, title: title, position: position, groupId: groupId, parentNodeId: parentNodeId, expanded: expanded)
        nodes.append(newNode)
        return newNode
    }
    
    // List all groups
    func listGroups() -> [NodeGroup] {
        return nodeGroups
            .sorted(by: { $0.position < $1.position })
    }
    
    
    // List all nodes in a group
    func listNodes(in groupId: UUID?, with parentNodeId: UUID?) -> [Node] {
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
