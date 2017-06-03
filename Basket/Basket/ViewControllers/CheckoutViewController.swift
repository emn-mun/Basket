import UIKit

class CheckoutViewController: UIViewController {
    
    let orders: [OrderItem]
    var currencies: [Currency]?
    
    let productTotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.tintColor = .gray
        label.text = "Total price:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceTotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.tintColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.tintColor = .gray
        label.text = "Available currencies:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["$"])
        segmentedControl.addTarget(self, action: #selector(CheckoutViewController.currencyChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    init(orders: [OrderItem]) {
        self.orders = orders
        super.init(nibName: nil, bundle: nil)
        layoutViews()
        setupProducts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    private func layoutViews() {
        view.addSubview(productTotalLabel)
        view.addSubview(priceTotalLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(currencySegmentedControl)
        
        priceTotalLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired - 1, for: .vertical)
        let currencySegmentedHorizontalAlignment = currencySegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        currencySegmentedHorizontalAlignment.priority = UILayoutPriorityRequired - 1
        
        NSLayoutConstraint.activate([
            productTotalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.Edge),
            productTotalLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: Padding.Edge),
            
            priceTotalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.Edge),
            priceTotalLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: Padding.Edge),
            
            descriptionLabel.topAnchor.constraint(equalTo: productTotalLabel.bottomAnchor, constant: Padding.Element),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.Element),
            
            currencySegmentedControl.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Padding.Edge),
            currencySegmentedControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Padding.Element),
            currencySegmentedHorizontalAlignment,
            currencySegmentedControl.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -Padding.Edge)
        ])
    }
    
    // Currency is optional; if for some reason we can't get the exchange rates, use US $
    private func calculateTotalPrice(currency: Currency?) -> Double {
        // calculate total
        let total = BasketService.totalPriceOfOrders(orders)
        if let currency = currency {
            // apply currency conversion
            return BasketService.conversionOfTotal(totalValue: total, forCurrency: currency)
        }
        return total
    }
    
    private func setupProducts() {
        let total = calculateTotalPrice(currency: nil)
        priceTotalLabel.text = String(format: "%.2f",total)
        
        APIClient.shared.fetchLatestCurrenciesWithResult { result in
            switch result {
            case .success(let value):
                print(value)
                self.currencies = value
                
                // Get an array of currency identifiers
                let currencyIdentifiers = value.map{$0.name.substring(from: $0.name.index($0.name.endIndex, offsetBy: -3))}
                DispatchQueue.main.async {
                    self.currencySegmentedControl.removeSegment(at: 0, animated: true)
                    _ = currencyIdentifiers.map{
                        self.currencySegmentedControl.insertSegment(withTitle: $0.description, at: self.currencySegmentedControl.numberOfSegments, animated: true)
                        
                        // Set selected currency to US $
                        if let i = currencyIdentifiers.index(where: { $0 == "USD" }) {
                            self.currencySegmentedControl.selectedSegmentIndex = i
                        }
                    }
                }
            case .failure(let error):
                self.showAlertWith(title: "No additional currencies", message: error.localizedDescription)
            }
        }?.resume()
    }

    func currencyChanged(sender: Any) {
        let total = calculateTotalPrice(currency: currencies?[currencySegmentedControl.selectedSegmentIndex])
        priceTotalLabel.text = String(format: "%.2f",total)
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
