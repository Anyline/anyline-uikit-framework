//
//  OpenCVWrapper.m
//  AnylineUIKit
//
//  Created by Mac on 12/10/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

#import "OpenCVWrapper.h"
// BGN: hack for colision between OpenCV and UIKit definition of 'NO'
#undef NO
// END: hack for colision between OpenCV and UIKit definition of 'NO'
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/imgproc_c.h>

#import <Foundation/Foundation.h>


using namespace cv;

@implementation OpenCVWrapper

// Here we can use C++ code

+(UIImage *) autoContrast:(UIImage *) image {
    Mat imageMat;
    UIImageToMat(image, imageMat);
    
    std::vector<Mat> channels;
    Mat img_hist_equalized;
    
    cvtColor(imageMat, img_hist_equalized, COLOR_BGR2YCrCb); //change the color image from BGR to YCrCb format
    
    split(img_hist_equalized,channels); //split the image into channels
    
    equalizeHist(channels[0], channels[0]); //equalize histogram on the 1st channel (Y)
    
    merge(channels,img_hist_equalized); //merge 3 channels including the modified 1st channel into one image
    
    cvtColor(img_hist_equalized, img_hist_equalized, COLOR_YCrCb2BGR);
    
    return MatToUIImage(img_hist_equalized);
}

+(UIImage *) processImageWithOpenCV:(UIImage *) inputImage {
    Mat imageMat;
    UIImageToMat(inputImage, imageMat);
    threshold(imageMat, imageMat, 128, 255, cv::THRESH_BINARY);
    return MatToUIImage(imageMat);
}

+(UIImage *) autoWBOpenCV:(UIImage *) inputImage {
    float clipHistPercent = 0;
    Mat src;
    UIImageToMat(inputImage, src);
    
    CV_Assert(clipHistPercent >= 0);
    CV_Assert((src.type() == CV_8UC1) || (src.type() == CV_8UC3) || (src.type() == CV_8UC4));
    
    int histSize = 256;
    float alpha, beta;
    double minGray = 0, maxGray = 0;
    
    //to calculate grayscale histogram
    cv::Mat gray;
    if (src.type() == CV_8UC1) gray = src;
    else if (src.type() == CV_8UC3) cvtColor(src, gray, CV_BGR2GRAY);
    else if (src.type() == CV_8UC4) cvtColor(src, gray, CV_BGRA2GRAY);
    if (clipHistPercent == 0)
    {
        // keep full available range
        cv::minMaxLoc(gray, &minGray, &maxGray);
    }
    else
    {
        cv::Mat hist; //the grayscale histogram
        
        float range[] = { 0, 256 };
        const float* histRange = { range };
        bool uniform = true;
        bool accumulate = false;
        calcHist(&gray, 1, 0, cv::Mat (), hist, 1, &histSize, &histRange, uniform, accumulate);
        
        // calculate cumulative distribution from the histogram
        std::vector<float> accumulator(histSize);
        accumulator[0] = hist.at<float>(0);
        for (int i = 1; i < histSize; i++)
        {
            accumulator[i] = accumulator[i - 1] + hist.at<float>(i);
        }
        
        // locate points that cuts at required value
        float max = accumulator.back();
        clipHistPercent *= (max / 100.0); //make percent as absolute
        clipHistPercent /= 2.0; // left and right wings
        // locate left cut
        minGray = 0;
        while (accumulator[minGray] < clipHistPercent)
            minGray++;
        
        // locate right cut
        maxGray = histSize - 1;
        while (accumulator[maxGray] >= (max - clipHistPercent))
            maxGray--;
    }
    
    // current range
    float inputRange = maxGray - minGray;
    
    alpha = (histSize - 1) / inputRange;   // alpha expands current range to histsize range
    beta = -minGray * alpha;             // beta shifts current range so that minGray will go to 0
    
    // Apply brightness and contrast normalization
    // convertTo operates with saurate_cast
    Mat dst;
    src.convertTo(dst, -1, alpha, beta);
    
    // restore alpha channel from source
    if (dst.type() == CV_8UC4)
    {
        int from_to[] = { 3, 3};
        cv::mixChannels(&src, 4, &dst,1, from_to, 1);
    }
    
    return MatToUIImage(src);
}

+(UIImage *) toBlackAndWhite:(UIImage *) inputImage {
    Mat imageMat;
    UIImageToMat(inputImage, imageMat);
    cvtColor(imageMat,imageMat,CV_RGB2GRAY);
    return MatToUIImage(imageMat);
}

+(UIImage *) toGray:(UIImage *) inputImage {
    Mat imageMat;
    UIImageToMat(inputImage, imageMat);
    cvtColor(imageMat, imageMat, CV_BGR2GRAY);
    return MatToUIImage(imageMat);
}

@end
