// The Swift Programming Language
// https://docs.swift.org/swift-book
//

import SwiftUI

struct MTreeView<CustomNodeGroupView: View, CustomNodeView: View>: View {
    @ObservedObject var viewModel: MTreeViewModel
    let nodeGroupContent: (NodeGroup, Bool) -> CustomNodeGroupView
    let nodeContent: (Node, Bool) -> CustomNodeView
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { scroll in
                ZStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Rectangle().fill(.clear)
                                .frame(height: 1)
                                .overlay {
                                    GeometryReader { scrollGeo in
                                        Color.clear.onChange(of: scrollGeo.frame(in: .global).minY) { _, newValue in
                                            viewModel.scrollOffset = newValue
                                        }
                                    }
                                }
                            ForEach(viewModel.listGroups()) { group in
                                NodeGroupView(
                                    group: group,
                                    isDragging: false,
                                    nodeGroupContent: nodeGroupContent,
                                    nodeContent: nodeContent
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
                            .fill(.blue)
                            .frame(width: frame.width, height: 2)
                            .position(x: frame.midX, y: frame.isPointInUpperHalf(viewModel.draggedLocation) ? frame.minY : frame.maxY)
                    }
                    if let draggingId = viewModel.draggingItemId {
                        let isGroup = viewModel.isDraggingGroup
                        if isGroup {
                            if let frame = viewModel.nodeGroupFrames[draggingId] {
                                NodeGroupView(group: viewModel.getSingleGroup(with: draggingId), isDragging: true, nodeGroupContent: nodeGroupContent, nodeContent: nodeContent)
                                    .frame(width: frame.width, height: frame.height)
                                    .position(x: frame.midX + viewModel.draggedTranslation.width,
                                              y: frame.midY + viewModel.draggedTranslation.height + (viewModel.scrollStartOffset - viewModel.scrollOffset))
                            }
                        } else {
                            if let frame = viewModel.nodeFrames[draggingId] {
                                NodeView(node: viewModel.getSingleNode(with: draggingId), isDragging: true, nodeContent: nodeContent)
                                    .frame(width: frame.width, height: frame.height)
                                    .position(x: frame.midX + viewModel.draggedTranslation.width,
                                              y: frame.midY + viewModel.draggedTranslation.height + (viewModel.scrollStartOffset - viewModel.scrollOffset))
                            }
                        }
                    }
                }
                .coordinateSpace(name: "MTreeViewCoordinateSpace")
                .environmentObject(viewModel)
                .onChange(of: viewModel.draggedLocation) { _, newValue in
                    if newValue != .zero {
                        if geo.frame(in: .local).isPointCloseToTop(newValue) {
                            withAnimation {
                                scroll.scrollTo(viewModel.findNextItemToScrollto(direction: .up, point: newValue), anchor: .top)
                            }
                        } else if geo.frame(in: .local).isPointCloseToBottom(newValue) {
                            withAnimation {
                                scroll.scrollTo(viewModel.findNextItemToScrollto(direction: .down, point: newValue), anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }
}
struct NodeGroupView<CustomNodeGroupView: View, CustomNodeView: View>: View {
    var group: NodeGroup
    var isDragging: Bool
    let nodeGroupContent: (NodeGroup, Bool) -> CustomNodeGroupView
    let nodeContent: (Node, Bool) -> CustomNodeView
    @EnvironmentObject var viewModel: MTreeViewModel
    
    var nodes: [Node] {
        viewModel.listNodes(in: group.id, with: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            nodeGroupContent(group, isDragging)
                .gesture(
                    DragGesture(coordinateSpace: .named("MTreeViewCoordinateSpace"))
                        .onChanged({ value in
                            if viewModel.draggingItemId != group.id {
                                viewModel.draggingItemId = group.id
                                viewModel.scrollStartOffset = viewModel.scrollOffset
                            }
                            viewModel.draggedTranslation = value.translation
                            viewModel.draggedLocation = value.location
                        })
                        .onEnded({ _ in
                            viewModel.draggedTranslation = .zero
                            viewModel.draggingItemId = nil
                            viewModel.draggedLocation = .zero
                        }),
                    isEnabled: !isDragging
                )
            
            if !nodes.isEmpty && group.expanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(nodes) { node in
                        NodeView(
                            node: node,
                            isDragging: isDragging,
                            nodeContent: nodeContent
                        )
                        .id(node.id)
                    }
                }
                .padding(.leading, 20)
            }
        }
        
        .overlay {
            if !isDragging {
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .named("MTreeViewCoordinateSpace"))) { _, newValue in
                            DispatchQueue.main.async {
                                self.viewModel.nodeGroupFrames[group.id] = newValue
                            }
                        }
                }
            }
        }
    }
}

struct NodeView<CustomNodeView: View>: View {
    var node: Node
    var isDragging: Bool
    let nodeContent: (Node, Bool) -> CustomNodeView
    @EnvironmentObject var viewModel: MTreeViewModel
    
    var children: [Node] {
        viewModel.listNodes(in: node.groupId, with: node.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            nodeContent(node, isDragging)
                .gesture(
                    DragGesture(coordinateSpace: .named("MTreeViewCoordinateSpace"))
                        .onChanged({ value in
                            if viewModel.draggingItemId != node.id {
                                viewModel.draggingItemId = node.id
                                viewModel.scrollStartOffset = viewModel.scrollOffset
                            }
                            viewModel.draggedTranslation = value.translation
                            viewModel.draggedLocation = value.location
                        })
                        .onEnded({ _ in
                            viewModel.draggedTranslation = .zero
                            viewModel.draggingItemId = nil
                            viewModel.draggedLocation = .zero
                        }),
                    isEnabled: !isDragging
                )
            
            if !children.isEmpty && node.expanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(children) { node in
                        NodeView(
                            node: node,
                            isDragging: isDragging,
                            nodeContent: nodeContent
                        )
                        .id(node.id)
                    }
                }
                .padding(.leading, 20)
            }
        }
        .overlay {
            if !isDragging {
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .named("MTreeViewCoordinateSpace"))) { _, newValue in
                            DispatchQueue.main.async {
                                self.viewModel.nodeFrames[node.id] = newValue
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel: MTreeViewModel = .init()
    MTreeView(
        viewModel: viewModel,
        nodeGroupContent: { group, isDragging in
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.toggleGroupExpansion(with: group.id)
                    }
                }, label: {
                    Image(systemName: "chevron.down")
                })
                .buttonStyle(.plain)
                .rotationEffect(.degrees(group.expanded ? 180 : 0))
                .opacity(isDragging ? 0.0 : 1.0)
                
                Text(group.title)
                    .foregroundStyle(isDragging ? .secondary : .primary)
                Spacer()
            }
            .padding(.horizontal, 6)
            .frame(height: 30)
            .background(isDragging ? .clear : Color.blue.opacity(0.2))
        },
        nodeContent: { node, isDragging in
            HStack {
                if !viewModel.listNodes(in: node.groupId, with: node.id).isEmpty {
                    Button(action: {
                        withAnimation {
                            viewModel.toggleNodeExpansion(with: node.id)
                        }
                    }, label: {
                        Image(systemName: "chevron.down")
                    })
                    .buttonStyle(.plain)
                    .rotationEffect(.degrees(node.expanded ? 180 : 0))
                    .opacity(isDragging ? 0.0 : 1.0)
                }
                Text(node.title)
                    .foregroundStyle(isDragging ? .secondary : .primary)
                Spacer()
            }
            .frame(height: 30)
            .padding(.horizontal, 6)
            .background(isDragging ? .clear : Color.brown.opacity(0.2))
        }
    )
}

