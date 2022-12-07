//  CustomAnnotationView.swift
//  Project 2 Foundation
//
//  Created by Stephen Liddle on 12/3/22.
//

import UIKit
import MapKit

//
// This is a UIKit thing, well outside the scope of what I've taught you
// in IS 543 Fall 2022.  The main logic is we need to implement two
// initializers, and they both call a configureUI() method to build
// the pin image view.  Then when the view is prepared for display
// we'll add a placename label (actually, a set of labels so we get a
// nice black outline around the white text).
class CustomAnnotationView: MKAnnotationView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // This init? is intended to restore state when relaunching an
        // app.  We'll ignore the NSCoder and just build a new view.
        configureUI(annotation: nil)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        // Let configureUI() do all the work so we can call it from two spots.
        configureUI(annotation: annotation)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Prepare for reuse means tear down the previous configuration if needed.
        // In this case, remove any existing labels.
        subviews
            .filter { $0 is UILabel }
            .forEach { $0.removeFromSuperview() }
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        // Prepare for display means set up the labels we need to display the placename.
        // We have access to title and subtitle on the annotation.  Here we're only
        // using title.
        if let titleString = annotation?.title, let title = titleString {
            labelsForOutlinedText(title, xPosition: imageView().intrinsicContentSize.width)
                .forEach { self.addSubview($0) }
        }
    }

    private func configureUI(annotation: MKAnnotation?) {
        // Every CustomAnnotationView always has an image of a pin that never changes.
        // So we unconditionally create this UIImageView and add it as a subview.
        // The subviews array will tell us what children views we have.
        if let uiImage = UIImage(systemName: Drawing.pinImageName)?.withRenderingMode(.alwaysTemplate) {
            // Configure a UIImageView by creating it, setting its color, setting its frame,
            // and adding it to us as a child view (subview).
            let imageView = UIImageView(image: uiImage)

            let pinWidth = uiImage.size.width * Drawing.scaleFactor
            let pinHeight = uiImage.size.height * Drawing.scaleFactor

            imageView.tintColor = Drawing.pinColor
            imageView.frame = CGRect(x: 0, y: -pinHeight / 2, width: pinWidth, height: pinHeight)

            addSubview(imageView)
        }

        // The CustomAnnotationView will use the same frame (position/size) as
        // the pin image subview.
        frame = imageView().frame
    }

    // Helper to find the image view in our list of subviews.
    private func imageView() -> UIImageView {
        if let imageView = subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            return imageView
        }

        return UIImageView()
    }

    // As we iterate over x/y offsets, determine when we're on the main text,
    // which will have a shadow.
    private func isMainText(_ xOffset: Double, _ yOffset: Double) -> Bool {
        xOffset > 0 && yOffset > 0
    }

    // In order to create a black border around the white text of a placename,
    // we create four labels.  Each has white text and a black border, and we
    // just change the shadow offset for each.  This is the most effective
    // way I've found to create a black outline around white text.  There are
    // NSAttributedStrings that you can both stroke and fill, but the outline
    // ends up taking interior space, not exterior space around the letters,
    // so it looks bad.  C'est la vie.  This is a little clunky but it works.
    private func labelsForOutlinedText(_ text: String, xPosition x: Double) -> [UILabel] {
        var labels = [UILabel]()

        for xOffset in [-1.0, 1.0] {
            for yOffset in [-1.0, 1.0] {
                let label = UILabel()

                label.text = text
                label.font = Drawing.font
                label.textColor = Drawing.textColor
                label.shadowColor = Drawing.shadowColor
                label.shadowOffset = CGSize(width: xOffset, height: yOffset)
                label.frame = CGRect(x: x,
                                     y: label.intrinsicContentSize.height / 4,
                                     width: label.intrinsicContentSize.width,
                                     height: label.intrinsicContentSize.height)

                labels.append(label)
            }
        }

        return labels
    }

    private struct Drawing {
        static let font = UIFont.boldSystemFont(ofSize: 18.0)
        static let pinColor = UIColor.systemRed
        static let pinImageName = "mappin"
        static let scaleFactor = 1.7
        static let shadowColor = UIColor.black
        static let textColor = UIColor.white
    }
}

