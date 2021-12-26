//
//  Articles.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 26.12.21.
//

import Foundation

struct Article: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    
}
