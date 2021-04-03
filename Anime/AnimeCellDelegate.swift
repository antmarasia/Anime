//
//  AnimeCellDelegate.swift
//  Anime
//
//  Created by Anthony on 4/3/21.
//

import UIKit

protocol AnimeCellDelegate: AnyObject {
    func getCellForRow(at indexPath: IndexPath) -> UITableViewCell?
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}
