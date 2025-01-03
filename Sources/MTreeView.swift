// The Swift Programming Language
// https://docs.swift.org/swift-book
//

import SwiftUI

public struct MTreeView<CustomNodeGroupView: View, CustomNodeView: View>: View {
    
    @ObservedObject var viewModel: MTreeViewModel
    let nodeGroupContent: ((any NodeGroup)?, Bool) -> CustomNodeGroupView
    let nodeContent: ((any Node)?, Bool) -> CustomNodeView
    
    public init(viewModel: MTreeViewModel, nodeGroupContent: @escaping ((any NodeGroup)?, Bool) -> CustomNodeGroupView, nodeContent: @escaping ((any Node)?, Bool) -> CustomNodeView) {
        self.viewModel = viewModel
        self.nodeGroupContent = nodeGroupContent
        self.nodeContent = nodeContent
    }
    
    public var body: some View {
        GeometryReader { geo in
            ScrollViewReader { scroll in
                ZStack {
                    ScrollView(showsIndicators: false) {
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
                            let groups = viewModel.listGroups()
                            ForEach(0..<groups.count, id:\.self) { i in
                                let group = groups[i]
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
                        let nodeId = viewModel.draggingOverNode!
                        let frame = viewModel.nodeFrames[nodeId] ?? .zero
                        let leadingPadding = viewModel.childNodeLeadingPadding
                        Capsule()
                            .fill(.blue)
                            .frame(width: frame.width - leadingPadding, height: 2)
                            .position(x: frame.midX + leadingPadding / 2, y: frame.isPointInUpperHalf(viewModel.draggedLocation) ? frame.minY : frame.maxY)
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
    var group: (any NodeGroup)?
    var isDragging: Bool
    let nodeGroupContent: ((any NodeGroup)?, Bool) -> CustomNodeGroupView
    let nodeContent: ((any Node)?, Bool) -> CustomNodeView
    @EnvironmentObject var viewModel: MTreeViewModel
    
    var nodes: [any Node] {
        viewModel.listNodes(in: group?.id, with: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            nodeGroupContent(group, isDragging)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(coordinateSpace: .named("MTreeViewCoordinateSpace"))
                        .onChanged({ value in
                            if viewModel.draggingItemId != group?.id {
                                viewModel.draggingItemId = group?.id
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
            
            if !nodes.isEmpty && group?.expanded == true {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<nodes.count, id: \.self) { i in
                        let node = nodes[i]
                        NodeView(
                            node: node,
                            isDragging: isDragging,
                            nodeContent: nodeContent
                        )
                        .id(node.id)
                    }
                }
            }
        }
        
        .overlay {
            if !isDragging {
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .named("MTreeViewCoordinateSpace"))) { _, newValue in
                            DispatchQueue.main.async {
                                if group != nil {
                                    self.viewModel.nodeGroupFrames[group!.id] = newValue
                                }
                            }
                        }
                }
            }
        }
    }
}

struct NodeView<CustomNodeView: View>: View {
    var node: (any Node)?
    var isDragging: Bool
    let nodeContent: ((any Node)?, Bool) -> CustomNodeView
    @EnvironmentObject var viewModel: MTreeViewModel
    
    var children: [any Node] {
        viewModel.listNodes(in: node?.groupId, with: node?.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            nodeContent(node, isDragging)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(coordinateSpace: .named("MTreeViewCoordinateSpace"))
                        .onChanged({ value in
                            if viewModel.draggingItemId != node?.id {
                                viewModel.draggingItemId = node?.id
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
            
            if !children.isEmpty && node?.expanded == true {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<children.count, id:\.self) { i in
                        let node = children[i]
                        NodeView(
                            node: node,
                            isDragging: isDragging,
                            nodeContent: nodeContent
                        )
                        .id(node.id)
                        .padding(.leading, viewModel.childNodeLeadingPadding)
                    }
                }
            }
        }
        .overlay {
            if !isDragging {
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .named("MTreeViewCoordinateSpace"))) { _, newValue in
                            DispatchQueue.main.async {
                                if node != nil {
                                    self.viewModel.nodeFrames[node!.id] = newValue
                                }
                            }
                        }
                }
            }
        }
    }
}
