//
//  AnimeTableViewController.swift
//  Anime
//
//  Created by Anthony on 4/2/21.
//

import UIKit

class AnimeTableViewController: UITableViewController {

    // MARK: - Properties

    var animeViewModel = AnimeViewModel()
    var animeResults: [AnimeResult] = []

    lazy var resultSearchController = UISearchController()
    var currentSearchTerm = "naruto"

    // MARK: - Overridden

    override func viewDidLoad() {
        super.viewDidLoad()

        animeViewModel.animeCellDelegate = self

        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.text = currentSearchTerm
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeViewModel.numberOfRowsInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeCell", for: indexPath) as! AnimeTableViewCell
        animeViewModel.configure(cell: cell, indexPath: indexPath)
        return cell
    }


    // MARK: - My Functions

    func getAnimeResults(searchTerm: String = "naruto") {
        NetworkManager.getAnimeResults(searchTerm: searchTerm) { [weak self] (results) in
            guard let self = self else {
                return
            }

            guard let results = results else {
                return
            }

            self.animeViewModel.setResults(results)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: - UISearchResultsUpdating

extension AnimeTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            getAnimeResults(searchTerm: text)
            currentSearchTerm = text
        }
    }

}

// MARK: - AnimeCellDelegate

extension AnimeTableViewController: AnimeCellDelegate {

    func getCellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        return self.tableView.cellForRow(at: indexPath)
    }

    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.tableView.reloadRows(at: indexPaths, with: animation)
    }

}
