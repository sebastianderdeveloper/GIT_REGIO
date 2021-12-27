//
//  kategorie.swift
//  LOGIN_App
//
//  Created by Sebastian Steiner on 27.12.21.
//

import Foundation

struct User {

    let first: String
    let last: String

}

let users = [
    User(first: "Emma", last: "Jones"),
    User(first: "Mike", last: "Thompson"),
    User(first: "Lucy", last: "Johnson"),
    User(first: "James", last: "Wood"),
    User(first: "Cathy", last: "Miller")
]

let result = users.filter { $0.last.starts(with: "J") } 
