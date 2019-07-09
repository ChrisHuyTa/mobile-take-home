//
//  ViewController.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

class EpisodeListViewController: UIViewController {

    private let cellReuseId = "episodeCell"
    @IBOutlet weak var episodeTableView: UITableView!
    
    var episodeData: EpisodeResponse?
    var currentPage: Int = 1
    var episodes: [Episode] = []
    var apiService: APIService = {
        return APIServiceClient()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Episodes"
            
        episodeTableView.dataSource = self
        episodeTableView.delegate = self

        apiService.fetchEpisodes(page: currentPage) { (episodeData, httpError) in
            
            if httpError != nil {
                return
            }
            
            DispatchQueue.main.async {
                self.episodeData = episodeData
                self.episodes.append(contentsOf: self.episodeData!.results)
                self.episodeTableView.reloadData()
            }
            
        }
    }


}

extension EpisodeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == episodes.count - 5 && !episodeData!.info.next.isEmpty {
            self.currentPage += 1
            apiService.fetchEpisodes(page: self.currentPage) { (episodeData, httpError) in
                
                if httpError != nil {
                    return
                }
                
                DispatchQueue.main.async {
                    self.episodeData = episodeData
                    self.episodes.append(contentsOf: self.episodeData!.results)
                    self.episodeTableView.reloadData()
                }
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId)
        cell?.accessoryType = .disclosureIndicator
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseId)
        }
        
        let episode = episodes[indexPath.row]
        cell?.textLabel?.text = "\(episode.episode): \(episode.name)"
        cell?.detailTextLabel?.text = "Air date: \(episode.air_date)"
        
        return cell!
    }
    
    
}

extension EpisodeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
        
        let selectedEpisode = self.episodes[indexPath.row]
        
        let viewController = CharacterListViewController()
        viewController.episode = selectedEpisode
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
