//
//  ContentView.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 1/2/25.
//

import SwiftUI
import MTreeView

struct ContentView: View {
    
    @StateObject var viewModel: MTreeViewModel = .init(groupHeight: 44, nodeHeight: 48, childNodeLeadingPadding: 28)
    @State var groups: [MNodeGroup] = []
    @State var nodes: [MNode] = []
    
    var body: some View {
        VStack {
            MTreeView(viewModel: viewModel) { group, isDragging in
                HStack(spacing: 12){
                    if !isDragging {
                        Button {
                            withAnimation {
                                viewModel.toggleGroupExpansion(with: group?.id)
                            }
                        } label: {
                            Image(Constants.Icons.chevronLeft)
                                .resizable()
                                .foregroundStyle(Constants.Colors.content.secondary)
                                .frame(width: 16, height: 16)
                                .rotationEffect(.degrees(group?.expanded == true ? 90 : -90))
                        }
                        .buttonStyle(.plain)
                        .opacity(viewModel.groupHasChildren(groupId: group?.id) ? 1.0 : 0.0)
                        
                    }
                    Text(group?.title ?? "")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(Constants.Colors.content.secondary)
                    
                    if !isDragging {
                        Button {
                            
                            
                        } label: {
                            Image(Constants.Icons.plus)
                                .resizable()
                                .foregroundStyle(Constants.Colors.content.secondary)
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .frame(height: 28)
                .padding(.horizontal, 6)
                .background {
                    if isDragging {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Constants.Colors.background.secondary.opacity(0.7))
                            .stroke(Constants.Colors.border.mainHover, lineWidth: 1)
                            .shadow(color: .black.opacity(0.08),radius: 8)
                    }else{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Constants.Colors.background.secondary)
                    }
                }
                .padding(.bottom, 4)
                .padding(.top, 12)
                
            } nodeContent: { node, isDragging in
                HStack(spacing: 0){
                    if !isDragging {
                        Button {
                            withAnimation {
                                viewModel.toggleNodeExpansion(with: node?.id)
                            }
                        } label: {
                            Image(Constants.Icons.chevronLeft)
                                .resizable()
                                .foregroundStyle(Constants.Colors.content.secondary)
                                .frame(width: 16, height: 16)
                                .rotationEffect(.degrees(node?.expanded == true ? 90 : -90))
                        }
                        .buttonStyle(.plain)
                        .frame(width: 28)
                        .opacity(viewModel.nodeHasChildren(nodeId: node?.id) ? 1.0 : 0.0)
                    }
                    HStack {
                        Image(Constants.Icons.taskStatusInProgress)
                            .resizable()
                            .frame(width: 24, height: 24)
                        if !isDragging {
                            HStack(spacing: 2){
                                Image(Constants.Icons.flagOutline)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(Constants.Colors.content.inactive)
                                
                                Image(Constants.Icons.boltOutline)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(Constants.Colors.content.inactive)
                                
                            }
                            .padding(4)
                            .background {
                                RoundedRectangle(cornerRadius: 6).fill(Constants.Colors.background.secondary)
                            }
                            
                            
                            Text("TSK-001")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundStyle(Constants.Colors.content.inactive)
                            
                        }
                        Text(node?.title ?? "")
                            .font(.footnote)
                            .foregroundStyle(Constants.Colors.content.main)
                        
                        Spacer(minLength: 0)
                        
                        if !isDragging {
                            Text(Date.now.formatted())
                                .font(.system(size: 10))
                                .foregroundStyle(Constants.Colors.content.alternative)
                            
                            Circle()
                                .fill(Constants.Colors.background.disabled)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 40)
                    .background {
                        if isDragging {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Constants.Colors.background.main.opacity(0.7))
                                .stroke(Constants.Colors.border.mainHover, lineWidth: 1)
                                .shadow(color: .black.opacity(0.08),radius: 8)
                        }else{
                            RoundedRectangle(cornerRadius: 8).stroke(Constants.Colors.border.main, lineWidth: 1)
                        }
                    }
                    
                }
                .overlay(content: {
                    if !isDragging {
                        HStack(spacing: 0){
                            Rectangle().fill(Constants.Colors.border.main).frame(width: 1, height: 40)
                            Spacer()
                        }
                        .offset(x: -14)
                    }
                })
                .frame(height: 48)
            }
            
        }
        .padding()
        .background(Constants.Colors.background.main)
        .onAppear {
            let inProgressGroupId = UUID()
            let toDoGroupId = UUID()
            let backlogGroupId = UUID()
            let doneGroupId = UUID()
            groups = [
                .init(id: inProgressGroupId, title: "In Progress", position: 1, expanded: true),
                .init(id: toDoGroupId, title: "To Do", position: 2, expanded: false),
                .init(id: backlogGroupId, title: "Backlog", position: 3, expanded: true),
                .init(id: doneGroupId, title: "Done", position: 4, expanded: true)
            ]
            let firstTaskId = UUID()
            let secondTaskId = UUID()
            let thirdTaskId = UUID()
            let fourtchTaskId = UUID()
            nodes = [
                .init(id: firstTaskId, title: "Task Title 1", position: 1, groupId: inProgressGroupId, expanded: true),
                .init(id: secondTaskId, title: "Task Title 2", position: 1, groupId: inProgressGroupId, parentNodeId: firstTaskId, expanded: true),
                .init(id: thirdTaskId, title: "Task Title 3", position: 1, groupId: inProgressGroupId, parentNodeId: secondTaskId, expanded: true),
                .init(id: fourtchTaskId, title: "Task Title 4", position: 1, groupId: inProgressGroupId, parentNodeId: thirdTaskId, expanded: true),
                .init(id: .init(), title: "Task Title", position: 1, groupId: inProgressGroupId, expanded: false),
                .init(id: .init(), title: "Task Title", position: 1, groupId: toDoGroupId, expanded: false),
                .init(id: .init(), title: "Task Title", position: 1, groupId: doneGroupId, expanded: false)
            ]
            
            viewModel.setNodeGroups(nodeGroups: groups)
            viewModel.setNodes(nodes: nodes)
        }
    }
}

#Preview {
    ContentView()
}

enum TaskStatus: Codable, Hashable, Equatable {
    case inProgress
    case offTrack
    case blocked
    case done
}


struct MNodeGroup: NodeGroup {
    var id: UUID
    var title: String
    var position: Float
    var expanded: Bool = true
}

struct MNode: Node {
    var id: UUID
    var title: String
    var position: Float
    var groupId: UUID?
    var parentNodeId: UUID?
    var expanded: Bool = true
    var status: TaskStatus = .inProgress
}


