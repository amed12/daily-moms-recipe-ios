//
//  ContentItemCell.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 19/04/22.
//

import UIKit

class ContentItemCell: UICollectionViewCell {
  static let reuseIdentifer = "popular-item-cell-reuse-identifier"
  let titleLabel = UILabel()
  let contentContainer = UIView()

  var title: String? {
    didSet {
      configure()
    }
  }

  var featuredPhotoURL: URL? {
    didSet {
      configure()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ContentItemCell {
  func configure() {
    backgroundColor = .orange
    contentContainer.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(contentContainer)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.adjustsFontForContentSizeCategory = true
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.layer.shadowColor = UIColor.black.cgColor
    titleLabel.layer.shadowRadius = 3.0
    titleLabel.layer.shadowOpacity = 1.0
    titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
    titleLabel.layer.masksToBounds = false
    contentContainer.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}
