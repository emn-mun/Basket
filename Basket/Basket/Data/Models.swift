import Foundation

struct Product: Equatable {
    let name: String
    let price: Double
    let currency: Currency
    let unit: String
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name &&
            lhs.price == rhs.price
    }
}

struct OrderItem {
    let product: Product
    var amount: Int = 0
}

struct Currency {
    let name: String
    let rate: Double
    
    func description() -> String {
        switch name {
        case "USD":
            return "$"
        case "EUR":
            return "€"
        default:
            return ""
        }
    }
}
