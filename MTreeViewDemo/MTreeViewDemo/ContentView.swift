//
//  ContentView.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 1/2/25.
//

import SwiftUI
import MTreeView

struct ContentView: View {

    @StateObject var viewModel: MTreeViewModel = .init(groupHeight: 44, nodeHeight: 44)
    
    var body: some View {
        VStack {
          
            MTreeView(viewModel: viewModel) { group, isDragging in
                HStack(spacing: 16){
                    Button {
                        withAnimation {
                            viewModel.toggleGroupExpansion(with: group.id)
                        }
                    } label: {
                        Image(Constants.Icons.chevronLeft)
                            .resizable()
                            .foregroundStyle(Constants.Colors.content.secondary)
                            .frame(width: 16, height: 16)
                            .rotationEffect(.degrees(group.expanded ? 45 : -45))
                    }
                    .buttonStyle(.plain)
                    
                    Text(group.title)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(Constants.Colors.content.secondary)
                        
                    Button {
                        
                        
                    } label: {
                        Image(Constants.Icons.plus)
                            .resizable()
                            .foregroundStyle(Constants.Colors.content.secondary)
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding(6)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Constants.Colors.background.secondary)
                }
                .padding(.bottom, 4)
                .padding(.top, 12)
                
            } nodeContent: { node, isDragging in
                VStack {
                    
                }
            }

        }
    }
}

#Preview {
    ContentView()
}
