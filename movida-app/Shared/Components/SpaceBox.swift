//
//  SpaceBox.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct SpaceBox: View {
   var width: CGFloat?
   var height: CGFloat?

   var body: some View {
       Spacer()
           .frame(width: width, height: height)
   }
}
