//
//  APIService.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 21.03.2021.
//
//после того как шаблон был готов, время подключать API. API я скопировал с сайта alphavantage.co API ограничено и можно делать не более 5 запросов в минуту. Я пользуюсь генератором почты: gmailnator.com

import Foundation
import Combine

//общая структура для вызова  API

struct APIService {
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["MMBIXCUS535UXHW2", "7KO9H8QNK8XQACDB", "UVBMCRVD6E9F46UR"]
    // каждый ключ работает раз в 5 минут
    
    func fetchSymbolsPublisher(keywords: String)  -> AnyPublisher<SearchResults, Error> {
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
    //создаем строку URL-адреса
    
        let url = URL (string: urlString)!
    
    // строим сеанс URL
    
        return URLSession.shared.dataTaskPublisher(for: url)
            .map ({ $0.data})
            .decode (type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher ()
    
    
    
    }
    
    
}
