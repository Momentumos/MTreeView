//
//  CGRect+Extension.swift
//  MTreeViewDemo
//
//  Created by Mohammad Yeganeh on 12/30/24.
//
import SwiftUI

extension CGRect {
    // Check if a point is in the upper half of the frame
    func isPointInUpperHalf(_ point: CGPoint) -> Bool {
        return point.y < self.midY
    }

    // Check if a point is in the lower half of the frame
    func isPointInLowerHalf(_ point: CGPoint) -> Bool {
        return point.y >= self.midY
    }
    
    // Define a threshold distance to check "closeness"
      private var closeThreshold: CGFloat {
          return 50 // Adjust this value as needed
      }

      // Check if the point is close to the top of the frame
      func isPointCloseToTop(_ point: CGPoint) -> Bool {
          return point.y < self.minY + closeThreshold
      }

      // Check if the point is close to the bottom of the frame
      func isPointCloseToBottom(_ point: CGPoint) -> Bool {
          return point.y > self.maxY - closeThreshold
      }
}
