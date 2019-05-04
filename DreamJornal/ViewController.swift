//
//  ViewController.swift
//  DreamJornal
//
//  Created by Adriana Pedroza Larsson on 2019-04-14.
//  Copyright © 2019 Adriana Pedroza Larsson. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate {
   
    
    
    
    let searchController = UISearchController(searchResultsController: nil)

    var dreamArray:[DreamDiaryCoreData] = []
    var searchArray:[DreamDiaryCoreData] = []
    
    var fetchResultController: NSFetchedResultsController<DreamDiaryCoreData>!

    var i = 0
    
    @IBOutlet weak var myTableView: UITableView!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        myTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        myTableView.reloadData()
        
        
        
        
   
    }
    
    // pick up the saved data from coredata and the atrtibutes
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<DreamDiaryCoreData> = DreamDiaryCoreData.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    dreamArray = fetchedObjects
                    myTableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    //number of rows in section depends on dreamarray
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive{
            
            return searchArray.count
            
        }else{
            
            return dreamArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    //animation
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let rotate = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        
        cell.layer.transform = rotate
        cell.alpha = 0.5
        
        UITableView.animate(withDuration: 1.0){
            
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
            
            
        }
        
        
    }

    
    
    

    
    
//shows ´the saved picture an the text, and when you serach.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DreamTableViewCell
        
       
        
        let row = indexPath.row

        
        
        var cellData = dreamArray[row]
        
        
        if searchController.isActive{
            cellData = searchArray[row]
        }else{
           
            
            cellData = dreamArray[row]
        }
        
        

        
        cell.cellTitleLabel.text = cellData.title
    
        
        
        if let dreamImg = cellData.thumb {
            cell.imageCell.image = UIImage(data: dreamImg as Data)
        } else {
            cell.imageCell.image = nil
        }
        
        return cell
        
        
    }
    
///editing the cells, deleting
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                context.delete(dreamArray[indexPath.row])
                appDelegate.saveContext()
                
                dreamArray.remove(at: indexPath.row)
                myTableView.reloadData()
            }
        }
    }
    //serach from the saved data in the array
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let search = searchController.searchBar.text {
            
            if let search = searchController.searchBar.text{
                
               
                searchArray = dreamArray.filter{($0.title?.hasPrefix(search))!} as! [DreamDiaryCoreData]
                
                myTableView.reloadData()
            }else{
                
            }
            
            print(search)
        }
        
        
    }
    
    //adds new cell and edit on exixting cell, from coredata and array
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            
//            let tVC:EditDreamViewController = segue.destination as! EditDreamViewController
//
//            if (myTableView.indexPathForSelectedRow != nil && segue.identifier == "addEdit")
//            {
//
//                tVC.changingData = dreamArray[myTableView.indexPathForSelectedRow!.row] as! NSManagedObject
//            }
//
//
        
        let targetVC:EditDreamViewController = segue.destination as! EditDreamViewController
        
        
        
        if (myTableView.indexPathForSelectedRow != nil)
        {
            
            targetVC.changingData = dreamArray[myTableView.indexPathForSelectedRow!.row] as! NSManagedObject
        }
        else if segue.identifier == "showEdit"{
            if segue.destination is EditDreamViewController{
                if (sender as? Int) != nil{
                    
                    dreamArray[myTableView.indexPathForSelectedRow!.row] as?
                    NSManagedObject
                }
                
            }
            
        
            
            
//        }else if segue.identifier == "showEdit" {
//            if let editPage = segue.destination as? EditDreamViewController {
//                if let indx = sender as? Int {
//
//
//                }
//            }
//        }
//
        }
        
        
        else if segue.identifier == "showMap"{
            if segue.destination is MapDreamViewController{
                if (sender as? Int) != nil{
                    
                    dreamArray[myTableView.indexPathForSelectedRow!.row] as?
                    NSManagedObject
                }
        
    }
        }

}
 
    
}

