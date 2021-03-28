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
    
    
//    описываем служебную ошибку
    enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["W2PKXXL8YG7F0LG6", "2SJF5W0TBQ3JB9X3", "1JKUFQI07CXAS8F6"]
    // каждый ключ работает раз в 5 минут
    
    func fetchSymbolsPublisher(keywords: String)  -> AnyPublisher<SearchResults, Error> {
        
//        кодируем слова keywords в URL
        let result = parseQuery(text: keywords)
        var symbol = String()
        switch result {
        case .success(let query):
            symbol = query
        case.failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        } //создаем строку URL-адреса
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(API_KEY)"
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
        case.success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map ({ $0.data})
                .decode (type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher ()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    
    
    
    }
//    добавляем функцию, чтобы узнать время
    func fetchTimeSeriesMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher <TimeSeriesMonthlyAdjusted, Error> {
        let result = parseQuery(text: keywords)
        
        var symbol = String()
        
        switch result {
        case .success(let query):
            symbol = query
        case.failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
    //создаем строку URL-адреса
    
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
        case.success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map ({ $0.data})
                .decode (type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher ()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func parseQuery(text: String) -> Result <String, Error> {
        
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return.success(query)
        } else {
            return.failure(APIServiceError.encoding)
        }
    }
    
    private func parseURL(urlString: String) -> Result <URL, Error> {
        if let url = URL (string: urlString) {
            return.success(url)
        } else {
            return.failure(APIServiceError.badRequest)
        }
    }
}
