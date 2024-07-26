//
//  SearchPhotoVM.swift
//  MyPalette
//
//  Created by 장예지 on 7/23/24.
//

import Foundation

enum SearchOrderType: String {
    case relevant
    case latest
}

enum SavePhotoStatus {
    case saved
    case removed
    case error
    
    var message: String{
        switch self {
        case .saved:
            return Localized.save_select_message.message
        case .removed:
            return Localized.save_unselect_message.message
        case .error:
            return "error"
        }
    }
}

final class SearchPhotoVM: BaseVM {
    
    var inputSearchText: Observable<String?> = Observable(nil)
    var inputNextPageTrigger: Observable<Void?> = Observable(nil)
    var inputIsSaveButtonSelected: Observable<(Bool?, Int?)> = Observable((nil,nil))
    
    var outputSearchResult: Observable<[Photo]> = Observable([])
    var outputSearchResultStatus: Observable<SearchStatus> = Observable(.initialScreen)
    var outputPresentToastMessage: Observable<String?> = Observable(nil)

    var text: String = ""
    var selectPhotoIndex: Int?
    var page: Int = 1
    
    private var totalPages: Int = 1
    
    private var orderType: SearchOrderType = .relevant
    var isEnd: Bool {
        return page < totalPages
    }
    
    override func bind() {
        super.bind()
        inputSearchText.bind { [weak self] text in
            guard let self, let text else { return }
            page = 1
            totalPages = 1
            self.text = text
            fetchSearchResult(query: text, page: page, orderBy: orderType)
        }
        
        inputNextPageTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            page += 1
            fetchSearchResult(query: text, page: page, orderBy: orderType)
        }
        
        inputIsSaveButtonSelected.bind { [weak self] isSelected, index in
            guard let self = self, let isSelected = isSelected, let index else { return }
            
            let photo = outputSearchResult.value[index]
            if isSelected {
                photo.urls.raw.fetchImage { image in
                    guard let image else {
                        self.outputPresentToastMessage.value = SavePhotoStatus.error.message
                        return
                    }
                    FileManager.saveImageToDocument(image: image, filename: photo.id)
                    SavePhotoRepository.shared.savePhoto(photo)
                    self.outputPresentToastMessage.value = SavePhotoStatus.saved.message
                }
                
            } else {
                FileManager.removeImageFromDocument(filename: photo.id)
                SavePhotoRepository.shared.deletePhoto(photo.id)
                outputPresentToastMessage.value = SavePhotoStatus.removed.message
            }
        }
    }
    
    private func fetchSearchResult(query: String, page: Int, orderBy: SearchOrderType){
        let param = SearchParameter(query: query, page: page, orderBy: orderBy.rawValue)
        APIService.shared.networking(api: .search(param: param), of: SearchResponse.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let result):
                print(result.totalPages)
                if page == 1 {
                    outputSearchResult.value = result.results
                    totalPages = result.totalPages
                } else {
                    outputSearchResult.value.append(contentsOf: result.results)
                }
                outputSearchResultStatus.value = result.results.isEmpty ? .resultIsEmpty : .searchSuccess
            case .error(let error):
                print(error)
            }
        }
    }
    
    public func photoIsSaved(_ photoId: String) -> Bool{
        return SavePhotoRepository.shared.findPhoto(photoId)
    }
}
