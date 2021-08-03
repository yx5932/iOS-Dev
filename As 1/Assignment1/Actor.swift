//
//  Actor.swift
//  Assignment1
//
//  Created by Yan, Xin [sgxyan2] on 12/03/2019.
//  Copyright © 2019 Yan, Xin [sgxyan2]. All rights reserved.
//

import UIKit
class Actors: Codable {
    let actors: [Actor]
    init(actors: [Actor]){
        self.actors = actors
    }
}

class Actor: Codable {
    let year: String
    let id: String
    let owner: String?
    let email: String?
    let authors: String
    let title: String
    let abstract: String?
    let pdf: URL?
    let comment: String?
    let lastModified: String
    
    init(year: String, id: String, owner: String, email: String, authors: String, title: String, abstract: String, pdf: URL, comment: String, lastModified: String){
        self.year = year
        self.id = id
        self.owner = owner
        self.email = email
        self.authors = authors
        self.title = title
        self.abstract = abstract
        self.pdf = pdf
        self.comment = comment
        self.lastModified = lastModified
    }
}
