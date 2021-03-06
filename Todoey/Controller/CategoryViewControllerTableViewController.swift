//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Canberk Cinar on 11/8/18.
//  Copyright © 2018 Canberk Cinar. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewControllerTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
      loadCategories()
      
    }
    
    //MARK: - TableView  DataSource Methods:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
         cell.textLabel?.text = category.name
        return cell
    }
    //MARK: - TableView Delegate Methods:
    override func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow{
        destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
    }
    //MARK: -TableView Manipulation Methods:
    func saveCategories ()
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
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest())
    {
  
        do{
            categoryArray = try context.fetch(request)
        }catch
        {
            print("error\(error)")
        }
    }

    //MARK: -Add New Category:
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context:self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert,animated:true,completion:nil)
    }

    
   
 
   
    
  
    
    
    
}
