//
//  SimpleTableViewController.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/19.
//

import UIKit

class SimpleTableViewController: UITableViewController {
    
    var list = ["슈비버거", "프랭크", "고래밥", "맥도날드", "버거킹"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell() // 상수임에도 contentConfiguration은 변경 가능!
        
        var content = cell.defaultContentConfiguration() // 프로퍼티를 건들려면 무조건 var로 처리
        content.text = list[indexPath.row] // textLabel
        content.secondaryText = "안녕하세요" // detailTextLabel
        
        cell.contentConfiguration = content
        
        return cell
    }
}
