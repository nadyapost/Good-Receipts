//
//  DetailViewController.swift
//  GoodReceipts
//
//  Created by Nadya Postriganova on 27/12/19.
//  Copyright © 2019 Nadya Postriganova. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var receipt: Receipt
    
    var completion: (Receipt) -> Void
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [numberLabel, priceLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var numberLabel: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var priceLabel: UITextField = {
        let price = UITextField()
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    init(receipt: Receipt, completion: @escaping (Receipt) -> Void) {
        self.receipt = receipt
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = receipt.number
        view.backgroundColor = .white
        setupView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
    }
    @objc func doneTapped() {
        navigationController?.popViewController(animated: true)
        let newReceipt = Receipt(id: receipt.id, number: numberLabel.text ?? "", purchaseItems: receipt.purchaseItems, purchaseDate: receipt.purchaseDate, merchant: receipt.merchant, price: Int(priceLabel.text?.description ?? "") ?? 0)
        saveData(receipt: newReceipt)
    }
    
    func setupView() {
        numberLabel.text = receipt.number
        priceLabel.text = receipt.price.description
        
        self.view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // Put request to the server
    func saveData(receipt: Receipt) {
        guard let url = URL(string: "http://192.168.1.64:8080/receipts/\(receipt.id!)") else {
            return
            
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(receipt)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let updatedReceipt = try JSONDecoder().decode(Receipt.self, from: data)
                    DispatchQueue.main.async {
                        self.completion(updatedReceipt)
                    }
                } catch {
                    print("Error changing Json", error)
                }
            }
        }.resume()
        
    }
}
