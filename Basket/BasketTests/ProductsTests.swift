import XCTest
@testable import Basket

class ProductsTests: XCTestCase {
    let products = ProductsLoader().products
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPeasProduct() {
        let peas = products.filter{$0.name == "Peas"}.first
        XCTAssertNotNil(peas)
        assert(peas!.price == 0.95)
        assert(peas!.currency.name == "USD")
        assert(peas!.unit == "bag")
    }
    
    func testEggsProduct() {
        let eggs = products.filter{$0.name == "Eggs"}.first
        XCTAssertNotNil(eggs)
        assert(eggs!.price == 2.10)
        assert(eggs!.currency.name == "USD")
        assert(eggs!.unit == "dozen")
    }
    
    func testMilkProduct() {
        let milk = products.filter{$0.name == "Milk"}.first
        XCTAssertNotNil(milk)
        assert(milk!.price == 1.30)
        assert(milk!.currency.name == "USD")
        assert(milk!.unit == "bottle")
    }
    
    func testBeansProduct() {
        let beans = products.filter{$0.name == "Beans"}.first
        XCTAssertNotNil(beans)
        assert(beans!.price == 0.73)
        assert(beans!.currency.name == "USD")
        assert(beans!.unit == "can")
    }
}
