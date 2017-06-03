import Foundation

class BasketService {
    
    class func totalPriceOfOrders(_ orders: [OrderItem]) -> Double {
        return orders.map{$0.product.price * Double($0.amount)}.reduce(0, +)
    }
    
    class func conversionOfTotal(totalValue: Double, forCurrency currency: Currency) -> Double {
        return totalValue * currency.rate
    }
}
