//
//  BroadcastsBySearchCompactCollectionViewController.swift
//  Latvijas Radio
//
//  Created by andriy kruglyanko on 16.10.2024.
//  Copyright © 2024 Latvijas Radio. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BroadcastsBySearchCompactCollectionViewController: UICollectionViewController, ClearHistorySearchDelegate {

    static var TAG = String(describing: BroadcastsBySearchCompactCollectionViewController.classForCoder())


    private let historyFileName = "historySearch.json"
    private let reuseIdentifier1 = "SearchCompactCollectionViewCell"
    private let reuseIdentifier2 = "HistoryCompactCollectionViewCell"
    private var dataset: [Hit]!
    private var historyItems: [Hit]!
    private var collectionContentSizeObserver: NSKeyValueObservation?
    var isShowHistory = false  /*{
        didSet {
            if isShowHistory == true  {
                self.showHistoryNeed()
            }
        }
    }*/

    var originalDataset: [Hit] = [Hit]()
    var historyDataset: [Hit] = [Hit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        GeneralUtils.log(BroadcastsBySearchCompactCollectionViewController.TAG, "viewDidLoad")
//        collectionView.collectionViewLayout.hei collectionViewContentSize.height = 50

        //sectionHeadersPinToVisibleBounds = true /*.layoutAttributesForSupplementaryView(ofKind: .he, at: <#T##IndexPath#>) .headerReferenceSize = CGSize(width: self.collectionView.bounds.size.width, height: 50)*/
//        collectionView.collectionViewLayout.sectionHeadersPinToVisibleBounds = true
//        layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.size.width, height: 60)
//            layout.sectionHeadersPinToVisibleBounds = true

//        collectionView.register(Header1CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header1")
//        collectionView.register(Footer1CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer1")
        collectionView.register(UINib(nibName: "Header1CollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header1")
        collectionView.register(UINib(nibName: "Footer1CollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer1")
//        collectionView.register(HistoryCompactCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
//        collectionView.register(SearchCompactCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier1)


        view.translatesAutoresizingMaskIntoConstraints = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.keyboardDismissMode = .onDrag
        
//        collectionContentSizeObserver = collectionView.observe(\.contentSize, options: .new) { (collView, change) in
//            if let containerView = self.view.superview {
//                ContainedCollectionViewHeightHelper.updateCollectionContainerHeightConstraint(view: containerView, collectionView: self.collectionView)
//            }
//        }
        // Do any additional setup after loading the view.
//        self.collectionView.scrollsToTop = true
//        collectionView.backgroundColor = UIColor.orange
        if self.dataset?.count ?? 0 > 0 {
            collectionView.isHidden = false
            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = true

            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = true
        } else {
            collectionView.isHidden = true
            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = true

            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = true
        }

    }
    
    deinit {
        GeneralUtils.log(BroadcastsBySearchCompactCollectionViewController.TAG, "deinit")
    }
    
    // MARK: Custom
    
    func updateDataset(_ dataset: [Hit]) {
        GeneralUtils.log(BroadcastsBySearchCompactCollectionViewController.TAG, "setupDataset")
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        config.backgroundColor = UIColor.clear


        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        collectionView.collectionViewLayout = layout

        if dataset.count > 0 {
            collectionView.isHidden = false
            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = true

            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = true
        } else {
            collectionView.isHidden = true

            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = true

            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = true
        }
        self.dataset = dataset

//        collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = true
//
//        collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = true
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }

    func showHistoryNeed() {
        print("showHistoryNeed")
        isShowHistory = true
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        config.backgroundColor = UIColor.clear
        config.headerMode = .supplementary
        config.footerMode = .supplementary

        let layout = UICollectionViewCompositionalLayout.list(using: config)

        collectionView.collectionViewLayout = layout


//        collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = false
//
//        collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = false
        let d1 = LivestreamsManager.readFromFile(fileName: historyFileName)
        if historyItems == nil {
            historyItems = [Hit]()
        }
        if dataset == nil {
            dataset = [Hit]()
        }
        do {
            if let data1 = d1 {
                dataset.removeAll()
                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data1, options: .allowFragments) as! [[String: Any]] //[String: Any]
                print("saveToHistory someDictionaryFromJSON = \(someDictionaryFromJSON)")
                let jsonDecoder = JSONDecoder()
                let json4Swift_Base = try jsonDecoder.decode([Hit].self, from: data1)

                let items = json4Swift_Base
                print("history items = \(String(describing: items))")

                if (items.count > 0) {
//                    collectionView.isHidden = false
                    historyItems.removeAll()
                    for i in (0..<(items.count)) {
                        if let item = items[i] as? Hit {
                            historyItems.append(item)
                        }
                    }
                } else {
//                    collectionView.isHidden = true
                }
            }
        } catch {
            print(error.localizedDescription)
        }

        if historyItems.count > 0 {
            collectionView.isHidden = false
            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = false

            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = false
        } else {
            collectionView.isHidden = true
            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.isHidden = false

            collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: 0))?.isHidden = false
        }
        self.dataset = historyItems
        historyDataset = historyItems
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }

    @objc func buttonDeleteFromHistoryClickHandler(_ sender: UIView) {
        if isShowHistory == true {
            let broadcastModel = dataset[sender.tag]
            dataset.remove(at: Int(sender.tag))
            historyItems.remove(at: Int(sender.tag))
//            collectionView.deleteItems(at: [IndexPath(row: Int(sender.tag), section: 0)])
            do {
                let dataHistory = try JSONEncoder().encode(dataset)
                if let r1 = saveJsonFromData(data: dataHistory, name: historyFileName) as? Bool,
                   r1 == true {
                    print("added item to history search")
                }
            } catch {
                print("Error saving JSON: \(error)")
            }
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
    }

    @objc func buttonSearchBroadcastClickHandler(_ sender: UIView) {
        //        let broadcastsByCategoryModel = dataset[sender.tag] as? Hit
        let broadcastModel = dataset[sender.tag]

//        var show_id = "0"
//        if let show_id1 = broadcastModel.document?.show_id {
//            show_id = "\(show_id1)"
//        }
//        let urlQueryItems = [
//            URLQueryItem(name: "x-typesense-api-key", value: Configuration.X_TYPESENSE_API_KEY),
//            URLQueryItem(name: "module", value: "articles"),
//            URLQueryItem(name: "method", value: "categories"),
//            URLQueryItem(name: "apikey", value: Configuration.API_KEY),
//            URLQueryItem(name: "data", value: "{\"id\":\"" + show_id + "\"}"),
//        ]
//        let searchBroadcastChosenRequest = BroadcastSearchRequest(urlQueryItems)
//        searchBroadcastChosenRequest.successCallback = { [weak self] (data, data1) -> Void in
//            print("BroadcastSearchRequest data = \(data),  data1 = \(data1)")
//            self?.handleSearchBroadcastResponse(data, data1)
//        }
//        searchBroadcastChosenRequest.errorCallback = { [weak self] in
//            print("BroadcastSearchRequest.errorCallback")
//        }
//        searchBroadcastChosenRequest.execute()
//
        var ident = "0"
        if let ident1 = broadcastModel.document?.show_id as? Int {
            ident = "\(ident1)"
        }
        let broadcastViewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_BROADCAST, bundle: nil)
                                .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_BROADCAST) as! BroadcastViewController)

        broadcastViewController.broadcastIdToQuery = "\(ident)"

        navigationController?.pushViewController(broadcastViewController, animated: true)
//        let urlQueryItems1 = [
//            URLQueryItem(name: "x-typesense-api-key", value: Configuration.X_TYPESENSE_API_KEY),
//            URLQueryItem(name: "module", value: "articles"),
//            URLQueryItem(name: "method", value: "article"),
//            URLQueryItem(name: "apikey", value: Configuration.API_KEY),
//            URLQueryItem(name: "data", value: "{\"id\":\"" + id + "\"}"),
//        ]
//        let searchEpisodeChosenRequest = EpisodeSearchRequest(urlQueryItems1)
//        searchEpisodeChosenRequest.successCallback = { [weak self] (data, data1) -> Void in
//            print("EpisodeSearchRequest data = \(data),  data1 = \(data1)")
//            self?.handleSearchEpisodeResponse(data, data1)
//        }
//        searchEpisodeChosenRequest.errorCallback = { [weak self] in
//            print("EpisodeSearchRequest.errorCallback")
//        }
//        searchEpisodeChosenRequest.execute()

        saveToHistory(sItem: broadcastModel)

//        let broadcastModel2 = EpisodeModel("\(String(describing: broadcastModel.id))")
//        broadcastModel2.setImageUrl(broadcastModel.imageURL ?? "")
//        broadcastModel2.setTitle(broadcastModel.title)
//        broadcastModel2.setDescription(broadcastModel.category?.descr)
//        broadcastModel2.setCategoryName(broadcastModel.category?.title ??  broadcastModel.title)
//        broadcastModel2.setChannelId(broadcastModel.category?.channel ?? "1")
//        broadcastModel2.setDateInMillis(broadcastModel.dateInMillis)
//        broadcastModel2.setBroadcastName(broadcastModel.category?.title ?? "")
//        broadcastModel2.setBroadcastEmail(broadcastModel.category?.email ?? "")
//        broadcastModel2.setMediaDurationInSeconds(broadcastModel.mediaDurationInSeconds)
//        broadcastModel2.setMediaStreamUrl(broadcastModel.mediaStreamUrl)
//        broadcastModel2.setLsmTags(broadcastModel.lsmTags ?? [String]())
//        broadcastModel2.setNewsBlocks(broadcastModel.newsBlocks ?? [String]())

        //        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_EPISODE, bundle: nil)
        //                                .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_EPISODE) as! EpisodeViewController)
        //
        //        viewController.episodeModel = broadcastModel2
        //
        //        navigationController?.pushViewController(viewController, animated: true)
//        var ident = ""
//        if let ident1 = broadcastModel.category?.id as? Int {
//            ident = "\(ident1)"
//        }
//        let broadcastModel1 = BroadcastModel(ident)
//        broadcastModel1.setImageUrl(broadcastModel.category?.imageURL ?? "")
//        broadcastModel1.setTitle(broadcastModel.category?.title ?? broadcastModel.title)
//        broadcastModel1.setDescription(broadcastModel.category?.descr)
//        broadcastModel1.setCategoryName(broadcastModel.category?.title ??  broadcastModel.title)
//        broadcastModel1.setChannelId(broadcastModel.category?.channel ?? "1")
//        broadcastModel1.setHosts(broadcastModel.category?.hosts ?? [String]())
        /*
        if let ident1 = broadcastModel.document?.id as? Int {
            ident = "\(ident1)"
        }
        let broadcastModel1 = BroadcastModel(ident)
        broadcastModel1.setImageUrl(broadcastModel.document?.image ?? "")
        broadcastModel1.setTitle(broadcastModel.document?.episodeTitle ?? "")
        broadcastModel1.setDescription(broadcastModel.document?.description)
        broadcastModel1.setCategoryName(broadcastModel.document?.showName ??  "")
        broadcastModel1.setChannelId(String(describing:  broadcastModel.document?.channel) ?? "1")


        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_BROADCAST, bundle: nil)
            .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_BROADCAST) as! BroadcastViewController)

        viewController.broadcastModel = broadcastModel1
        saveToHistory(sItem: broadcastModel)
        navigationController?.pushViewController(viewController, animated: true)
*/

        //        if let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_SEARCH_FILTERED, bundle: nil)
        //            .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_SEARCH_FILTERED) as? HitViewController) {
        //
        //            //viewController.searchItemModel = broadcastsByCategoryModel
        //
        //            navigationController?.pushViewController(viewController, animated: true)
        //        }
    }

    @objc func buttonSearchClickHandler(_ sender: UIView) {
        //        let broadcastsByCategoryModel = dataset[sender.tag] as? Hit
        let broadcastModel = dataset[sender.tag]

//        var show_id = "0"
//        if let show_id1 = broadcastModel.document?.show_id {
//            show_id = "\(show_id1)"
//        }
//        let urlQueryItems = [
//            URLQueryItem(name: "x-typesense-api-key", value: Configuration.X_TYPESENSE_API_KEY),
//            URLQueryItem(name: "module", value: "articles"),
//            URLQueryItem(name: "method", value: "categories"),
//            URLQueryItem(name: "apikey", value: Configuration.API_KEY),
//            URLQueryItem(name: "data", value: "{\"id\":\"" + show_id + "\"}"),
//        ]
//        let searchBroadcastChosenRequest = BroadcastSearchRequest(urlQueryItems)
//        searchBroadcastChosenRequest.successCallback = { [weak self] (data, data1) -> Void in
//            print("BroadcastSearchRequest data = \(data),  data1 = \(data1)")
//            self?.handleSearchBroadcastResponse(data, data1)
//        }
//        searchBroadcastChosenRequest.errorCallback = { [weak self] in
//            print("BroadcastSearchRequest.errorCallback")
//        }
//        searchBroadcastChosenRequest.execute()
//
        var id = "0"
        if let id1 = broadcastModel.document?.id {
            id = "\(id1)"
        }
        let deepLinkSharedEpisodeModel = DeepLinkSharedEpisodeModel(id)

        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_EPISODE, bundle: nil)
                                .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_EPISODE) as! EpisodeViewController)

        viewController.deepLinkSharedEpisodeModel = deepLinkSharedEpisodeModel

        navigationController?.pushViewController(viewController, animated: true)
//        let urlQueryItems1 = [
//            URLQueryItem(name: "x-typesense-api-key", value: Configuration.X_TYPESENSE_API_KEY),
//            URLQueryItem(name: "module", value: "articles"),
//            URLQueryItem(name: "method", value: "article"),
//            URLQueryItem(name: "apikey", value: Configuration.API_KEY),
//            URLQueryItem(name: "data", value: "{\"id\":\"" + id + "\"}"),
//        ]
//        let searchEpisodeChosenRequest = EpisodeSearchRequest(urlQueryItems1)
//        searchEpisodeChosenRequest.successCallback = { [weak self] (data, data1) -> Void in
//            print("EpisodeSearchRequest data = \(data),  data1 = \(data1)")
//            self?.handleSearchEpisodeResponse(data, data1)
//        }
//        searchEpisodeChosenRequest.errorCallback = { [weak self] in
//            print("EpisodeSearchRequest.errorCallback")
//        }
//        searchEpisodeChosenRequest.execute()

        saveToHistory(sItem: broadcastModel)

//        let broadcastModel2 = EpisodeModel("\(String(describing: broadcastModel.id))")
//        broadcastModel2.setImageUrl(broadcastModel.imageURL ?? "")
//        broadcastModel2.setTitle(broadcastModel.title)
//        broadcastModel2.setDescription(broadcastModel.category?.descr)
//        broadcastModel2.setCategoryName(broadcastModel.category?.title ??  broadcastModel.title)
//        broadcastModel2.setChannelId(broadcastModel.category?.channel ?? "1")
//        broadcastModel2.setDateInMillis(broadcastModel.dateInMillis)
//        broadcastModel2.setBroadcastName(broadcastModel.category?.title ?? "")
//        broadcastModel2.setBroadcastEmail(broadcastModel.category?.email ?? "")
//        broadcastModel2.setMediaDurationInSeconds(broadcastModel.mediaDurationInSeconds)
//        broadcastModel2.setMediaStreamUrl(broadcastModel.mediaStreamUrl)
//        broadcastModel2.setLsmTags(broadcastModel.lsmTags ?? [String]())
//        broadcastModel2.setNewsBlocks(broadcastModel.newsBlocks ?? [String]())
        
        //        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_EPISODE, bundle: nil)
        //                                .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_EPISODE) as! EpisodeViewController)
        //
        //        viewController.episodeModel = broadcastModel2
        //
        //        navigationController?.pushViewController(viewController, animated: true)
        var ident = ""
//        if let ident1 = broadcastModel.category?.id as? Int {
//            ident = "\(ident1)"
//        }
//        let broadcastModel1 = BroadcastModel(ident)
//        broadcastModel1.setImageUrl(broadcastModel.category?.imageURL ?? "")
//        broadcastModel1.setTitle(broadcastModel.category?.title ?? broadcastModel.title)
//        broadcastModel1.setDescription(broadcastModel.category?.descr)
//        broadcastModel1.setCategoryName(broadcastModel.category?.title ??  broadcastModel.title)
//        broadcastModel1.setChannelId(broadcastModel.category?.channel ?? "1")
//        broadcastModel1.setHosts(broadcastModel.category?.hosts ?? [String]())
        /*
        if let ident1 = broadcastModel.document?.id as? Int {
            ident = "\(ident1)"
        }
        let broadcastModel1 = BroadcastModel(ident)
        broadcastModel1.setImageUrl(broadcastModel.document?.image ?? "")
        broadcastModel1.setTitle(broadcastModel.document?.episodeTitle ?? "")
        broadcastModel1.setDescription(broadcastModel.document?.description)
        broadcastModel1.setCategoryName(broadcastModel.document?.showName ??  "")
        broadcastModel1.setChannelId(String(describing:  broadcastModel.document?.channel) ?? "1")


        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_BROADCAST, bundle: nil)
            .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_BROADCAST) as! BroadcastViewController)
        
        viewController.broadcastModel = broadcastModel1
        saveToHistory(sItem: broadcastModel)
        navigationController?.pushViewController(viewController, animated: true)
*/

        //        if let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_SEARCH_FILTERED, bundle: nil)
        //            .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_SEARCH_FILTERED) as? HitViewController) {
        //
        //            //viewController.searchItemModel = broadcastsByCategoryModel
        //
        //            navigationController?.pushViewController(viewController, animated: true)
        //        }
    }


    func saveToHistory(sItem: Hit) {
        let d1 = LivestreamsManager.readFromFile(fileName: historyFileName)
        if historyItems == nil {
            historyItems = [Hit]()
        }
        do {
            if let data1 = d1 {
//                dataset.removeAll()
                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data1, options: .allowFragments) as! [[String: Any]]
                print("saveToHistory someDictionaryFromJSON = \(someDictionaryFromJSON)")
                //            let json4Swift_Base = try SearchSuccess(someDictionaryFromJSON)
                let jsonDecoder = JSONDecoder()
                let json4Swift_Base = try jsonDecoder.decode([Hit].self, from: data1)

                let items = json4Swift_Base
                //        let hits = data[SearchRequest.RESPONSE_PARAM_HITS] as! [[String: Any]]
                print("history items = \(String(describing: items))")

                if (items.count > 0) {
                    historyItems.removeAll()
                    for i in (0..<(items.count)) {
                        if let item = items[i] as? Hit {
                            historyItems.append(item)
                        }
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        if let item = sItem as? Hit,
           let  el = historyItems.filter({ $0.document?.id == item.document?.id}) as? [Hit],
           el.count == 0
        {
            historyItems.append(item)
        }
        do {
            let dataHistory = try JSONEncoder().encode(historyItems)
            if let r1 = saveJsonFromData(data: dataHistory, name: historyFileName) as? Bool,
               r1 == true {
                print("added item to history search")
            }
        } catch {
            print("Error saving JSON: \(error)")
        }
    }

    func saveJsonFromData(data: Data, name: String) -> Bool {

        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        var saved = false
        if let n = "\(name)" as? String,
           let url1 = URL(string: n)
        {
//            DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "").backgrounds.saveRadioChannels", qos: DispatchQoS.background).async {[weak self] () -> Void in

                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(name)")
                print(paths)

                do {
                    try data.write(to: (directory.appendingPathComponent("\(url1.absoluteString)") ?? nil)!, options: [])
                    saved = true
                    DispatchQueue.main.async {
//                        reload data ui
                    }
                } catch {
                    print(error.localizedDescription)
                    saved = false
                }
//            }
            return saved
        } else {
            return saved
        }
    }

    func handleSearchBroadcastResponse(_ data: [String: Any], _ data1: Data) {
        var dataset = [Hit]()
        do {
            let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data1, options: .allowFragments) as! [String: Any]
            print("SearchViewController handleSearchBroadcastResponse someDictionaryFromJSON = \(someDictionaryFromJSON)")
            let jsonDecoder = JSONDecoder()
                let json4Swift_Base = try jsonDecoder.decode(SearchSuccess.self, from: data1)
                let hits = json4Swift_Base.hits
            print("SearchViewController handleSearchBroadcastResponse hits = \(String(describing: hits))")
            if (hits?.count ?? 0 > 0) {
                for i in (0..<(hits?.count ?? 0)) {
                    if let hit = hits?[i] {
                        dataset.append(hit)
                    }
                }
                // initially, show only first 5 categories
                var initialDataset = [Hit]()
                for i in dataset {
                        initialDataset.append(i)
                }
            }
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
    }


    func handleSearchEpisodeResponse(_ data: [String: Any], _ data1: Data) {
//        var dataset = [Hit]()
        do {
            let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data1, options: .allowFragments) as! [String: Any]
            print("SearchViewController handleSearchEpisodeResponse someDictionaryFromJSON = \(someDictionaryFromJSON)")
            if let dd1 = someDictionaryFromJSON["data"] as? [String : Any] {
                if let broadcastModel = SearchHelper.getSearchItemFromJsonObject(dd1) {
                    var ident = ""
                    if let ident1 = broadcastModel.category?.id as? Int {
                        ident = "\(ident1)"
                    }
                    let broadcastModel1 = BroadcastModel(ident)
                    broadcastModel1.setImageUrl(broadcastModel.category?.imageURL ?? "")
                    broadcastModel1.setTitle(broadcastModel.category?.title ?? broadcastModel.title)
                    broadcastModel1.setDescription(broadcastModel.category?.descr)
                    broadcastModel1.setCategoryName(broadcastModel.category?.title ??  broadcastModel.title)
                    broadcastModel1.setChannelId(broadcastModel.category?.channel ?? "1")
                    broadcastModel1.setHosts(broadcastModel.category?.hosts ?? [String]())

                    let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_BROADCAST, bundle: nil)
                        .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_BROADCAST) as! BroadcastViewController)

                    viewController.broadcastModel = broadcastModel1

                    navigationController?.pushViewController(viewController, animated: true)
                }

            }
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
    }

    //MARK: - SettingsOwnToDelegate
    func clearHistoryToClick() {
        // clear history of search
        if isShowHistory == true {
            dataset.removeAll()
            historyItems.removeAll()
            do {
                let dataHistory = try JSONEncoder().encode(dataset)
                if let r1 = saveJsonFromData(data: dataHistory, name: historyFileName) as? Bool,
                   r1 == true {
                    print("added item to history search")
                }
            } catch {
                print("Error saving JSON: \(error)")
            }
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
    }

}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

// MARK: - UICollectionViewDataSource
extension BroadcastsBySearchCompactCollectionViewController {
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let c = dataset?.count {
            print("founded = \(c)")
            return c
        } else {
            return 0
        }
        //return dataset.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        print("\(indexPath.row) \(isShowHistory)")
        if isShowHistory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! HistoryCompactCollectionViewCell
            // Configure the cell

            // variables
            let broadcastModel = dataset[indexPath.row]

            // listeners
            cell.buttonChannel.tag = indexPath.row
            cell.buttonChannel.addTarget(self, action: #selector(buttonSearchClickHandler), for: .touchUpInside)
            cell.buttonBroadcast.tag = indexPath.row
            cell.buttonBroadcast.addTarget(self, action: #selector(buttonSearchBroadcastClickHandler), for: .touchUpInside)


            // listeners
            cell.buttonDeleteFromHistory.tag = indexPath.row
            cell.buttonDeleteFromHistory.addTarget(self, action: #selector(buttonDeleteFromHistoryClickHandler), for: .touchUpInside)

            // update image
            if ((broadcastModel.document?.image != nil) && ((broadcastModel.document?.image?.count ?? 0) > 0)) {
                cell.imageGenericPreview.sd_setImage(with: URL(string: broadcastModel.document?.image ?? ""))
            } else {
                cell.imageGenericPreview.image = UIImage(named: "logo_latvijas_radio_radioteatris")
            }

            // update title
            let title = broadcastModel.document?.showName //broadcastModel.category?.title //.show_name
            cell.textGenericPreview.setText(title)
            cell.descrGenericPreview.setText(broadcastModel.document?.description)
            let customFont = UIFont.systemFont(ofSize: 17.0)
            cell.textGenericPreview.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: 17.0))
            if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {

                cell.textGenericPreview.font = UIFont(descriptor: artistDescriptor,
                                              size: 17.0)
                }
            cell.textGenericPreview.adjustsFontForContentSizeCategory = true
            let customFont1 = UIFont.systemFont(ofSize: 17.0)
            cell.descrGenericPreview.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: customFont1 ?? UIFont.systemFont(ofSize: 17.0))
            cell.descrGenericPreview.adjustsFontForContentSizeCategory = true
    //        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(named: "lr-black-50") : UIColor(named: "lr-white") // .blue : .white // lr-black-50
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! SearchCompactCollectionViewCell
            // Configure the cell

            // variables
            let broadcastModel = dataset[indexPath.row]
            // listeners
            cell.buttonChannel.tag = indexPath.row
            cell.buttonChannel.addTarget(self, action: #selector(buttonSearchClickHandler), for: .touchUpInside)
            cell.buttonBroadcast.tag = indexPath.row
            cell.buttonBroadcast.addTarget(self, action: #selector(buttonSearchBroadcastClickHandler), for: .touchUpInside)

            // listeners
            cell.buttonChannel.tag = indexPath.row
            cell.buttonChannel.addTarget(self, action: #selector(buttonSearchClickHandler), for: .touchUpInside)

            // update image
            if ((broadcastModel.document?.image != nil) && ((broadcastModel.document?.image?.count ?? 0) > 0)) {
                cell.imageGenericPreview.sd_setImage(with: URL(string: broadcastModel.document?.image ?? ""))
            } else {
                cell.imageGenericPreview.image = UIImage(named: "logo_latvijas_radio_radioteatris")
            }

            // update title
            let title = broadcastModel.document?.episodeTitle //broadcastModel.category?.title //.show_name
            cell.textGenericPreview.setText(title)
            cell.descrGenericPreview.setText(broadcastModel.document?.description)
            let customFont = UIFont.systemFont(ofSize: 17.0)
            cell.textGenericPreview.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: 17.0))
            if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {

                cell.textGenericPreview.font = UIFont(descriptor: artistDescriptor,
                                              size: 17.0)
                }
            cell.textGenericPreview.adjustsFontForContentSizeCategory = true
            let customFont1 = UIFont.systemFont(ofSize: 17.0)
            cell.descrGenericPreview.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: customFont1 ?? UIFont.systemFont(ofSize: 17.0))
            cell.descrGenericPreview.adjustsFontForContentSizeCategory = true
    //        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(named: "lr-black-50") : UIColor(named: "lr-white") // .blue : .white // lr-black-50
            return cell
        }

    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            CollectionViewCellHelper.setHighlightedStyle(cell)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            CollectionViewCellHelper.setUnhighlightedStyle(cell)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let broadcastModel = dataset[indexPath.row]
//        let broadcastModel1 = BroadcastModel("\(String(describing: broadcastModel.category?.id))")
//        broadcastModel1.setImageUrl(broadcastModel.category?.imageURL ?? "")
//        broadcastModel1.setTitle(broadcastModel.category?.title ?? broadcastModel.title)
//        broadcastModel1.setDescription(broadcastModel.category?.descr)
//        broadcastModel1.setCategoryName(broadcastModel.category?.title ??  broadcastModel.title)
//        broadcastModel1.setChannelId(broadcastModel.category?.channel ?? "1")
        var ident = ""
        if let ident1 = broadcastModel.document?.id as? Int {
            ident = "\(ident1)"
        }
        let broadcastModel1 = BroadcastModel(ident)
        broadcastModel1.setImageUrl(broadcastModel.document?.image ?? "")
        broadcastModel1.setTitle(broadcastModel.document?.episodeTitle ?? "")
        broadcastModel1.setDescription(broadcastModel.document?.description)
        broadcastModel1.setCategoryName(broadcastModel.document?.showName ??  "")
        broadcastModel1.setChannelId(String(describing:  broadcastModel.document?.channel) ?? "1")
//        broadcastModel1.setHosts(broadcastModel.category?.hosts)
//        let broadcastModel2 = EpisodeModel("\(String(describing: broadcastModel.id))")
//        broadcastModel2.setImageUrl(broadcastModel.imageURL ?? "")
//        broadcastModel2.setTitle(broadcastModel.title)
//        broadcastModel2.setDescription(broadcastModel.category?.descr)
//        broadcastModel2.setCategoryName(broadcastModel.category?.title ??  broadcastModel.title)
//        broadcastModel2.setChannelId(broadcastModel.category?.channel ?? "1")
//        broadcastModel2.setDateInMillis(broadcastModel.dateInMillis)
//        broadcastModel2.setBroadcastName(broadcastModel.category?.title ?? "")
//        broadcastModel2.setBroadcastEmail(broadcastModel.category?.email ?? "")
//        broadcastModel2.setMediaDurationInSeconds(broadcastModel.mediaDurationInSeconds)
//        broadcastModel2.setMediaStreamUrl(broadcastModel.mediaStreamUrl)
//        broadcastModel2.setLsmTags(broadcastModel.lsmTags ?? [String]())
//        broadcastModel2.setNewsBlocks(broadcastModel.newsBlocks ?? [String]())

        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_EPISODE, bundle: nil)
                                .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_EPISODE) as! EpisodeViewController)

//        viewController.episodeModel = broadcastModel2

        navigationController?.pushViewController(viewController, animated: true)


//        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_BROADCAST, bundle: nil)
//                                .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_BROADCAST) as! BroadcastViewController)
//
//        viewController.broadcastModel = broadcastModel1
//
//        navigationController?.pushViewController(viewController, animated: true)


//        let viewController = (UIStoryboard(name: StoryboardsHelper.STORYBOARD_ID_SEARCHITEM, bundle: nil)
//                                .instantiateViewController(withIdentifier: StoryboardsHelper.STORYBOARD_VIEW_CONTROLLER_ID_SEARCHITEM) as! HitViewController)

//        viewController.broadcastModel = broadcastModel
//        viewController.channelModel = channelModel
//        viewController.searchItemModel = broadcastModel

//        navigationController?.pushViewController(viewController, animated: true)
    }


    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("suppl indexPath = \(indexPath)  dataset.count = \(String(describing: dataset?.count))")
////        if isShowHistory {
            if (kind == UICollectionView.elementKindSectionFooter) {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer1", for: indexPath) as! Footer1CollectionReusableView
                footerView.button1.setTitle("remove_all_history".localized(), for: .normal)
                footerView.delegateClearHistorySearch = self
                            // Configure footer if needed
                                          // Customize footerView here
                //            footerView.b
//                let button = UIButton(type: .system)
//                        button.setTitle("Dzēst visu vēsturi", for: .normal)
//                button.frame = CGRect(x: 16, y: 16, width: footerView.frame.width - 32, height: 44)
//                        button.layer.cornerRadius = 16
//                        button.layer.borderWidth = 1
//                        button.layer.borderColor = UIColor.gray.cgColor
//                        button.titleLabel?.font = .systemFont(ofSize: 14)
//
//                footerView.addSubview(button)
                print("suppl footer = \(footerView)")
                return footerView
            } else if (kind == UICollectionView.elementKindSectionHeader) {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header1", for: indexPath) as! Header1CollectionReusableView
                headerView.label1.text = "history_search".localized()
//                // Customize headerView here
////                let label = UILabel()
////                label.text = "history_search".localized()
////
////                let customFont = UIFont.systemFont(ofSize: 17.0)
////                label.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: 17.0))
////                if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {
////
////                    label.font = UIFont(descriptor: artistDescriptor,
////                                        size: 17.0)
////                }
////                label.adjustsFontForContentSizeCategory = true
//
//                //                    label.font = UIFont.preferredFont(forTextStyle: .headline)  // Equivalent to .font(.headline)
//                //            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//                //label.font.withWeight(.bold)  // Equivalent to .fontWeight(.bold)
////                label.alpha = 0.9  // Equivalent to .opacity(0.9)
////                label.translatesAutoresizingMaskIntoConstraints = false
////
////                // Add label to the view
////                headerView.addSubview(label)
////
////                // Set up the constraints
////                NSLayoutConstraint.activate([
////                    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
////                    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
////                    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
////                    label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
////                ])
//                //            headerView.largeContentTitle = "history_search".localized()
//                //"remove_all_history"
                print("suppl header = \(headerView)")
                return headerView
            }
////        } else {
            return UIView(frame: CGRect.zero) as! UICollectionReusableView
////        }
        return UICollectionReusableView()
    }

    // MARK: UICollectionViewDelegate

    // DelegateFlowLayout methods for header/footer sizes
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            print("section = \(section) header suppl dataset.count = \(String(describing: dataset?.count))")
//            if isShowHistory {
                return CGSize(width: collectionView.frame.width, height: 60) // Height for header
//            } else {
//                return CGSize(width: collectionView.frame.width, height: 0)
//            }
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("section = \(section) footer suppl dataset.count = \(String(describing: dataset?.count))")
//        if isShowHistory {
            return CGSize(width: collectionView.frame.width, height: 60) // Height for footer
//        } else {
//            return CGSize(width: collectionView.frame.width, height: 0)
//        }
    }


    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }



    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }



    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }


}

// MARK: - Collection View Flow Layout Delegate

private let sectionInsets = UIEdgeInsets(
    top: 16.0,
    left: 16.0,
    bottom: 16.0,
    right: 16.0
)
//let spacingBetweenCells: CGFloat = 0

extension BroadcastsBySearchCompactCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
}


