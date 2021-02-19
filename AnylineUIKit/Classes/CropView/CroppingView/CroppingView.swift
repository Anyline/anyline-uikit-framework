//
//  CroppingView.swift
//  AnylineUIKit
//
//  Created by Mac on 21.12.2020..
//  Copyright © 2020 Anyline. All rights reserved.
//

import Foundation

class CroppingView: UIView {
    typealias CroppingViewStateChangedHandler = (Bool) -> Void
    
    // MARK: - Constants
    private struct Constants {
        static let width: CGFloat = 30
        static let padding: CGFloat = 10
        static let inset: CGFloat = 20
        static let radius: CGFloat = 50
        static let fadeAnimationDuration: TimeInterval = 0.3
        static let draggablePointsFallbackInset: CGFloat = (width + padding) / 2.0
    }
    
    enum MagnifierPosition: Int {
        case left
        case right
    }
    
    // MARK: Properties
    private var topLeftView = UIView()
    private var topRightView = UIView()
    private var bottomLeftView = UIView()
    private var bottomRightView = UIView()
    private var currentlyDraggedView: UIView?
    
    private var initialCroppingAreaChanged: Bool = false
    
    private var dragableViews: [UIView] {
        return [self.topLeftView, self.topRightView, self.bottomRightView, self.bottomLeftView]
    }
    
    private var magnifierLeadingConstraint: NSLayoutConstraint!
    private var magnifierTrailingConstraint: NSLayoutConstraint!
    
    private var magnifierPosition: MagnifierPosition = .left {
        didSet {
            // first remove the old ones
            self.removeConstraints([self.magnifierTrailingConstraint, self.magnifierLeadingConstraint])

            // now add the one we need
            switch (magnifierPosition) {
            case .left:
                self.addConstraint(self.magnifierLeadingConstraint)

            case .right:
                self.addConstraint(self.magnifierTrailingConstraint)
            }
        }
    }

    var page: ResultPage?
    var relatedImageView: UIImageView?
    var croppingViewStateChangedHandler: CroppingViewStateChangedHandler?
    
    var magnifyingGlass: MagnifyingGlass? {
        didSet {
            self.layoutMagnifyingGlass()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.setupDragableViews()
        self.positionDraggableViewsAtImageCorners()
    }

    // MARK: - API

    func updatedImageCorners() -> RectangleFeature {
        let topLeft = self.convertPoint(imageViewPoint: self.topLeftView.center, fromViewToImage:self.relatedImageView)
        let topRight = self.convertPoint(imageViewPoint: self.topRightView.center, fromViewToImage:self.relatedImageView)
        let bottomLeft = self.convertPoint(imageViewPoint: self.bottomLeftView.center, fromViewToImage:self.relatedImageView)
        let bottomRight = self.convertPoint(imageViewPoint: self.bottomRightView.center, fromViewToImage:self.relatedImageView)

        let updatedCorners: RectangleFeature = RectangleFeature(
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight
        )
        
        return updatedCorners
    }

    // MARK: - Overrides
    override func draw(_ rect: CGRect) {
        guard page != nil else { return }

        var fillColor: UIColor
        var strokeColor: UIColor
        
        if self.isCroppingAreaConvex() {
            // all good
            croppingViewStateChangedHandler?(true)
           
            fillColor = UIColor(red:0.1887, green: 0.2281, blue: 0.6502, alpha: 0.33)
            strokeColor = UIColor(red:0.1887, green: 0.2281, blue: 0.6502, alpha: 1.0)
        } else {
            // cropping area is in an invalid state
            croppingViewStateChangedHandler?(false)
            
            fillColor = UIColor(red:0.9865, green: 0.1331, blue: 0.4318, alpha: 0.33)
            strokeColor = UIColor(red:0.9865, green: 0.1331, blue: 0.4318, alpha: 1.0)
        }

        // draw canvas
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: self.topLeftView.center)
        bezierPath.addLine(to: self.topRightView.center)
        bezierPath.addLine(to: self.bottomRightView.center)
        bezierPath.addLine(to: self.bottomLeftView.center)
        bezierPath.addLine(to: self.topLeftView.center)

        fillColor.setFill()
        bezierPath.fill()
        strokeColor.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // check if any of the dragable views is touched
        //let dragableViews: [UIView] = [self.topLeftView, self.topRightView, self.bottomLeftView, self.bottomRightView]
        for view in dragableViews {
            if view.frame.insetBy(dx: -Constants.padding, dy: -Constants.padding).contains(touch.location(in: self)) {
                self.currentlyDraggedView = view

                // show magnifier
                if let magnifyingGlass = magnifyingGlass {
                    magnifyingGlass.refreshInput()
                    magnifyingGlass.show(animated: true)
                    
                    let currentPosition = touch.location(in: self)
                    if !self.convertPoint(imageViewPoint: currentPosition, fromViewToImage: self.relatedImageView).equalTo(.zero) {
                        magnifyingGlass.magnify(focusPoint: currentPosition)
                    }
                }

                return
            }
        }
        
        self.currentlyDraggedView = nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first,
            let currentlyDraggedView = currentlyDraggedView
        else { return }
        
        self.initialCroppingAreaChanged = true
        let currentPosition = touch.location(in: self)
        
        // check if position is valid
        if self.positionIsValid(position: currentPosition, forView: currentlyDraggedView)
            && !self.doesViewIntersectWithOtherDragableViews(view: currentlyDraggedView, withProposedCenter: currentPosition)
            && !self.convertPoint(imageViewPoint: currentPosition, fromViewToImage: self.relatedImageView).equalTo(.zero)
            && (currentPosition.y > 0) {
            self.currentlyDraggedView?.center = currentPosition
            self.setNeedsDisplay()

            // update magnifier
            if let magnifyingGlass = magnifyingGlass {
                magnifyingGlass.magnify(focusPoint: currentPosition)
                self.positionMagnifierToAvoidView(view: self.currentlyDraggedView)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let magnifyingGlass = magnifyingGlass {
            magnifyingGlass.dismiss(animated: true)
        }
    }

    private func layoutMagnifyingGlass() {
        guard let magnifyingGlass = magnifyingGlass else {
            return
        }

        // add magnifier to view
        self.addSubview(magnifyingGlass)

        // setup constraints, but don't attach them to the view yet
        magnifyingGlass.translatesAutoresizingMaskIntoConstraints = false
        self.magnifierLeadingConstraint = NSLayoutConstraint(item: magnifyingGlass, attribute:.leading, relatedBy:.equal, toItem:self, attribute:.leading, multiplier:1, constant:Constants.inset)
        self.magnifierTrailingConstraint = NSLayoutConstraint(item: magnifyingGlass, attribute:.trailing, relatedBy:.equal, toItem:self, attribute:.trailing, multiplier:1, constant:-Constants.inset)

        // width
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[magnifyingGlass(==magnifyingGlassWidth)]",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: ["magnifyingGlassWidth": Constants.radius * 2.0],
                views: ["magnifyingGlass" : magnifyingGlass])
        )
        
        // height
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-magnifyingGlassInset-[magnifyingGlass(==magnifyingGlassHeight)]",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: ["magnifyingGlassInset": Constants.inset, "magnifyingGlassHeight": Constants.radius * 2.0],
                views: ["magnifyingGlass" : magnifyingGlass])
        )

        // initialise it at least once
        self.magnifierPosition = .left
    }

    /**
     *  Animates magnifying glass position to avoid the currently dragged view
     */
    private func positionMagnifierToAvoidView(view: UIView!) {
        var newPosition: MagnifierPosition = .left
        let rect = CGRect(
            x: 0,
            y: 0,
            width: self.magnifyingGlass?.frame.size.width ?? 0 + Constants.inset,
            height: self.magnifyingGlass?.frame.size.height ?? 0 + Constants.inset
        )
        
        newPosition = rect.contains(view.center)
            ? .right
            : .left

        self.layoutIfNeeded()
        
        UIView.animate(
            withDuration: Constants.fadeAnimationDuration,
            delay: 0,
            options:.beginFromCurrentState,
            animations: { [weak self] in
                guard let self = self else { return }
                self.magnifierPosition = newPosition
                self.layoutIfNeeded()
            },
            completion:nil
        )
    }

    /**
     *  Checks if a draggable view colides with any of the other dragable views
     *
     *  @param view - dragable view
     *
     *  @return
     */
    private func doesViewIntersectWithOtherDragableViews(view :UIView, withProposedCenter proposedCenter: CGPoint) -> Bool {
        for otherView in self.dragableViews {
            if otherView != view && self.doesView(view1: view, intersectWithView:otherView, withProposedCenter:proposedCenter) {
                return true
            }
         }

        // if we got here it means we couldn't find anything
        return false
    }

    /**
     *  Checks if two of the dragable views colide with one another, calculated as a circular collider. The view must be square (width==height).
     *
     *  @param view1 - first view
     *  @param view2 - second view
     *
     *  @return
     */
    private func doesView(view1:UIView!, intersectWithView view2:UIView!, withProposedCenter proposedCenter:CGPoint) -> Bool {
        let r1:CGFloat = view1.frame.size.width/2.0
        let r2:CGFloat = view2.frame.size.width/2.0
        let x1:CGFloat = proposedCenter.x
        let y1:CGFloat = proposedCenter.y
        let x2:CGFloat = view2.center.x
        let y2:CGFloat = view2.center.y

        if powf(Float((r1 - r2)), 2) <= powf(Float((x1 - x2)), 2) + powf(Float((y1 - y2)), 2)
            && powf(Float((x1 - x2)), 2) + powf(Float((y1 - y2)), 2) <= powf(Float((r1 + r2)), 2) {
            return true
        } else {
            return false
        }
    }

    /**
     *  Returns the right neighbour view of the passed dragable view
     *
     *  @param view - view that need the right neighbour
     *
     *  @return
     */
    private func rightNeighbourForView(view: UIView) -> UIView {
        let viewIndex = dragableViews.firstIndex(of: view) ?? 0
        let rightNeighbourIndex = viewIndex == 0 ? dragableViews.count - 1 : viewIndex - 1
        
        return dragableViews[rightNeighbourIndex]
    }

    /**
     *  Returns the left neighbour view of the passed dragable view
     *
     *  @param view - view that need the left neighbour
     *
     *  @return
     */
    private func leftNeighbourForView(view:UIView!) -> UIView {
        let viewIndex = dragableViews.firstIndex(of: view) ?? 0
        let leftNeighbourIndex = (viewIndex + 1) % dragableViews.count
        
        return dragableViews[leftNeighbourIndex]
    }

    /**
     *  Returns the opposing neighbour view of the passed dragable view
     *
     *  @param view - view that need the opposing neighbour
     *
     *  @return
     */
    private func opposingNeighbourForView(view: UIView) -> UIView {
        let viewIndex = dragableViews.firstIndex(of: view) ?? 0
        let opposingNeighbourIndex = (viewIndex + 2) % dragableViews.count
        
        return dragableViews[opposingNeighbourIndex]
    }

    /**
     *  Checks if the proposed position for the passed view is a valid one
     *
     *  @param position - position to check for validity
     *  @param view     - view that needs the position validated
     *
     *  @return
     */
    private func positionIsValid(position: CGPoint, forView view: UIView) -> Bool {
        let leftPoint: CGPoint = self.leftNeighbourForView(view: view).center
        let rightPoint: CGPoint = self.rightNeighbourForView(view: view).center
        let oposingPoint: CGPoint = self.opposingNeighbourForView(view: view).center

        let leftEdgeVector: CGVector = CGVector(dx: leftPoint.x - oposingPoint.x, dy: leftPoint.y - oposingPoint.y)
        let rightEdgeVector: CGVector = CGVector(dx: rightPoint.x - oposingPoint.x, dy: rightPoint.y - oposingPoint.y)
        let checkEdgeVector: CGVector = CGVector(dx: position.x - oposingPoint.x, dy: position.y - oposingPoint.y)

        if self.signOfCrossProductOfVector(vector1: leftEdgeVector, withVector:rightEdgeVector) == self.signOfCrossProductOfVector(vector1: leftEdgeVector, withVector:checkEdgeVector) &&
            self.signOfCrossProductOfVector(vector1: leftEdgeVector, withVector:rightEdgeVector) * Int(-1.0) == self.signOfCrossProductOfVector(vector1: rightEdgeVector, withVector:checkEdgeVector) {
            return true
        }

        return false
    }

    /**
     *  Returns 1 if cross product is positive, -1 if it is negative, and 0 if the cross product is zero
     *
     *  @param vector1 - first vector
     *  @param vector2 - second vector
     *
     *  @return
     */
    private func signOfCrossProductOfVector(vector1: CGVector, withVector vector2: CGVector) -> Int {
        let crossProduct: CGFloat = vector1.dx * vector2.dy - vector1.dy * vector2.dx

        if crossProduct > 0 {
            return 1
        } else if crossProduct < 0 {
            return -1
        } else {
            return 0
        }
    }

    /**
     *  Checks if the cropping area/polygon is convex
     *
     *  @return
     */
    private func isCroppingAreaConvex() -> Bool {
        // set a start sign to 0
        var sign = 0

        // get all the centers
        let dragableViewCenters = dragableViews.map{ $0.center }
        var vectors: [CGVector] = []
        
        // loop through dragable view centers and get a vector between 2 points
        let centersCount = dragableViewCenters.count
        for centerIndex in 0..<centersCount {
            let currentCenter = dragableViewCenters[centerIndex]
            let nextCenter = dragableViewCenters[(centerIndex + 1) % centersCount]
            let vector = CGVector(dx: nextCenter.x - currentCenter.x, dy: nextCenter.y - currentCenter.y)
            vectors.append(vector)
        }

        // loop through vectors and compare a sign of cross product - if not equal the cropping area is not convex
        for vectorIndex in 0..<centersCount {
            let currentVector = vectors[vectorIndex]
            let nextVector = vectors[(vectorIndex + 1) % centersCount]

            let currentSign = self.signOfCrossProductOfVector(vector1: currentVector, withVector:nextVector)

            if vectorIndex == 0 {
                sign = currentSign
                continue
            }

            if currentSign != sign {
                return false
            }
         }

        return true
    }

    // MARK: image/crop view point conversion

    private func convertPoint(imageViewPoint:CGPoint, fromViewToImage imageView:UIImageView!) -> CGPoint {
        return imageView.convertPointFromView(viewPoint: imageViewPoint)
    }

    private func convertPoint(pixelPoint:CGPoint, fromImageToView imageView:UIImageView!) -> CGPoint {
        return imageView.convertPointFromImage(imagePoint: pixelPoint)
    }

    // MARK: cropping point views

    /**
     *  Creates dragable views and adds them to the superview
     */
    private func setupDragableViews() {
        // return if views already added as subview
        guard !topLeftView.isDescendant(of: self) else { return }

        // style views
        for view in [self.topRightView, self.topLeftView, self.bottomRightView, self.bottomLeftView] {
            view.frame = CGRect(x: 0, y: 0, width: Constants.width, height: Constants.width)
            view.backgroundColor = .white
            view.layer.cornerRadius = Constants.width / 2
            view.clipsToBounds = true
            self.addSubview(view)
         }
    }

    private func positionDraggableViewsAtImageCorners() {
        if self.initialCroppingAreaChanged { return }
        guard
            let imageCorners = self.page?.imageCorners,
            let image = self.relatedImageView?.image
        else { return }
        
        let corners: RectangleFeature = imageCorners
        let imageSize: CGSize = image.size


        // translate points to our view
        var topLeft:CGPoint = self.convertPoint(pixelPoint: corners.topLeft, fromImageToView:self.relatedImageView)
        var topRight:CGPoint = self.convertPoint(pixelPoint: corners.topRight, fromImageToView:self.relatedImageView)
        var bottomLeft:CGPoint = self.convertPoint(pixelPoint: corners.bottomLeft, fromImageToView:self.relatedImageView)
        var bottomRight:CGPoint = self.convertPoint(pixelPoint: corners.bottomRight, fromImageToView:self.relatedImageView)

        // if it's the corner points
        if CroppingView.isRectangleFeatureOnCorners(corners: corners, forImageSize:imageSize) {
            // then shift them in by our amount
            topLeft = CGPoint(
                x: topLeft.x + Constants.draggablePointsFallbackInset,
                y: topLeft.y + Constants.draggablePointsFallbackInset
            )
            topRight = CGPoint(
                x: topRight.x - Constants.draggablePointsFallbackInset,
                y: topRight.y + Constants.draggablePointsFallbackInset
            )
            bottomLeft = CGPoint(
                x: bottomLeft.x + Constants.draggablePointsFallbackInset,
                y: bottomLeft.y - Constants.draggablePointsFallbackInset
            )
            bottomRight = CGPoint(
                x: bottomRight.x - Constants.draggablePointsFallbackInset,
                y: bottomRight.y - Constants.draggablePointsFallbackInset
            )
        }

        // move our points in the view
        self.topLeftView.center = topLeft
        self.topRightView.center = topRight
        self.bottomLeftView.center = bottomLeft
        self.bottomRightView.center = bottomRight
    }

    private class func isRectangleFeatureOnCorners(corners: RectangleFeature, forImageSize imageSize: CGSize) -> Bool {
        return (
            corners.topLeft.equalTo(CGPoint(x: 0, y: 0))
                && corners.topRight.equalTo(CGPoint(x: imageSize.width, y: 0))
                && corners.bottomLeft.equalTo(CGPoint(x: 0, y: imageSize.height))
                && corners.bottomRight.equalTo(CGPoint(x: imageSize.width, y: imageSize.height))
        )
    }
}

