import XCTest
@testable import Basket

class BasetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCalculateOneItem() {
        let product = Product(name: "Peas", price: 0.95, currency: Currency(name: "USD", rate: 1), unit: "bag")
        let order = OrderItem(product: product, amount: 1)
        let totalCalculated = BasketService.totalPriceOfOrders([order])
        assert(totalCalculated == 0.95)
    }
    
    func testCalculateOneMultipleItem() {
        let product = Product(name: "Peas", price: 0.90, currency: Currency(name: "USD", rate: 1), unit: "bag")
        let order = OrderItem(product: product, amount: 3)
        let totalCalculated = BasketService.totalPriceOfOrders([order])
        assert(totalCalculated == 2.7)
    }
    
    func testCalculateTwoItem() {
        let peasProduct = Product(name: "Peas", price: 0.95, currency: Currency(name: "USD", rate: 1), unit: "bag")
        
        let eggsProduct = Product(name: "Eggs", price: 2.10, currency: Currency(name: "USD", rate: 1), unit: "dozen")
        let peasOrder = OrderItem(product: peasProduct, amount: 1)
        let eggsOrder = OrderItem(product: eggsProduct, amount: 1)
        let totalCalculated = BasketService.totalPriceOfOrders([peasOrder, eggsOrder])
        assert(totalCalculated == 3.05)
    }
    
    func testCalculateTwoMultipleItem() {
        let peasProduct = Product(name: "Peas", price: 0.90, currency: Currency(name: "USD", rate: 1), unit: "bag")
        
        let eggsProduct = Product(name: "Eggs", price: 2.10, currency: Currency(name: "USD", rate: 1), unit: "dozen")
        let peasOrder = OrderItem(product: peasProduct, amount: 2)
        let eggsOrder = OrderItem(product: eggsProduct, amount: 3)
        let totalCalculated = BasketService.totalPriceOfOrders([peasOrder, eggsOrder])
        
        // round to 2 decimal points
        let roundedCalculated = round(100*totalCalculated)/100
        assert(roundedCalculated == 8.10)
    }
    
    func testCalculateConversionOfTotalSingleItem() {
        let currencyEUR = Currency(name: "EUR", rate: 1.1)
        
        let peasProduct = Product(name: "Peas", price: 0.90, currency: Currency(name: "USD", rate: 1), unit: "bag")
        let peasOrder = OrderItem(product: peasProduct, amount: 2)
        let total = BasketService.totalPriceOfOrders([peasOrder])
        let converted = BasketService.conversionOfTotal(totalValue: total, forCurrency: currencyEUR)
        
        // round to 2 decimal points
        let roundedConverted = round(100*converted)/100
        assert(roundedConverted == 1.98)
    }
    
    func testCalculateConversionOfTotalMultipleItems() {
        let currencyEUR = Currency(name: "EUR", rate: 1.1)
        
        let peasProduct = Product(name: "Peas", price: 0.90, currency: Currency(name: "USD", rate: 1), unit: "bag")
        let eggsProduct = Product(name: "Eggs", price: 2.10, currency: Currency(name: "USD", rate: 1), unit: "dozen")
        let peasOrder = OrderItem(product: peasProduct, amount: 2)
        let eggsOrder = OrderItem(product: eggsProduct, amount: 3)
        let total = BasketService.totalPriceOfOrders([peasOrder, eggsOrder])
        let converted = BasketService.conversionOfTotal(totalValue: total, forCurrency: currencyEUR)
        
        // round to 2 decimal points
        let roundedConverted = round(100*converted)/100
        assert(roundedConverted == 8.91)
    }
}
