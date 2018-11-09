//
//  ViewController.swift
//  Todoey
//
//  Created by Canberk Cinar on 10/27/18.
//  Copyright © 2018 Canberk Cinar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
 
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    var selectedCategory : Category?
    {
        didSet{
             loadItems()
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
  
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       
    }
    
        
        
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
   return cell
    }
   //mark tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK -ADD NEW ITEMS
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context:self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
        self.itemArray.append(newItem)
        self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        
        }
        alert.addAction(action)
        present(alert,animated:true,completion:nil)
    }
    
    //MARK: Manupilation
    
func saveItems ()
{
    do
    {
      try context.save()
    }
    catch
    {
        print("error:\(error)")
    }
    
    self.tableView.reloadData()
}
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil)
{
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

    if let additionalPredicate = predicate
    {
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
    }
    else
    {
        request.predicate = categoryPredicate
    }
    
    do
    {
    itemArray = try context.fetch(request)
    }catch
    {
        print("error\(error)")
    }
}

}
//MARK: - SEARCH BAR METHODS
extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
       loadItems(with: request,predicate: predicate)
       
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
        loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
    }
}
}
