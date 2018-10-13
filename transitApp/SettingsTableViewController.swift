//
//  SettingsTableViewController.swift
//  transitApp
//
//  Created by William Du on 2018/10/12.
//  Copyright © 2018 William Du. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var rateTheAppCell: UITableViewCell!
    
    @IBOutlet weak var viewWebsiteCell: UITableViewCell!
    
    @IBOutlet weak var emailAuthorCell: UITableViewCell!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellClicked = self.tableView.cellForRow(at: indexPath)
        
        if cellClicked == rateTheAppCell{
            tableView.deselectRow(at: indexPath, animated: true)
            let alertController = UIAlertController(title: NSLocalizedString("Like our app?", comment: ""), message: NSLocalizedString("Do you enjoy our app? Leave a review to support the author.", comment: ""), preferredStyle: .alert)
            let proceedAction = UIAlertAction(title: NSLocalizedString("Review", comment: ""), style: .default) { (action) in
                SKStoreReviewController.requestReview()
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            alertController.addAction(proceedAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            if cellClicked == viewWebsiteCell{
                tableView.deselectRow(at: indexPath, animated: true)
                guard let url = URL(string: "https://stringconstant.github.io/Beijing_Suburban_Railway/") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                if cellClicked == emailAuthorCell{
                    tableView.deselectRow(at: indexPath, animated: true)
                    guard let url = URL(string: "mailto:weirandu@gmail.com") else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    

    // MARK: - Table view data source


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
