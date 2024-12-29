//
//  DynamicBlockPresentationType3ViewController.swift
//  Latvijas Radio
//
//  Created by Sandis Putnis on 13/12/2021.
//

import UIKit

class DynamicBlockPresentationType3ViewController: UIViewController {
    
    static var TAG = String(describing: DynamicBlockPresentationType3ViewController.classForCoder())
    
    @IBOutlet weak var textTitle: UILabelH4!
    @IBOutlet weak var containerGenericPreviewsCollection: UIView!
    @IBOutlet weak var containerEpisodesPreviewsCollection: UIView!
    
    weak var genericPreviewsCollectionViewController: GenericPreviewsCollectionViewController!
    weak var episodesPreviewsCollectionViewController: EpisodesPreviewsCollectionViewController!

    var dynamicBlockModel: DynamicBlockModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GeneralUtils.log(DynamicBlockPresentationType3ViewController.TAG, "viewDidLoad")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if (dynamicBlockModel != nil) {
            loadDynamicBlock(dynamicBlockModel)
        }
        let customFont = UIFont(name: "FuturaPT-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        textTitle.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
//        if let par = self.parent?.parent?.isKind(of: DashboardViewController.self) as? Bool,
//           par == true {
//            if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {
//
//                textTitle.font = UIFont(descriptor: artistDescriptor,
//                                        size: 16.0)
//            }
//        }
//        if let artistDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {
//
//            textTitle.font = UIFont(descriptor: artistDescriptor,
//                                size: 16.0)
//        }
        textTitle.adjustsFontForContentSizeCategory = true
        print("self.parent?.parent = \(self.parent?.parent)")
        if let par = self.parent?.parent?.isKind(of: BroadcastsViewController.self) as? Bool,
        par == true {

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
        case StoryboardsHelper.SEGUE_EMBED_GENERIC_PREVIEWS_COLLECTION:
            self.genericPreviewsCollectionViewController = (segue.destination as! GenericPreviewsCollectionViewController)

            break
        case StoryboardsHelper.SEGUE_EMBED_EPISODES_PREVIEWS_COLLECTION:
            self.episodesPreviewsCollectionViewController = (segue.destination as! EpisodesPreviewsCollectionViewController)

            break
        default:
            break
        }
    }
    
    deinit {
        GeneralUtils.log(DynamicBlockPresentationType3ViewController.TAG, "deinit")
    }
    
    func loadDynamicBlock(_ dynamicBlockModel: DynamicBlockModel) {
        // update title
        if let title = dynamicBlockModel.getName() {
            textTitle.setText(title)
        } else {
            textTitle.setVisibility(UIView.VISIBILITY_GONE)
        }
        
        // determine whih recyclerview to populate
        let dataset = DynamicBlocksPresentationHelper.getGenericPreviewsFromDynamicBlock(dynamicBlockModel)
        
        if (dynamicBlockModel.getContentType() == ContentSectionRequest.CONTENT_TYPE_BROADCASTS) {
            containerEpisodesPreviewsCollection.setVisibility(UIView.VISIBILITY_GONE)
            
            genericPreviewsCollectionViewController.updateDataset(dataset)
        } else {
            containerGenericPreviewsCollection.setVisibility(UIView.VISIBILITY_GONE)
            
            episodesPreviewsCollectionViewController.updateDataset(dataset)
        }
    }
}

