//
//  ImageProcessor.swift
//  Iris
//
//  Created by blacklizard on 19/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation
import Accelerate

class ImageProcessor {
	
	func resize(original image: CGImage,to size: CGSize) -> CGImage? {
		let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: image.bitmapInfo.rawValue)
		context?.interpolationQuality = .none
		context?.draw(image, in: CGRect(origin: .zero, size: size))
		guard let scaledImage = context?.makeImage() else { return nil }
		return scaledImage;
	}
	
	// this shits uses too much cpu - copied from https://medium.com/ios-expert-series-or-interview-series/resize-image-with-swift-4-ca17d65bbc85
	func resizeHighCpuUsage(original image: CGImage,to size: CGSize ) -> CGImage? {
		let cgImage = image
		var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
		var sourceBuffer = vImage_Buffer()
		defer {
			free(sourceBuffer.data)
		}
		var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
		guard error == kvImageNoError else { return nil }
		// create a destination buffer
		
		let destWidth = Int(size.width)
		let destHeight = Int(size.height)
		let bytesPerPixel = cgImage.bitsPerPixel/8
		let destBytesPerRow = destWidth * bytesPerPixel
		let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
		defer {
			destData.deallocate()
		}
		var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
		// scale the image
		error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
		guard error == kvImageNoError else { return nil }
		// create a CGImage from vImage_Buffer
		let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
		guard error == kvImageNoError else { return nil }
		
		return destCGImage
	}
}

