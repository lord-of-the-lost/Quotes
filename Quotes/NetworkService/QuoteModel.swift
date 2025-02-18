//
//  QuoteModel.swift
//  Quotes
//
//  Created by Николай Игнатов on 18.02.2025.
//

import Foundation

struct QuoteModel: Decodable {
    let quote: String
    let author: String
    let category: String
}
