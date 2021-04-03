//
//  AnimeTableViewController.swift
//  Anime
//
//  Created by Anthony on 4/2/21.
//

import UIKit

class AnimeTableViewController: UITableViewController {

    // MARK: - Properties

    var animeResults: [AnimeResult] = []
    var imageCache = NSCache<AnyObject, AnyObject>()

    // MARK: - Overridden

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAnimeResults()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeCell", for: indexPath) as! AnimeTableViewCell
        let animeResult = animeResults[indexPath.row]

        cell.titleLabel.text = animeResult.title
        cell.synopsisLabel.text = animeResult.synopsis
        cell.typeLabel.text = animeResult.type
        cell.ratingLabel.text = "\(animeResult.score)"

        // Hide episodes label if it's a movie or special
        if animeResult.episodes > 1 {
            cell.episodesLabel.isHidden = false
            cell.episodesLabel.text = "Episodes: \(animeResult.episodes)"
        } else {
            cell.episodesLabel.isHidden = true
        }

        if let image = imageCache.object(forKey: animeResult.imageURL as NSString) as? UIImage {
            cell.artworkImageView?.image = image
        } else {
            NetworkManager.getImage(url: animeResult.imageURL) { [weak self] (imageData) in
                if let imageData = imageData, let self = self {
                    DispatchQueue.main.async {

                        // Check if cell is still visible
                        if let updateCell = tableView.cellForRow(at: indexPath) as? AnimeTableViewCell {
                            if let image = UIImage(data: imageData) {

                                updateCell.artworkImageView?.image = image
                                updateCell.artworkImageView?.contentMode = .scaleAspectFit
                                updateCell.artworkImageView?.clipsToBounds = true
                                self.imageCache.setObject(image, forKey: animeResult.imageURL as NSString)
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
            }
        }

        return cell
    }


    // MARK: - My Functions

    func getAnimeResults(searchTerm: String = "naruto") {
        NetworkManager.getAnimeResults(searchTerm: searchTerm) { [weak self] (results) in
            if let results = results, let self = self {
                self.animeResults = results

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

}
