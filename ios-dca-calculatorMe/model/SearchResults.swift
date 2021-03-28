//
//  SearchResults.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 21.03.2021.
//
// после группы (папки) service делаем сервис пересылки сообщений из JSON с помощью  API

import Foundation

struct SearchResults: Decodable {
    let items: [SearchResult]
    //удержание ключей будет ключом строкового кодирования не по типу
    enum CodingKeys: String, CodingKey {
        case items = "bestMatches"
    }
    
}

struct SearchResult: Decodable {
    let symbol: String
    let name: String
    let type: String
    let currency: String
    
    //API возвращает ключ-значение в порядке: 1, 2, 3. Нужно переназначить
    //используем ключи кодировани
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
}


