//
//  ContentView.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/26/24.
//

import SwiftUI


import SwiftUI

struct TreeView: View {
    
    @StateObject var viewModel: TreeViewModel = .init()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.listGroups()) { group in
                            NodeGroupView(
                                group: group
                            )
                            .id(group.id)
                        }
                    }
                }
                if viewModel.draggingOverNode != nil {
                    let frame = viewModel.nodeFrames[viewModel.draggingOverNode!] ?? .zero
                    Capsule()
                        .fill(.blue)
                        .frame(width: frame.width, height: 2)
                        .position(x: frame.midX, y: frame.isPointInUpperHalf(viewModel.draggedLocation) ? frame.minY + viewModel.nodeHeight : frame.maxY)
                }
                if viewModel.draggingOverGroup != nil {
                    let frame = viewModel.nodeGroupFrames[viewModel.draggingOverGroup!] ?? .zero
                    
                    Capsule()
                        .fill(.red)
                        .frame(width: frame.width, height: 2)
                        .position(x: frame.midX, y: frame.isPointInUpperHalf(viewModel.draggedLocation) ? frame.minY : frame.maxY)
                }
                if viewModel.draggedLocation != .zero {
                    Circle()
                        .fill(.red)
                        .frame(width: 10, height: 10)
                        .position(viewModel.draggedLocation)
                }
            }
            .coordinateSpace(name: "MTreeViewCoordinateSpace")
            .environmentObject(viewModel)
            .onChange(of: viewModel.draggedLocation) { oldValue, newValue in
                if geo.frame(in: .local).isPointCloseToTop(newValue) {
                    print("top \(Int.random(in: 0...999))")
                } else if geo.frame(in: .local).isPointCloseToBottom(newValue) {
                    print("bottom \(Int.random(in: 0...999))")
                    
                }
            }
        }
    }
    
    
}

// MARK: - ParentNodeView
struct NodeGroupView: View {
    
    var group: NodeGroup
    var nodes: [Node] {
        viewModel.listNodes(in: group.id, with: nil)
    }
    @EnvironmentObject var viewModel: TreeViewModel
    
    var xOffset: CGFloat {
        viewModel.draggingItemId == group.id ? viewModel.draggedTranslation.width : 0.0
    }
    
    var yOffset: CGFloat {
        viewModel.draggingItemId == group.id ? viewModel.draggedTranslation.height : 0.0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Parent Node
            HStack {
                Text(group.title)
                Spacer()
            }
            .padding(.horizontal, 6)
            .frame(height: viewModel.groupHeight)
            .contentShape(Rectangle())
            .background(Color.blue.opacity(0.2))
            
            // Child Nodes
            if !nodes.isEmpty {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(nodes) { node in
                        NodeView(
                            node: node
                        )
                        .id(node.id)
                    }
                }
                .padding(.leading, 20)
            }
        }
        .offset(x: xOffset, y: yOffset)
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .onChange(of: geo.frame(in: .named("MTreeViewCoordinateSpace"))) { _, newValue in
                        DispatchQueue.main.async {
                            self.viewModel.nodeGroupFrames[group.id] = newValue
                        }
                    }
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("MTreeViewCoordinateSpace"))
                .onChanged({ value in
                    if viewModel.draggingItemId != group.id {
                        viewModel.draggingItemId = group.id
                    }
                    viewModel.draggedTranslation = value.translation
                    viewModel.draggedLocation = value.location
                }).onEnded({ value in
                    viewModel.draggedTranslation = .zero
                    viewModel.draggingItemId = nil
                    viewModel.draggedLocation = .zero
                })
        )
    }
}

struct NodeView: View {
    var node: Node
    var children: [Node] {
        viewModel.listNodes(in: node.groupId, with: node.id)
    }
    @EnvironmentObject var viewModel: TreeViewModel
    
    var xOffset: CGFloat {
        viewModel.draggingItemId == node.id ? viewModel.draggedTranslation.width : 0.0
    }
    
    var yOffset: CGFloat {
        viewModel.draggingItemId == node.id ? viewModel.draggedTranslation.height : 0.0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(node.title)
                    .foregroundStyle(viewModel.draggingOverNode == node.id ? .red : .primary)
                
                Spacer()
            }
            .padding(.horizontal, 6)
            .frame(height: viewModel.nodeHeight)
            .contentShape(Rectangle())
            .background(Color.brown.opacity(0.2))
            
            if !children.isEmpty {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(children) { node in
                        NodeView(
                            node: node
                        )
                        .id(node.id)
                    }
                }
                .padding(.leading, 20)
            }
        }
        .offset(x: xOffset, y: yOffset)
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .onChange(of: geo.frame(in: .named("MTreeViewCoordinateSpace"))) { _, newValue in
                        DispatchQueue.main.async {
                            self.viewModel.nodeFrames[node.id] = newValue
                        }
                    }
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("MTreeViewCoordinateSpace"))
                .onChanged({ value in
                    if viewModel.draggingItemId != node.id {
                        viewModel.draggingItemId = node.id
                    }
                    viewModel.draggedTranslation = value.translation
                    viewModel.draggedLocation = value.location
                }).onEnded({ value in
                    viewModel.draggedTranslation = .zero
                    viewModel.draggingItemId = nil
                    viewModel.draggedLocation = .zero
                })
        )
    }
}


#Preview {
    ZStack {
        TreeView()
    }
    .padding(50)
}
