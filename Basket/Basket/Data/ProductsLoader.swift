import Foundation

// Provide product details; ideally this would call an API for the available list of poducts & prices

struct ProductsLoader {
    let products = [Product(name: "Peas", price: 0.95, currency: Currency(name: "USD", rate: 1), unit: "bag"),
                    Product(name: "Eggs", price: 2.10, currency: Currency(name: "USD", rate: 1), unit: "dozen"),
                    Product(name: "Milk", price: 1.30, currency: Currency(name: "USD", rate: 1), unit: "bottle"),
                    Product(name: "Beans", price: 0.73, currency: Currency(name: "USD", rate: 1), unit: "can")]
}
