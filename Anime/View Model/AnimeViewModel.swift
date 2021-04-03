//
//  AnimeViewModel.swift
//  Anime
//
//  Created by Anthony on 4/3/21.
//

import UIKit

class AnimeViewModel {

    // MARK: - Properties

    private var animeResults: [AnimeResult] = []
    private var imageCache = NSCache<AnyObject, AnyObject>()
    weak var animeCellDelegate: AnimeCellDelegate?

    // MARK: - My Functions

    func numberOfRowsInSection() -> Int {
        return animeResults.count
    }

    func setResults(_ results: [AnimeResult]) {
        self.animeResults = results
    }

    func configure(cell: AnimeTableViewCell, indexPath: IndexPath) {
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
                        if let updateCell = self.animeCellDelegate?.getCellForRow(at: indexPath) as? AnimeTableViewCell {
                            if let image = UIImage(data: imageData) {

                                updateCell.artworkImageView?.image = image
                                updateCell.artworkImageView?.contentMode = .scaleAspectFit
                                updateCell.artworkImageView?.clipsToBounds = true
                                self.imageCache.setObject(image, forKey: animeResult.imageURL as NSString)
                                self.animeCellDelegate?.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
            }
        }
    }

}
