//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/20.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    
//    var pageNumber: CObservable<String> = CObservable("3000") // -> Behavior Subject로 개선
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    
//    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
//    var sample = BehaviorSubject(value: News.items)
    var sample = BehaviorRelay(value: News.items) // conflict 없게 만듦
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "") // 쉼표 없애는 메서드
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(from: number as NSNumber)!
        
//        pageNumber.value = result
        pageNumber.onNext(result)
        
    }
    
    // MVVM 이해를 위한 코드
    func resetSample() {
//        sample.value = []
//        sample.onNext([])
        sample.accept([])
    }
    
    func loadSample() {
//        sample.value = News.items
//        sample.onNext(News.items)
        sample.accept(News.items)
    }
    
}
