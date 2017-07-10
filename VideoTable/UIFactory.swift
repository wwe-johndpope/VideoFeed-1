import Foundation
import NVActivityIndicatorView
import AVFoundation

final class UIFactory {
    class func activityIndicator(_ size: CGFloat = 60, color: UIColor = .red) -> NVActivityIndicatorView {
        let spinner = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: size, height: size), type: .ballPulse /*BallScaleMultiple*/, color: color)
        return spinner
    }
    
    class func getPreViewImage(url:URL)->UIImage?{
        let asset = AVURLAsset(url: url)
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 0, preferredTimescale: 1)
        var actualTime = CMTime()
        do{
            let cgImg:CGImage = try gen.copyCGImage(at: time, actualTime: &actualTime)
            let img = UIImage(cgImage: cgImg)
            return img
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
}

