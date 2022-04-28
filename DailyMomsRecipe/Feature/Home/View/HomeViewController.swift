//
//  HomeViewController.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 14/04/22.
//

import UIKit
import Combine


class HomeViewController: UIViewController {
    
    @IBOutlet weak var customSegmentedView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    var buttonBar : UIView = UIView()
    static let sectionHeaderElementKind = "section-header-element-kind"
    private var sections :[List] = []
    private lazy var dataSource = makeDataSource()
    private var cancellable: AnyCancellable?
    typealias DataSource = UICollectionViewDiffableDataSource<List, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<List, Item>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImgView.image = UIImage(named: "dining")
        customSegmentedControl()
        configureCollectionView()
        loadResource()
        // Do any additional setup after loading the view.
    }
    
    
    
    func configureCollectionView(){
        menuCollectionView.delegate = self
        menuCollectionView.register(PopularItemCell.self, forCellWithReuseIdentifier: PopularItemCell.reuseIdentifer)
        menuCollectionView.register(ContentItemCell.self, forCellWithReuseIdentifier: ContentItemCell.reuseIdentifer)
        menuCollectionView.register(
          SectionHeaderReusableView.self,
          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        menuCollectionView.collectionViewLayout = generateLayout()
    }
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionLayoutKind = self.sections[sectionIndex]
            if sectionLayoutKind.categoryID == "popular" {
                return self.generateFeaturedAlbumsLayout()
            }else{
                return self.generateSharedlbumsLayout()
            }
        }
      return layout
    }

    func generateFeaturedAlbumsLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 8.0)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(150),
                                               heightDimension: .absolute(200)),
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)

        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        headerView.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerView]

        section.contentInsets = NSDirectionalEdgeInsets(top: 16.0,
                                                        leading: 0.0,
                                                        bottom: 16.0,
                                                        trailing: 0.0)

        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        return section
    }

    func generateSharedlbumsLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .fractionalHeight(0.9))) // This height does not have any effect. Bug?
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: NSCollectionLayoutSpacing.flexible(0.0),
            top: NSCollectionLayoutSpacing.flexible(0.0),
            trailing: NSCollectionLayoutSpacing.flexible(0.0),
            bottom: NSCollectionLayoutSpacing.flexible(0.0))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(200),
                                               heightDimension: .absolute(200)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)

        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        headerView.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerView]

        section.interGroupSpacing = 20
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16.0,
                                                        leading: 16.0,
                                                        bottom: 16.0,
                                                        trailing: 0.0)
        return section
    }

    
    func makeDataSource() -> DataSource{
        let dataSource = DataSource(
            collectionView: menuCollectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                // 2
                let sectionLayoutKind = self.sections[indexPath.section]
                if sectionLayoutKind.categoryID == "popular" {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PopularItemCell.reuseIdentifer,
                        for: indexPath) as? PopularItemCell
                    cell?.featuredPhotoURL = URL(string: item.imageURL)
                    cell?.title = item.name
                    return cell
                }else{
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ContentItemCell.reuseIdentifer,
                        for: indexPath) as? ContentItemCell
                    cell?.title = item.name
                    cell?.featuredPhotoURL = URL(string: item.imageURL)
                    
                    return cell
                }
                
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
            view?.titleLabel.text = Category.getSingleCategory(id: section.categoryID)?.name ?? ""
            return view
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func loadResource() {
        let queue = DispatchQueue.main
        let networkService = BaseService()
        cancellable = networkService.home()
            .receive(on: queue)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let errorMessage = "\(error.localizedDescription)"
                    print(errorMessage)
                case .finished:
                    self.applySnapshot(animatingDifferences: false)
                }
                
            }, receiveValue: { data in
                do {
                    let decoder = JSONDecoder()
                    if let menus = try? decoder.decode(RestoData.self, from: data) as RestoData {
                        
                        menus.list.forEach{ item in
                            self.sections.append(item)
                        }
                        } else {
                            print("ERROR: Can't Decode JSON")
                        }
                }
            })
    }
}

extension HomeViewController :UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        print("\(item.name)")
       
    }
}

extension HomeViewController{
    private func customSegmentedControl(){
        let segmentedControl = UISegmentedControl()
        customSegmentedView.backgroundColor = .clear
        customSegmentedView.translatesAutoresizingMaskIntoConstraints = false
        // Add segments
        segmentedControl.insertSegment(withTitle: "One", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Two", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Three", at: 2, animated: true)
        // First segment is selected by default
        segmentedControl.selectedSegmentIndex = 0
        // This needs to be false since we are using auto layout constraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        // This needs to be false since we are using auto layout constraints
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.blue
        customSegmentedView.addSubview(segmentedControl)
        customSegmentedView.addSubview(buttonBar)
        // Constrain the segmented control width to be equal to the container view width
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        // Constraining the height of the segmented control to an arbitrarily chosen value
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        if #available(iOS 13.0, *) {
            let image = UIImage()
            let size = CGSize(width: 1, height: segmentedControl.intrinsicContentSize.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            segmentedControl.setBackgroundImage(scaledImage, for: .normal, barMetrics: .default)
            segmentedControl.setDividerImage(scaledImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        }
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 0.98 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.1) {
            self.buttonBar.frame.origin.x = (sender.frame.width / CGFloat(sender.numberOfSegments)) * CGFloat(sender.selectedSegmentIndex)
        }
    }
}
