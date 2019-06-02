//
//  TableViewController.swift
//  ButtonShortcutApp
//
//  Created by Sipos Péter on 2019. 06. 02..
//  Copyright © 2019. Sipos Péter. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var selectedValue: String?
    var numberOfFileToLoad: Int = 1
    let cellak = [
        "Első",
        "Második",
        "Harmadik",
        "Negyedik",
        "Ötödik",
        "Hatodik",
        "Hetedik",
        "Nyolcadik",
        "Kilencedik"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellak.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = cellak[indexPath.row]
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedValue = cellak[indexPath.row]
        numberOfFileToLoad = indexPath.row + 1
        performSegue(withIdentifier: "gotoSentences", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoSentences"{
            let nextViewController = segue.destination as! ButtonEditViewController
            nextViewController.title = selectedValue
            nextViewController.numberOfFileToLoad = numberOfFileToLoad
        }
    }
}
