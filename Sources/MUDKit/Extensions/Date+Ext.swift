import Foundation

extension Date {
    enum FormatterType {
        case dotDayMonthYear
    }
    
    static private let dateFormatter = DateFormatter()
    
    static func getDateFormatter(type: FormatterType) -> DateFormatter {
        switch type {
        case .dotDayMonthYear:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        }
        
        return dateFormatter
    }
    
    func getDotDayMonthYearString() -> String {
        return Self.getDateFormatter(type: .dotDayMonthYear).string(from: self)
    }
}
