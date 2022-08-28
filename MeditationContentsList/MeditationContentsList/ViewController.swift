//
//  ViewController.swift
//  MeditationContentsList
//
//  Created by Kay on 2022/08/28.
//

import UIKit

enum Section {
    case main
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var changeModeButton: UIButton!
    
    var curated: Bool = false
    var items: [Meditation] = Meditation.list
    
    typealias Item = Meditation
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeditationCollectionViewCell", for: indexPath) as? MeditationCollectionViewCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        // Snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        
        let title = curated ? "See All" : "See Recommendation"
        changeModeButton.setTitle(title, for: .normal)
        changeModeButton.layer.cornerRadius = 10
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @IBAction func changeModeTapped(_ sender: UIButton) {
        curated.toggle()
        self.items = curated ? Meditation.recommendations : Meditation.list
        var snapshot =  NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
        
        let title = curated ? "See All" : "See Recommendation"
        changeModeButton.setTitle(title, for: .normal)
    }
}

