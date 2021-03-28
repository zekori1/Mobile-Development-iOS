//
//  TimeSeriesMonthlyAdjusted.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 28.03.2021.
//

import Foundation

//сортировка данных

struct MonthInfo {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

struct TimeSeriesMonthlyAdjusted: Decodable {
    let meta: Meta
    let timeSeries: [String: OHLC]
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
//    вычисляем временной ряд, чтобы сортировать по датам
    
//    сортировка временного рядя
    func getMonthInfos() -> [MonthInfo] {
        var monthInfos: [MonthInfo] = []
        let sortedTimeSeries = timeSeries.sorted (by: { $0.key > $1.key})
        sortedTimeSeries.forEach { (dateString, ohlc) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)!
            let adjustedOpen = getAdjustedOpen(ohlc: ohlc)
            let monthInfo = MonthInfo (date: date, adjustedOpen: adjustedOpen, adjustedClose: Double (ohlc.adjustedClose)!)
            monthInfos.append(monthInfo)
        }
        return monthInfos
    }
//    расчитываем значение открытия
    private func getAdjustedOpen (ohlc: OHLC) -> Double {
        return Double (ohlc.open)! * (Double(ohlc.adjustedClose)! / Double(ohlc.close)!)
    }

}


struct Meta: Decodable {
    let symbol: String
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct OHLC: Decodable {
    let open: String
    let close: String
    let adjustedClose: String
    
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
