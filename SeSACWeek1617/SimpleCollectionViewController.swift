//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/19.
//

import UIKit

struct User: Hashable {
    let id = UUID().uuidString
    let name: String
    let age: Int
}

class SimpleCollectionViewController: UICollectionViewController {
//    var list = ["닭곰탕", "삼계탕", "삼분카레", "들기름김"]
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "에디", age: 13),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 5)
    ]
    
    // cellForItemAt 전에 생성되어야 한다 => register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    var hello: (() -> Void)! = {
        print("hello")
    }
    
    func welcome() {
        print("hello")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.collectionViewLayout = createLayout()
//
//        print(hello)
//        hello = welcome // welcome vs welcome()
//        print(hello)
//        hello()
//
//        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
//
//            var content = UIListContentConfiguration.valueCell()
//
//            content.text = itemIdentifier.name
//            content.textProperties.color = .red
//
//            content.secondaryText = "\(itemIdentifier)"
//            content.prefersSideBySideTextAndSecondaryText = false
//            content.textToSecondaryTextVerticalPadding = 20
//
//            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
//            content.imageProperties.tintColor = .brown
//
//            cell.contentConfiguration = content
//
//            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
//            backgroundConfig.backgroundColor = .lightGray
//            backgroundConfig.cornerRadius = 10
//            backgroundConfig.strokeWidth = 2
//            backgroundConfig.strokeColor = .systemPink
//            cell.backgroundConfiguration = backgroundConfig
//        }
//
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        })
//
//        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(list)
//        dataSource.apply(snapshot)
        
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in // itemIdentifier - 셀 정보
//            var content = cell.defaultContentConfiguration()
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.name
            content.textProperties.color = .red
            content.secondaryText = "\(itemIdentifier.age)" // text가 길어지면 자동으로 밑으로 내려감. 레이아웃 별로 생각 안해도 됨
            content.prefersSideBySideTextAndSecondaryText = false // secondaryText 옆으로 갈지 밑으로 갈지
            content.textToSecondaryTextVerticalPadding = 20
            
            content.image = itemIdentifier.age < 10 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            content.imageProperties.tintColor = .yellow
            
            cell.contentConfiguration = content
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        return cell
    }

}

extension SimpleCollectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
