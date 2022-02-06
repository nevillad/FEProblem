//
//  ListOptionsTableViewCell.swift
//  AxisOne
//
//  Created by Vijay Bahadur Yadav on 06/06/21.
//

import UIKit

let kListOptionsTableViewCell_ID = "ListOptionsTableViewCell"
class ListOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ivRight: UIImageView!
    @IBOutlet weak var ivLeft: UIImageView!


    fileprivate let selectedColor = UIColor.red.cgColor// Color.secondaryPink100.value
    fileprivate let defaultColor = UIColor.gray.cgColor// Color.secondaryGrey50.value

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.isSelected = false
        setStyles()
    }

    func setStyles() {
        containerView.addShadow()

        ivRight.image = UIImage(named: "rounded-uncheck")
        ivRight.tintColor = primaryColor

        ivLeft.layer.cornerRadius = 5.0
        // border
        ivLeft.layer.borderColor = UIColor.lightGray.cgColor
        ivLeft.layer.borderWidth = 0.5

        // drop shadow
        ivLeft.layer.shadowColor = UIColor.black.cgColor
        ivLeft.layer.shadowOpacity = 0.8
        ivLeft.layer.shadowRadius = 3.0
        ivLeft.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }

    func toggleCellStyle(isSelected: Bool) {
        if isSelected {
            ivRight.image = UIImage(named: "rounded-check")
        } else {
            containerView.layer.borderColor = defaultColor //.cgColor
            ivRight.image = UIImage(named: "rounded-uncheck")
        }
    }

}
