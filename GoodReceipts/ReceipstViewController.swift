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
    let receipt1 = Receipt(number: "123456", purchaseItems: ["Milk", "Bread", "Butter"], purchaseDate: Data(), merchant: "Sandy Fruit Shop", price: 23.5)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipts"
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    @objc func addItem() {
        receipts.append(receipt1)
        tableView.reloadData()
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
        }
    }
    

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit", message: "Please enter new receipt number", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            textField in textField.placeholder = "Input receipr number here..."
        })
        alert.addAction(.init(title: "OK", style: .default, handler: { number in
            if let number = alert.textFields?.first?.text {
                self.receipts[indexPath.row].number = number
                self.tableView.reloadData()
            }
        }))
        alert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true)
        
    }

    
    // MARK: - Navigation
    
}
