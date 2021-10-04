//
// Autogenerated by Natalie - Storyboard Generator
// by Marcin Krzyzanowski http://krzyzanowskim.com
//
import UIKit

// MARK: - Storyboards

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
        let instance = type.init()
        if let identifier = instance.storyboardIdentifier {
            return self.instantiateViewController(withIdentifier: identifier) as? T
        }
        return nil
    }

}

protocol Storyboard {
    static var storyboard: UIStoryboard { get }
    static var identifier: String { get }
}

struct Storyboards {

    struct LaunchScreen: Storyboard {

        static let identifier = "LaunchScreen"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> UIViewController {
            return self.storyboard.instantiateInitialViewController()!
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }
    }

    struct Chat: Storyboard {

        static let identifier = "Chat"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> UINavigationController {
            return self.storyboard.instantiateInitialViewController() as! UINavigationController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }
    }

    struct AuthReg: Storyboard {

        static let identifier = "AuthReg"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> SigninController {
            return self.storyboard.instantiateInitialViewController() as! SigninController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }

        static func instantiateSigninController() -> SigninController {
            return self.storyboard.instantiateViewController(withIdentifier: "SigninController") as! SigninController
        }

        static func instantiateResetPasswordController() -> ResetPasswordController {
            return self.storyboard.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
        }

        static func instantiateCreateNewPasswordController() -> CreateNewPasswordController {
            return self.storyboard.instantiateViewController(withIdentifier: "CreateNewPasswordController") as! CreateNewPasswordController
        }

    }

    struct Favourites: Storyboard {

        static let identifier = "Favourites"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> UINavigationController {
            return self.storyboard.instantiateInitialViewController() as! UINavigationController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }
    }

    struct Search: Storyboard {

        static let identifier = "Search"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> UINavigationController {
            return self.storyboard.instantiateInitialViewController() as! UINavigationController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }

        static func instantiateSearch() -> UINavigationController {
            return self.storyboard.instantiateViewController(withIdentifier: "Search") as! UINavigationController
        }

        static func instantiateMapController() -> MapController {
            return self.storyboard.instantiateViewController(withIdentifier: "MapController") as! MapController
        }

        static func instantiatePhotoPreviewController() -> PhotoPreviewController {
            return self.storyboard.instantiateViewController(withIdentifier: "PhotoPreviewController") as! PhotoPreviewController
        }

        static func instantiateFilterController() -> FilterController {
            return self.storyboard.instantiateViewController(withIdentifier: "FilterController") as! FilterController
        }
    }

    struct ProfileBig: Storyboard {

        static let identifier = "ProfileBig"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> UINavigationController {
            return self.storyboard.instantiateInitialViewController() as! UINavigationController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }

        static func instantiateSubscriptionsController() -> SubscriptionsController {
            return self.storyboard.instantiateViewController(withIdentifier: "SubscriptionsController") as! SubscriptionsController
        }
    }

    struct Selection: Storyboard {

        static let identifier = "Selection"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> SelectionController {
            return self.storyboard.instantiateInitialViewController() as! SelectionController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }

        static func instantiateSelection() -> SelectionController {
            return self.storyboard.instantiateViewController(withIdentifier: "Selection") as! SelectionController
        }
    }

    struct Start: Storyboard {

        static let identifier = "Start"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> StartController {
            return self.storyboard.instantiateInitialViewController() as! StartController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }

        static func instantiateStartController() -> StartController {
            return self.storyboard.instantiateViewController(withIdentifier: "StartController") as! StartController
        }
    }

    struct Main: Storyboard {

        static let identifier = "Main"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> MainTabbarController {
            return self.storyboard.instantiateInitialViewController() as! MainTabbarController
        }

        static func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewController(withIdentifier: identifier)
        }

        static func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? where T: IdentifiableProtocol {
            return self.storyboard.instantiateViewController(ofType: type)
        }

        static func instantiateMain() -> MainTabbarController {
            return self.storyboard.instantiateViewController(withIdentifier: "Main") as! MainTabbarController
        }
    }
}

// MARK: - ReusableKind
enum ReusableKind: String, CustomStringConvertible {
    case tableViewCell = "tableViewCell"
    case collectionViewCell = "collectionViewCell"

    var description: String { return self.rawValue }
}

// MARK: - SegueKind
enum SegueKind: String, CustomStringConvertible {
    case relationship = "relationship"
    case show = "show"
    case presentation = "presentation"
    case embed = "embed"
    case unwind = "unwind"
    case push = "push"
    case modal = "modal"
    case popover = "popover"
    case replace = "replace"
    case custom = "custom"

    var description: String { return self.rawValue }
}

// MARK: - IdentifiableProtocol

public protocol IdentifiableProtocol: Equatable {
    var storyboardIdentifier: String? { get }
}

// MARK: - SegueProtocol

public protocol SegueProtocol {
    var identifier: String? { get }
}

public func ==<T: SegueProtocol, U: SegueProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.identifier == rhs.identifier
}

public func ~=<T: SegueProtocol, U: SegueProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.identifier == rhs.identifier
}

public func ==<T: SegueProtocol>(lhs: T, rhs: String) -> Bool {
    return lhs.identifier == rhs
}

public func ~=<T: SegueProtocol>(lhs: T, rhs: String) -> Bool {
    return lhs.identifier == rhs
}

public func ==<T: SegueProtocol>(lhs: String, rhs: T) -> Bool {
    return lhs == rhs.identifier
}

public func ~=<T: SegueProtocol>(lhs: String, rhs: T) -> Bool {
    return lhs == rhs.identifier
}

// MARK: - ReusableViewProtocol
public protocol ReusableViewProtocol: IdentifiableProtocol {
    var viewType: UIView.Type? { get }
}

public func ==<T: ReusableViewProtocol, U: ReusableViewProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.storyboardIdentifier == rhs.storyboardIdentifier
}

// MARK: - Protocol Implementation
extension UIStoryboardSegue: SegueProtocol {
}

extension UICollectionReusableView: ReusableViewProtocol {
    public var viewType: UIView.Type? { return type(of: self) }
    public var storyboardIdentifier: String? { return self.reuseIdentifier }
}

extension UITableViewCell: ReusableViewProtocol {
    public var viewType: UIView.Type? { return type(of: self) }
    public var storyboardIdentifier: String? { return self.reuseIdentifier }
}

// MARK: - UIViewController extension
extension UIViewController {
    func perform<T: SegueProtocol>(segue: T, sender: Any?) {
        if let identifier = segue.identifier {
            performSegue(withIdentifier: identifier, sender: sender)
        }
    }

    func perform<T: SegueProtocol>(segue: T) {
        perform(segue: segue, sender: nil)
    }
}
// MARK: - UICollectionView

extension UICollectionView {

    func dequeue<T: ReusableViewProtocol>(reusable: T, for: IndexPath) -> UICollectionViewCell? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableCell(withReuseIdentifier: identifier, for: `for`)
        }
        return nil
    }

    func register<T: ReusableViewProtocol>(reusable: T) {
        if let type = reusable.viewType, let identifier = reusable.storyboardIdentifier {
            register(type, forCellWithReuseIdentifier: identifier)
        }
    }

    func dequeueReusableSupplementaryViewOfKind<T: ReusableViewProtocol>(elementKind: String, withReusable reusable: T, for: IndexPath) -> UICollectionReusableView? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: `for`)
        }
        return nil
    }

    func register<T: ReusableViewProtocol>(reusable: T, forSupplementaryViewOfKind elementKind: String) {
        if let type = reusable.viewType, let identifier = reusable.storyboardIdentifier {
            register(type, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        }
    }
}
// MARK: - UITableView

extension UITableView {

    func dequeue<T: ReusableViewProtocol>(reusable: T, for: IndexPath) -> UITableViewCell? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableCell(withIdentifier: identifier, for: `for`)
        }
        return nil
    }

    func register<T: ReusableViewProtocol>(reusable: T) {
        if let type = reusable.viewType, let identifier = reusable.storyboardIdentifier {
            register(type, forCellReuseIdentifier: identifier)
        }
    }

    func dequeueReusableHeaderFooter<T: ReusableViewProtocol>(_ reusable: T) -> UITableViewHeaderFooterView? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableHeaderFooterView(withIdentifier: identifier)
        }
        return nil
    }

    func registerReusableHeaderFooter<T: ReusableViewProtocol>(_ reusable: T) {
        if let type = reusable.viewType, let identifier = reusable.storyboardIdentifier {
             register(type, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
}

// MARK: - ChatController

// MARK: - SigninController
protocol SigninControllerIdentifiableProtocol: IdentifiableProtocol { }

extension SigninController: SigninControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: SigninController {
    var storyboardIdentifier: String? { return "SigninController" }
    static var storyboardIdentifier: String? { return "SigninController" }
}

// MARK: - ResetPasswordController
protocol ResetPasswordControllerIdentifiableProtocol: IdentifiableProtocol { }

extension ResetPasswordController: ResetPasswordControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: ResetPasswordController {
    var storyboardIdentifier: String? { return "ResetPasswordController" }
    static var storyboardIdentifier: String? { return "ResetPasswordController" }
}

// MARK: - CreateNewPasswordController
protocol CreateNewPasswordControllerIdentifiableProtocol: IdentifiableProtocol { }

extension CreateNewPasswordController: CreateNewPasswordControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: CreateNewPasswordController {
    var storyboardIdentifier: String? { return "CreateNewPasswordController" }
    static var storyboardIdentifier: String? { return "CreateNewPasswordController" }
}

// MARK: - FavouritesController
extension FavouritesController {

    enum Reusable: String, CustomStringConvertible, ReusableViewProtocol {
        case FavouritesCell_ = "FavouritesCell"

        var kind: ReusableKind? {
            switch self {
            case .FavouritesCell_:
                return ReusableKind(rawValue: "tableViewCell")
            }
        }

        var viewType: UIView.Type? {
            switch self {
            case .FavouritesCell_:
                return FavouritesCell.self
            }
        }

        var storyboardIdentifier: String? { return self.description }
        var description: String { return self.rawValue }
    }

}

// MARK: - MapController
protocol MapControllerIdentifiableProtocol: IdentifiableProtocol { }

extension MapController: MapControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: MapController {
    var storyboardIdentifier: String? { return "MapController" }
    static var storyboardIdentifier: String? { return "MapController" }
}

// MARK: - PhotoPreviewController
protocol PhotoPreviewControllerIdentifiableProtocol: IdentifiableProtocol { }

extension PhotoPreviewController: PhotoPreviewControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: PhotoPreviewController {
    var storyboardIdentifier: String? { return "PhotoPreviewController" }
    static var storyboardIdentifier: String? { return "PhotoPreviewController" }
}

// MARK: - FilterController
protocol FilterControllerIdentifiableProtocol: IdentifiableProtocol { }

extension FilterController: FilterControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: FilterController {
    var storyboardIdentifier: String? { return "FilterController" }
    static var storyboardIdentifier: String? { return "FilterController" }
}

// MARK: - SubscriptionsController
protocol SubscriptionsControllerIdentifiableProtocol: IdentifiableProtocol { }

extension SubscriptionsController: SubscriptionsControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: SubscriptionsController {
    var storyboardIdentifier: String? { return "SubscriptionsController" }
    static var storyboardIdentifier: String? { return "SubscriptionsController" }
}

// MARK: - SelectionController
protocol SelectionControllerIdentifiableProtocol: IdentifiableProtocol { }

extension SelectionController: SelectionControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: SelectionController {
    var storyboardIdentifier: String? { return "Selection" }
    static var storyboardIdentifier: String? { return "Selection" }
}

// MARK: - StartController
protocol StartControllerIdentifiableProtocol: IdentifiableProtocol { }

extension StartController: StartControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: StartController {
    var storyboardIdentifier: String? { return "StartController" }
    static var storyboardIdentifier: String? { return "StartController" }
}

// MARK: - MainTabbarController
protocol MainTabbarControllerIdentifiableProtocol: IdentifiableProtocol { }

extension MainTabbarController: MainTabbarControllerIdentifiableProtocol { }

extension IdentifiableProtocol where Self: MainTabbarController {
    var storyboardIdentifier: String? { return "Main" }
    static var storyboardIdentifier: String? { return "Main" }
}
