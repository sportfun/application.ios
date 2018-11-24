//
//  AccountCategory.swift
//  SportsFun
//
//  Created by benjamin malbrel on 29/04/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class AccountCategory : UIViewController, UITableViewDelegate, UITableViewDataSource {

    var category = [Category]()
    
    private func loadCategory() {
        let img1 = UIImage(named: "identity")
        let img2 = UIImage(named: "password")
        let img3 = UIImage(named: "cycle")
//        let img4 = UIImage(named: "photo")
        
        let cat1 = Category(name: "Identité", image: img1!)
        let cat2 = Category(name: "Mot de passe", image: img2!)
        let cat3 = Category(name: "Objectif", image: img3!)
        //        let cat4 = Category(name: "Photo", image: img4)
        
        category += [cat1, cat2, cat3]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AccountCategoryCellTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        cell.lName.text = category[indexPath.row].name
        cell.ivImage.image = category[indexPath.row].image

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as! AccountCategoryCellTableViewCell
        let currentItem = currentCell.lName.text
        var text : String

        switch currentItem {
        case "Identité" :
            text = currentItem!
        case "Mot de passe" :
            text = currentItem!
        default:
            text = "mdr"
        }

        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: currentItem!) as! AccountDetails

        self.navigationController!.pushViewController(secondViewController, animated: true)


        let alertController = UIAlertController(title: "Simplified iOS", message: "You Selected " + text , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
}
