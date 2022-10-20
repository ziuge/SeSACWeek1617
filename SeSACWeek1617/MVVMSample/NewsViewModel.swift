//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/20.
//

import Foundation

class NewsViewModel {
    
    var pageNumber: CObservable<String> = CObservable("3000")
    
    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "") // 쉼표 없애는 메서드
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(from: number as NSNumber)!
        
        pageNumber.value = result
    }
    
    // MVVM 이해를 위한 코드
    func resetSample() {
        sample.value = []
    }
    
    func loadSample() {
        sample.value = News.items
    }
    
}
