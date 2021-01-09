//
//  CopyViewController.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 22.11.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import UIKit

class MainCurrencyViewController: UIViewController {
    
    var activiIndicator = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: CurrencyListViewModelProtocol! {
        didSet {
            viewModel.fetchMarketData {
                self.activiIndicator.isHidden = true
                self.tableView.isHidden = false
                self.activiIndicator.stopAnimating()
                self.viewModel.loadLastSort()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoading()
    }
    
    @IBAction private func sortByName() { 
        viewModel.sortedByName()
    }
    @IBAction private func sortByPrice() {
        viewModel.sortedByPrice()
    }
    @IBAction private func sortByChange() {
        viewModel.sortedByPercentChange()
    }
    
    @IBAction private func goToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    
    @IBAction private func goToBotomm() {
        tableView.scrollToRow(at: IndexPath(row: viewModel.getLastRowNumber(), section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    @IBAction private func update() {
        viewLoading()
    }
    
    @objc func handleRefreshControl(sender: UIRefreshControl) {
        
        self.viewModel = CurrencyListViewModel(reloadData: self.tableView.reloadData)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

//MARK: - TableViewDataSource

extension MainCurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CurrencyTableViewCell
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath)
        cell.viewModel =  cellViewModel
        
        return cell
    }
}

//MARK: - TableViewDelegate

extension MainCurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK:- LoadView
extension MainCurrencyViewController {
    
    private func viewLoading() {
        self.refreshControl.addTarget(self, action: #selector(handleRefreshControl(sender:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        self.tableView.refreshControl = refreshControl
        self.tableView.isHidden = true
        self.view.addSubview(activiIndicator)
        activiIndicator.center = self.view.center
        activiIndicator.startAnimating()
        tableView.rowHeight = 50
        viewModel = CurrencyListViewModel(reloadData: self.tableView.reloadData)
    }
}
