//
//  ErrorView.swift
//  Movies
//
//  Created by Luka Gujejiani on 05.06.24.
//

import SwiftUI

struct ErrorView: View {
    // MARK:  Properties
    let error: Error
    
    // MARK: - View
    var body: some View {
        print(error)
        return Text("❌").font(.system(size: 20))
    }
}
