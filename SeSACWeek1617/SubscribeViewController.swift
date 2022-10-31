//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    // lazy var - 필요할 때 초기화
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>> (configureCell: { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap -> Label: "안녕 반가워"
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        let sample = button.rx.tap
        
        // 1.
        sample
            .subscribe { [weak self] in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 2. weak self -> withUnretained
        button.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 3. subscribe
        // 메인 쓰레드 동작(UI니까). 네트워크 통신이나 파일 다운로드 등 백그라운드 작업?
        button.rx.tap
            .map { }
            .observe(on: MainScheduler.instance) // 다른 쓰레드로 동작하게 변경
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 4. bind (무조건 메인 쓰레드) => UI 요소는 bind! 에러나 컴플리트 발생 X
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, item) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 5. operator로 데이터의 stream 조작
        button.rx.tap
            .map { "안녕 반가워" } // 데이터의 흐름 조작
            .bind(to: label.rx.text) // 요기에 반영해주겠다
            .disposed(by: disposeBag)
        
        // 6. driver traits: bind + stream 공유(리소스 낭비 방지, share() )
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        
        // 1031
        Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
            .skip(3)
//            .debug()
            .filter { $0 % 2 == 0 }
            .map { $0 * 2 }
            .subscribe { value in
//                print(value)
            }
            .disposed(by: disposeBag)
        
        
        testRxAlamofire()
        testRxDataSource()
    }
    
    func testRxAlamofire() {
        let url = APIKey.searchURL + "apple"
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe { value in
                print(value.results[0].likes)
            }
            .disposed(by: disposeBag)
    }
    
    func testRxDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3])
        ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}
