//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/25.
//

import UIKit
import RxCocoa
import RxSwift

class SubjectViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let publish = PublishSubject<Int>() // 초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) // 초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3) // bufferSize에 작성된 이벤트만큼 메모리에서 가지고 있다가 subscribe할 때 한번에 이벤트를 전달.
    let async = AsyncSubject<Int>()
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        let input = SubjectViewModel.Input(addTap: addButton.rx.tap, resetTap: resetButton.rx.tap, newTap: newButton.rx.tap, searchText: searchBar.rx.text)
        let output = viewModel.transform(input: input)
        
        
//        viewModel.list // VM -> VC (Output)
//            .asDriver(onErrorJustReturn: [])
        output.list
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)

//        addButton.rx.tap
        output.addTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
//        resetButton.rx.tap
        output.resetTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
//        newButton.rx.tap // VC -> VM (Input)
        output.newTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
            
//        searchBar.rx.text.orEmpty // VC -> VM (Input)
//            .distinctUntilChanged() // 같은 값을 받지 않음
        output.searchText
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // wait
            .subscribe { (vc, value) in
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)

//        publishSubject()
//        behaviorSubject()
//        replaySubject()
//        asyncSubject()
    }

}

extension SubjectViewController {
    
    func publishSubject() {
        
        publish.onNext(1)
        publish.onNext(2)
        // 구독 전이라 받지 않음
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        // 이후 이벤트는 무시
        publish.onNext(5)
        publish.onNext(6)
        
    }

    func behaviorSubject() {
        behavior.onNext(1)
        behavior.onNext(2)
        // 구독 전이라 받지 않음
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        
        behavior.onCompleted()
        
        behavior.onNext(5)
        behavior.onNext(6)
    }
    
    func replaySubject() {
        // bufferSize 1000이라면? 다 어디서 보관할까 -> 메모리에서 보관.. 너무 많이 보관하지는 않도록 주의
        
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)
        
        replay.onNext(3)
        replay.onNext(4)
        
        replay.onCompleted()
        
        replay.onNext(5)
        replay.onNext(6)
    }
    
    func asyncSubject() {
        `async`.onNext(1)
        `async`.onNext(2)
        // 구독 전이라 받지 않음
        
        `async`
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async completed")
            } onDisposed: {
                print("async disposed")
            }
            .disposed(by: disposeBag)
        
        `async`.onNext(3)
        `async`.onNext(4)
        `async`.on(.next(5))
        
        `async`.onCompleted()
        
        `async`.onNext(5)
        `async`.onNext(6)
    }

}
