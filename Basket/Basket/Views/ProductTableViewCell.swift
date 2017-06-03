import UIKit

public enum Padding {
    static let Edge: CGFloat = 8
    static let Element: CGFloat = 8
}

protocol ProductSelectionDelegate: class {
    func onChangeOrder(order: OrderItem)
}

class ProductTableViewCell: UITableViewCell {
    var order: OrderItem?
    weak var delegate: ProductSelectionDelegate?
    
    let productTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.tintColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.tintColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.tintColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(productTitleLabel)
        addSubview(priceTitleLabel)
        addSubview(amountLabel)
        addSubview(amountStepper)
        
        self.amountStepper.addTarget(self, action: #selector(ProductTableViewCell.amountChanged), for: .valueChanged)
        
        productTitleLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired - 1, for: .vertical)
        
        NSLayoutConstraint.activate([
            productTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.Edge),
            productTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Padding.Edge),
            
            priceTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.Edge),
            priceTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: productTitleLabel.bottomAnchor, constant: Padding.Element),
            priceTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Padding.Edge),
            
            amountLabel.centerXAnchor.constraint(equalTo: amountStepper.centerXAnchor),
            amountLabel.topAnchor.constraint(equalTo: topAnchor, constant: Padding.Edge),
            
            amountStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.Edge),
            amountStepper.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: Padding.Element),
            amountStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Padding.Edge),
            amountStepper.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProduct(_ product: Product) {
        self.order = OrderItem(product: product, amount: 0)
        productTitleLabel.text = product.name
        priceTitleLabel.text = "\(product.currency.description()) \(product.price) per \(product.unit)"
        amountLabel.text = "0"
    }
    
    func amountChanged(sender: Any) {
        guard let delegate = self.delegate else { return }
        self.order?.amount = Int(amountStepper.value)
        amountLabel.text = "\(amountStepper.value)"
        delegate.onChangeOrder(order: self.order!)
    }
}
