//
//  MTreeViewDemoApp.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/26/24.
//

import SwiftUI

@main
struct MTreeViewDemoApp: App {
    var body: some Scene {
        WindowGroup {
            TreeView(
                nodeGroupContent: { group, isMock in
                    HStack {
                        Text(group.title)
                            .foregroundStyle(isMock ? .secondary : .primary)
                        Spacer()
                    }
                },
                nodeContent: { node, isMock in
                    HStack {
                        Text(node.title)
                            .foregroundStyle(isMock ? .secondary : .primary)
                        Spacer()
                    }
                }
            )
        }
    }
}

