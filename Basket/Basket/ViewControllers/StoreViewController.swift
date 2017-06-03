import UIKit

class StoreViewController: UITableViewController {
    
    let productTableViewCellID = "ProductTableViewCell"
    let products = ProductsLoader().products
    var orders = [OrderItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Basket"
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: productTableViewCellID)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        let checkoutButton = UIBarButtonItem(title: "CheckOut", style: .plain, target: self, action: #selector(showStorePage))
        navigationItem.setRightBarButton(checkoutButton, animated: false)
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: productTableViewCellID) as! ProductTableViewCell
        cell.setProduct(products[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // MARK: ProductSelectionDelegate
    func showStorePage(sender: Any) {
        let validOrders = orders.filter{$0.amount > 0}
        navigationController?.pushViewController(CheckoutViewController(orders: validOrders), animated: true)
    }
}

extension StoreViewController: ProductSelectionDelegate {
    func onChangeOrder(order: OrderItem) {
        // if product already exists, update amount; else add entry
        if let i = orders.index(where: { $0.product == order.product }) {
            orders[i].amount = order.amount
        } else {
            self.orders.append(order)
        }
    }
}
