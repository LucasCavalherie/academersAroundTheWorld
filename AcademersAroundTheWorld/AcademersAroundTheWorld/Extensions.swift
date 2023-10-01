//
//  Extensions.swift
//  AcademersAroundTheWorld
//
//  Created by Henrique Semmer on 01/10/23.
//

import Foundation

extension Date {
    func getTimeInterval() -> String {
        let difference = self.timeIntervalSinceNow
        
        var differenceFormatted = difference * -1
        
        switch differenceFormatted {
        case _ where differenceFormatted < 1:
            return "Há menos do que 1 segundo"
        case _ where difference == 1:
            return "Há 1 segundo"
        case _ where differenceFormatted < 60:
            return "Há \(differenceFormatted.formatDecimal()) segundos"
        case _ where differenceFormatted < 120:
            return "Há 1 minuto"
        case _ where differenceFormatted < 3600:
            differenceFormatted /= 60
            return "Há \(differenceFormatted.formatDecimal()) minutos"
        case _ where difference < 7200:
            return "Há 1 hora"
        default:
            differenceFormatted /= 3600
            return "Há \(differenceFormatted.formatDecimal()) horas"
        }
    }
}

extension Double {
    func formatDecimal() -> String {
        let doubleFormatted = String(format: "%.0f", self)
        return doubleFormatted
    }
}
