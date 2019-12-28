//
//  ReceipstViewController.swift
//  GoodReceipts
//
//  Created by Nadya Postriganova on 27/12/19.
//  Copyright © 2019 Nadya Postriganova. All rights reserved.
//

import UIKit

class ReceiptsViewController: UITableViewController {
    var receipts: [Receipt] = []
    let receipt1 = Receipt(id: "", number: "123456", purchaseItems: ["Milk", "Bread", "Butter"], purchaseDate: Date(), merchant: "Sandy Fruit Shop", price: 23)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipts"
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        // Get request to the server
        guard let url = URL(string: "http://192.168.1.64:8080/receipts") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do {
                self.receipts = try JSONDecoder().decode([Receipt].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error ferching Json", error)
            }
            
        }.resume()
        
    }
    @objc func addItem() {
        createNewReceipt {
            
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return receipts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = receipts[indexPath.row].number
        cell?.accessoryType = .disclosureIndicator
        cell?.detailTextLabel?.text = receipts[indexPath.row].price.description

        return cell!
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            receipts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//            let newReceipt = Receipt(id: "", number: "New Added Receipt", purchaseItems: [], purchaseDate: Date(), merchant: "Planet Earth", price: 666)
//            receipts.insert(newReceipt, at: indexPath.row)
//            tableView.beginUpdates()
//            tableView.insertRows(at: [IndexPath(row: receipts.count - 1, section: 0)], with: .automatic)
//            tableView.endUpdates()

        }
    }
    

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let receipt = receipts[indexPath.row]
        let detailVC = DetailViewController(receipt: receipt, completion: { newRecept in
            
            self.receipts[indexPath.row] = newRecept
            self.tableView.reloadData()
        })
        self.navigationController?.pushViewController(detailVC, animated: true)
        
//        let alert = UIAlertController(title: "Edit", message: "Please enter new receipt number", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: {
//            textField in textField.placeholder = "Input receipr number here..."
//        })
//        alert.addAction(.init(title: "OK", style: .default, handler: { number in
//            if let number = alert.textFields?.first?.text {
//                self.receipts[indexPath.row].number = number
//                self.tableView.reloadData()
//            }
//        }))
//        alert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
//        self.present(alert, animated: true)
        
    }
    func createNewReceipt(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://192.168.1.64:8080/receipts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let newReceipt = Receipt(number: "Yoyoyo here's my new receipt", price: 0)
        request.httpBody = try? JSONEncoder().encode(newReceipt)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                    self.receipts.append(receipt)
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Error ferching Json", error)
                }
            }
            
        }.resume()
    }
    
    // MARK: - Navigation
    
}
