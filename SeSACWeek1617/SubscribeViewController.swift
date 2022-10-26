//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var label: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap -> Label: "안녕 반가워"
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 1.
        button.rx.tap
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
    }
    
    
}
