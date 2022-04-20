//
//  HomeViewController.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 14/04/22.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var customSegmentedView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    var buttonBar : UIView = UIView()
    static let sectionHeaderElementKind = "section-header-element-kind"
    private var sections = List.allList
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<List, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<List, Item>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImgView.image = UIImage(named: "dining")
        customSegmentedControl()
        configureCollectionView()
        applySnapshot(animatingDifferences: false)
        // Do any additional setup after loading the view.
    }
    
    
    
    func configureCollectionView(){
        menuCollectionView.delegate = self
        menuCollectionView.register(PopularItemCell.self, forCellWithReuseIdentifier: PopularItemCell.reuseIdentifer)
        menuCollectionView.register(
          SectionHeaderReusableView.self,
          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        menuCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
          let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(2/3))
          let itemCount = isPhone ? 1 : 3
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: itemCount)
          let section = NSCollectionLayoutSection(group: group)
          section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
          let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
          let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
          )
          section.boundarySupplementaryItems = [sectionHeader]

          return section
        })
    }
    
    func makeDataSource() -> DataSource{
        let dataSource = DataSource(
            collectionView: menuCollectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                // 2
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PopularItemCell.reuseIdentifer,
                    for: indexPath) as? PopularItemCell
                cell?.title = item.name
                cell?.featuredPhotoURL = URL(string: item.imageURL)
                
                return cell
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
