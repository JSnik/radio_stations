//
//  SearchViewController.swift
//  Latvijas Radio
//
//  Created by Sandis Putnis on 13/12/2021.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    static var TAG = String(describing: SearchViewController.classForCoder())

    static var needsScrollReset = false
    static let EVENT_SCROLL_TO_TOP_SEARCH = "EVENT_SCROLL_TO_TOP_SEARCH"

    @IBOutlet weak var mainScrollView: UIScrollViewTouchable!
    @IBOutlet weak var wrapperContent: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerSearchByCategoriesCompact: UIView!
    @IBOutlet weak var containerBroadcastsByCategoriesCompact: UIView!
    @IBOutlet weak var containerSearch: UIView!
    @IBOutlet weak var buttonLoadMore: UIButtonLoadMore!
    @IBOutlet weak var containerChannels: UIView!
    @IBOutlet weak var buttonAllBroadcasts: UIButtonOctonary!
    @IBOutlet weak var buttonAllCategoriesLatin: UIButtonBase!
    @IBOutlet weak var buttonAllCategoriesCyrillic: UIButtonBase!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var textTitle: UILabelH1!
    @IBOutlet weak var textCategories: UILabelH4!
    @IBOutlet weak var textChannels: UILabelH4!
    @IBOutlet weak var searchResultsHeightConstttraint: NSLayoutConstraint!
    @IBOutlet weak var wrapperScrollViewContent: UIView!
    @IBOutlet weak var emptyLabelsView: UIView!
    @IBOutlet weak var labelBigEmpty1: UILabel!
    @IBOutlet weak var labelBigEmpty2: UILabel!

    weak var episodesCollectionViewController: EpisodesCollectionViewController!
    weak var broadcastsBySearchCompactCollectionViewController: BroadcastsBySearchCompactCollectionViewController!
    weak var broadcastsByCategoriesCompactCollectionViewController: BroadcastsByCategoriesCompactCollectionViewController!
    weak var channelsCollectionViewController: ChannelsCollectionViewController!
    @IBOutlet weak var closeSearchButton: UIButton!
    @IBOutlet weak var closeSearchButtonWidthConstraint: NSLayoutConstraint!
    weak var notificationViewController: NotificationViewController!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var fullDataset: [BroadcastsByCategoryModel]!
    var fullHitDataset: [Hit]!

    override func viewDidLoad() {
        super.viewDidLoad()
//        containerBroadcastsByCategoriesCompact.isHidden = true
        GeneralUtils.log(SearchViewController.TAG, "viewDidLoad")
        mySearchBar.delegate = self
        closeSearchButton.isHidden = true
        closeSearchButtonWidthConstraint.constant = 0
        closeSearchButton.layoutIfNeeded()
        // listeners
        buttonLoadMore.addTarget(self, action: #selector(clickHandler), for: .touchUpInside)
        buttonAllBroadcasts.addTarget(self, action: #selector(clickHandler), for: .touchUpInside)
        buttonAllCategoriesLatin.addTarget(self, action: #selector(clickHandler), for: .touchUpInside)
        buttonAllCategoriesLatin.titleLabel?.textColor = UIColor(named: ColorsHelper.BLACK)
        buttonAllCategoriesCyrillic.addTarget(self, action: #selector(clickHandler), for: .touchUpInside)
        
        // UI
        buttonAllCategoriesLatin.setText("A - Z", false)
        buttonAllCategoriesCyrillic.setText("A - Я", false)

        

        let barButtonAppearanceInSearchBar: UIBarButtonItem?
            barButtonAppearanceInSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            barButtonAppearanceInSearchBar?.image = UIImage(systemName: "xmark.circle") //UIImage(named: "ic_cross_rounded.png")?.withRenderingMode(.alwaysTemplate)
            barButtonAppearanceInSearchBar?.tintColor = UIColor.systemGray //UIColor(named: "lr-black")
            barButtonAppearanceInSearchBar?.title = nil
        
        performRequestBroadcastByCategory()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let customFont2 = UIFont(name: "FuturaPT-Bold", size: 17.0)
        let customFont = UIFont(name: "FuturaPT-Bold", size: 22.0)
        textTitle.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: 22.0))
//        if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {
//
//            textTitle.font = UIFont(descriptor: artistDescriptor,
//                                size: 22.0)
//        }
        textTitle.adjustsFontForContentSizeCategory = true
        textCategories.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont2 ?? UIFont.systemFont(ofSize: 22.0))
//        if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {
//
//            textCategories.font = UIFont(descriptor: artistDescriptor,
//                                size: 16.0)
//        }
        textCategories.adjustsFontForContentSizeCategory = true
        textChannels.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont2 ?? UIFont.systemFont(ofSize: 10.0))
        textChannels.adjustsFontForContentSizeCategory = true

        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTheTop), name: Notification.Name(SearchViewController.EVENT_SCROLL_TO_TOP_SEARCH), object: nil)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
//                        view.addGestureRecognizer(tapGesture)
        if mySearchBar.text?.count == 0 {
            containerSearch.superview?.sendSubviewToBack(containerSearch)
            emptyLabelsView.superview?.sendSubviewToBack(emptyLabelsView)
        }
    }

    @objc func scrollToTheTop() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.mainScrollView.setContentOffset(.zero, animated: false)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
        case StoryboardsHelper.SEGUE_EMBED_SEARCH_COLLECTION:
            self.broadcastsBySearchCompactCollectionViewController = (segue.destination as! BroadcastsBySearchCompactCollectionViewController)

//            self.episodesCollectionViewController = (segue.destination as! EpisodesCollectionViewController)
//            self.episodesCollectionViewController.scrollDelegate = self
//            self.episodesCollectionViewController.episodesCollectionLoadMoreDelegate = self
//            self.episodesCollectionViewController.isLoadMoreEnabled = true
//            self.episodesCollectionViewController.collectionView.scrollsToTop = true

            break
        case StoryboardsHelper.SEGUE_EMBED_BROADCASTS_BY_CATEGORIES_COMPACT_COLLECTION:
            self.broadcastsByCategoriesCompactCollectionViewController = (segue.destination as! BroadcastsByCategoriesCompactCollectionViewController)

            break
        case StoryboardsHelper.SEGUE_EMBED_CHANNELS_COLLECTION:
            self.channelsCollectionViewController = (segue.destination as! ChannelsCollectionViewController)
            
            let dataset = ChannelsManager.getChannels()
            self.channelsCollectionViewController.updateDataset(dataset)

            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reset scrolls.
        if (SearchViewController.needsScrollReset) {
            SearchViewController.needsScrollReset = false
            
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                self?.mainScrollView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    deinit {
        GeneralUtils.log(SearchViewController.TAG, "deinit")
        
        SearchViewController.needsScrollReset = false
    }
    
    // MARK: Custom
    
    @objc func clickHandler(_ sender: UIView) {
        if (sender == buttonLoadMore) {
            broadcastsByCategoriesCompactCollectionViewController.originalDataset = fullDataset
            broadcastsByCategoriesCompactCollectionViewController.updateDataset(fullDataset)
            
            buttonLoadMore.setVisibility(UIView.VISIBILITY_GONE)
        }
        if (sender == buttonAllBroadcasts) {
            let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_ALL_BROADCASTS, bundle: nil)
                                    .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_ALL_BROADCASTS) as! AllBroadcastsViewController)

            navigationController?.pushViewController(viewController, animated: true)
        }
        if (sender == buttonAllCategoriesLatin) {
            let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_ALL_BROADCASTS, bundle: nil)
                                    .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_ALL_BROADCASTS) as! AllBroadcastsViewController)

            navigationController?.pushViewController(viewController, animated: true)
        }
        if (sender == buttonAllCategoriesCyrillic) {
            let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_ALL_BROADCASTS, bundle: nil)
                                    .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_ALL_BROADCASTS) as! AllBroadcastsViewController)

            viewController.initialTabIndex = AllBroadcastsPageViewController.PAGE_INDEX_CYRILLIC
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func setViewStateNormal() {
//        containerSearchByCategoriesCompact.subviews[0].isHidden = false
        wrapperContent.setVisibility(UIView.VISIBILITY_VISIBLE)
        activityIndicator.setVisibility(UIView.VISIBILITY_GONE)
    }
    
    func setViewStateBLoading() {
//        containerSearchByCategoriesCompact.subviews[0].isHidden = true
        wrapperContent.setVisibility(UIView.VISIBILITY_GONE)
        activityIndicator.setVisibility(UIView.VISIBILITY_VISIBLE)
    }

    func performRequestBroadcastByCategory() {
        setViewStateBLoading()
        let broadcastByCategoryRequest = BroadcastByCategoryRequest(appDelegate.dashboardContainerViewController!.notificationViewController)

        broadcastByCategoryRequest.successCallback = { [weak self] (data) -> Void in
            self?.handleBroadcastsByCategoryResponse(data)
        }

        broadcastByCategoryRequest.execute()
    }
    
    func handleBroadcastsByCategoryResponse(_ data: [String: Any]) {
        var dataset = [BroadcastsByCategoryModel]()
        containerSearchByCategoriesCompact.subviews[0].isHidden = false
        let categories = data[BroadcastByCategoryRequest.RESPONSE_PARAM_CATEGORIES] as! [[String: Any]]
        print("SearchViewController handleBroadcastsByCategoryResponse categories = \(categories)")
        if (categories.count > 0) {
            for i in (0..<categories.count) {
                let category = categories[i]

                let id = category[BroadcastByCategoryRequest.RESPONSE_PARAM_ID] as! String
                let name = category[BroadcastByCategoryRequest.RESPONSE_PARAM_TITLE] as! String
                let broadcasts = category[BroadcastByCategoryRequest.RESPONSE_PARAM_BROADCASTS] as! [NSDictionary]

                let broadcastsByCategoryModel = BroadcastsByCategoryModel(String(id), name)
                broadcastsByCategoryModel.setBroadcasts(broadcasts)

                dataset.append(broadcastsByCategoryModel)
            }
            
            fullDataset = [BroadcastsByCategoryModel]()
            fullDataset.append(contentsOf: dataset)

            // initially, show only first 5 categories
            var initialDataset = [BroadcastsByCategoryModel]()
            for i in (0..<dataset.count) {
                if (i < 5) {
                    initialDataset.append(dataset[i])
                }
            }
            
            broadcastsByCategoriesCompactCollectionViewController.originalDataset = initialDataset
            broadcastsByCategoriesCompactCollectionViewController.updateDataset(initialDataset)
        }
        
        setViewStateNormal()
    }

    func handleSearchResponse(_ data: [String: Any], _ data1: Data) {
        var dataset = [Hit]()
        do {
            let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data1, options: .allowFragments) as! [String: Any]
            print("SearchViewController handleSearchResponse someDictionaryFromJSON = \(someDictionaryFromJSON)")
//            let json4Swift_Base = try SearchSuccess(someDictionaryFromJSON)
//            if let err = someDictionaryFromJSON["error"] as? Int,
//               err == 0 {
//                if let d = someDictionaryFromJSON["data"] as? [String: Any] {
//                if let d = someDictionaryFromJSON["hits"] as? [[String: Any]] /*[String: Any]*/ {
////                    if let items = d["items"] as? [[String: Any]] {
//                        let items = SearchHelper.getSearchItemListFromJsonArray(d) //items)  //EpisodesHelper.getEpisodesSearchListFromJsonArray(items)
//                        if (items.count > 0) {
//                            for item in items /*(0..<(items.count))*/ {
////                                if let hit = items[i] as? SearchItem {
//                                    dataset.append(item)
////                                }
//                            }
//                        }
////                }
//            }
            let jsonDecoder = JSONDecoder()
                let json4Swift_Base = try jsonDecoder.decode(SearchSuccess.self, from: data1)
////            let json4Swift_Base = try jsonDecoder.decode(SearchResult.self, from: data1)
//
                let hits = json4Swift_Base.hits
//            let hits = json4Swift_Base.data?.items
            //        let hits = data[SearchRequest.RESPONSE_PARAM_HITS] as! [[String: Any]]
            print("SearchViewController handleSearchResponse hits = \(hits)")
            if (hits?.count ?? 0 > 0) {
                for i in (0..<(hits?.count ?? 0)) {
                    if let hit = hits?[i] {
//
//                        //                let id = hit[BroadcastByCategoryRequest.RESPONSE_PARAM_ID] as! String
//                        //                let name = hit[BroadcastByCategoryRequest.RESPONSE_PARAM_TITLE] as! String
//                        //                let broadcasts = hit[BroadcastByCategoryRequest.RESPONSE_PARAM_BROADCASTS] as! [NSDictionary]
//                        //
//                        //                let broadcastsByCategoryModel = BroadcastsByCategoryModel(String(id), name)
//                        //                broadcastsByCategoryModel.setBroadcasts(broadcasts)
//                        //
//                        //                dataset.append(broadcastsByCategoryModel)
                        dataset.append(hit)
                    }
                }

                fullHitDataset = [Hit]()
                fullHitDataset.append(contentsOf: dataset)

                // initially, show only first 5 categories
                var initialDataset = [Hit]()
                for i in dataset {
                        initialDataset.append(i)
                }
                if initialDataset.count > 0 {
                    searchResultsHeightConstttraint.constant = 0 //350
                } else {
                    searchResultsHeightConstttraint.constant = 0 //10
                }
//                episodesCollectionViewController.updateDataset(initialDataset)

                broadcastsBySearchCompactCollectionViewController?.originalDataset = initialDataset
                broadcastsBySearchCompactCollectionViewController?.updateDataset(initialDataset)
                if dataset.count > 0 {
                    containerSearch.superview?.bringSubviewToFront(containerSearch)
                    emptyLabelsView.superview?.sendSubviewToBack(emptyLabelsView)
                    hideStartedUI()
                } else {
                    hideStartedUI()
                    containerSearch.superview?.bringSubviewToFront(containerSearch)
                    emptyLabelsView.superview?.bringSubviewToFront(emptyLabelsView)
                }
            }

            setViewStateNormal()
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            fatalError("Failed to decode due to type mismatch '\(type)' – \(context.codingPath) - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode: \(error.localizedDescription)")
        }

        /*
         var dataset = [Item]()
         var searchSuccess = SearchSuccess()

         print("SearchViewController handleSearchResponse data = \(data)")
         //        do {
         //            let responseJson = try JSONSerialization.jsonObject(with: data, options: [])
         //let searchSuccess = try? JSONDecoder().decode(SearchSuccess.self, from: data)

         //            print("searchSuccess = \(String(describing: searchSuccess))")
         dataset = data["hits"] //?? [Item]()
         if (dataset.count > 0) {

         fullHitDataset = [Item]()
         fullHitDataset.append(contentsOf: dataset)

         // initially, show only first 5 categories
         var initialDataset = [Item]()
         for i in (0..<dataset.count) {
         if (i < 5) {
         print("dataset[\(i)] = \(dataset[i])")
         initialDataset.append(dataset[i])
         }
         }

         broadcastsBySearchCompactCollectionViewController.updateDataset(initialDataset)
         broadcastsBySearchCompactCollectionViewController.originalDataset = initialDataset
         }

         setViewStateNormal()

         //        } catch let error as NSError {
         //            print("Error: \(error.domain)")
         //
         //        }
         */
    }

    func searchStart(searchString: String) {
        print("searchStart")
        let urlQueryItems = [
            URLQueryItem(name: "q", value: searchString),
            URLQueryItem(name: "query_by", value:"show_name,title,authors,description,categories,tags"),
                            //"show_name,episode_title,authors,description,categories"),
            URLQueryItem(name: "x-typesense-api-key", value: Configuration.X_TYPESENSE_API_KEY),
            URLQueryItem(name: "module", value: "articles"),
            URLQueryItem(name: "method", value: "list"),
            URLQueryItem(name: "apikey", value: Configuration.API_KEY),
//            URLQueryItem(name: "data", value: "data=%7B%22search%22%3A%22\(searchString)%22%7D")
//            URLQueryItem(name: "data", value: "{“search”:”\(searchString)")
            URLQueryItem(name: "data", value: "{\"search\":\"" + searchString + "\"}")
            //{“search”:”aigars”}
        ]
        let searchRequest = SearchRequest(urlQueryItems)
        searchRequest.successCallback = { [weak self] (data, data1) -> Void in
            print("SearchRequest data = \(data),  data1 = \(data1)")
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print("searchStart SearchRequest jsonString = \(jsonString)")
//                    let searchSuccess = try SearchSuccess(jsonString, using: .utf8)
//                    print("searchStart searchSuccess = \(String(describing: searchSuccess))")
                    self?.handleSearchResponse(data, data1)
//                }

//            } catch {
//                GeneralUtils.log(SearchViewController.TAG, error.localizedDescription)
//            }
        }
        searchRequest.errorCallback = { [weak self] in
            print("searchRequest.errorCallback")
        }
        searchRequest.execute()
    }

//}

//extension SearchViewController {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        if searchBar.text?.count != 0 {
            broadcastsBySearchCompactCollectionViewController.isShowHistory = false
            searchStart(searchString: searchBar.text ?? "")
        } else {
            broadcastsBySearchCompactCollectionViewController.isShowHistory = true
            broadcastsBySearchCompactCollectionViewController.showHistoryNeed()
            containerSearch.superview?.bringSubviewToFront(containerSearch)
            //emptyLabelsView.superview?.bringSubviewToFront(emptyLabelsView)
            emptyLabelsView.superview?.sendSubviewToBack(emptyLabelsView)
            hideStartedUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                // Put your code which should be executed with a delay here
                if self.broadcastsBySearchCompactCollectionViewController.historyDataset.count > 0 {
                    self.emptyLabelsView.superview?.sendSubviewToBack(self.emptyLabelsView)
                } else {
                    self.emptyLabelsView.superview?.bringSubviewToFront(self.emptyLabelsView)
                }
            }
        }

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
//        searchBar.setShowsCancelButton(true, animated: true)
        broadcastsBySearchCompactCollectionViewController.isShowHistory = true
        broadcastsBySearchCompactCollectionViewController.showHistoryNeed()

        closeSearchButton.isHidden = false
        closeSearchButtonWidthConstraint.constant = 46
        closeSearchButton.layoutIfNeeded()

//        var initialDataset = [SearchItem]()
//        broadcastsBySearchCompactCollectionViewController?.updateDataset(initialDataset)
        if searchBar.text?.count == 0 {
            containerSearch.superview?.bringSubviewToFront(containerSearch)
            //emptyLabelsView.superview?.bringSubviewToFront(emptyLabelsView)
            emptyLabelsView.superview?.sendSubviewToBack(emptyLabelsView)
            hideStartedUI()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // Put your code which should be executed with a delay here
            if self.broadcastsBySearchCompactCollectionViewController.historyDataset.count > 0 {
                self.emptyLabelsView.superview?.sendSubviewToBack(self.emptyLabelsView)
            } else {
                self.emptyLabelsView.superview?.bringSubviewToFront(self.emptyLabelsView)
            }
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
//        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
//        mySearchBar.resignFirstResponder()
        dismissKeyboard()
//        if searchBar.text?.count == 0 {
//            broadcastsBySearchCompactCollectionViewController.isShowHistory = false
//            containerSearch.superview?.sendSubviewToBack(containerSearch)
//            emptyLabelsView.superview?.sendSubviewToBack(emptyLabelsView)
//            unhideStartedUI()
//            let initialDataset = [Hit]()
//            broadcastsBySearchCompactCollectionViewController?.originalDataset = initialDataset
//            broadcastsBySearchCompactCollectionViewController?.updateDataset(initialDataset)
//        }

    }

//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(false, animated: true)
//    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
        mySearchBar.resignFirstResponder()
        dismissKeyboard()
        if searchBar.text?.count != 0 {
            searchStart(searchString: searchBar.text ?? "")
        }
//        if searchBar.text?.count == 0 {
//            containerSearch.superview?.bringSubviewToFront(containerSearch)
//            emptyLabelsView.superview?.bringSubviewToFront(emptyLabelsView)
//        } else {
//            containerSearch.superview?.sendSubviewToBack(containerSearch)
//            emptyLabelsView.superview?.sendSubviewToBack(emptyLabelsView)
//        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        searchBar.resignFirstResponder()
        mySearchBar.resignFirstResponder()
        dismissKeyboard()
    }

    func hideStartedUI() {
        textCategories.isHidden = true
        containerBroadcastsByCategoriesCompact.isHidden = true
        textChannels.isHidden = true
        containerChannels.isHidden = true
        buttonAllBroadcasts.isHidden = true
        buttonAllCategoriesLatin.isHidden = true
        buttonAllCategoriesCyrillic.isHidden = true
        buttonAllBroadcasts.isEnabled = false
        buttonAllCategoriesLatin.isEnabled = false
        buttonAllCategoriesCyrillic.isEnabled = false
    }

    func unhideStartedUI() {
        textCategories.isHidden = false
        containerBroadcastsByCategoriesCompact.isHidden = false
        textChannels.isHidden = false
        containerChannels.isHidden = false
        buttonAllBroadcasts.isHidden = false
        buttonAllCategoriesLatin.isHidden = false
        buttonAllCategoriesCyrillic.isHidden = false
        buttonAllBroadcasts.isEnabled = true
        buttonAllCategoriesLatin.isEnabled = true
        buttonAllCategoriesCyrillic.isEnabled = true
    }

    @IBAction func clearSearch(_ sender: Any) {
        print("clearSearch")
//        mySearchBar.resignFirstResponder()
        dismissKeyboard()
        closeSearchButton.isHidden = true
        closeSearchButtonWidthConstraint.constant = 0
        closeSearchButton.layoutIfNeeded()
        if mySearchBar.text?.count == 0 {
                    broadcastsBySearchCompactCollectionViewController.isShowHistory = false
                    containerSearch.superview?.sendSubviewToBack(containerSearch)
                    emptyLabelsView.superview?.sendSubviewToBack(emptyLabelsView)
                    unhideStartedUI()
                    let initialDataset = [Hit]()
                    broadcastsBySearchCompactCollectionViewController?.originalDataset = initialDataset
                    broadcastsBySearchCompactCollectionViewController?.updateDataset(initialDataset)
                }
    }

//    @objc func didTapView(gesture: UITapGestureRecognizer) {
//            view.endEditing(true)
//            let touchLocation:CGPoint = gesture.location(ofTouch: 0, in: self.collectionView)
//            let indexPath = self.collectionView.indexPathForItem(at: touchLocation)
//            if indexPath != nil {
//                let cell = self.collectionView.cellForItem(at: indexPath!)
//                if (cell?.isSelected)! {
//                    //PREFORM DESELECT
//                } else {
//                    //PREFORM SELECT HERE
//                }
//            }
//        }

}

