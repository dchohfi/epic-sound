//
//  ESTrackCell.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ESTrackCell.h"
#import "ESTrack.h"
#import "ESUser.h"
#import "TTTTimeIntervalFormatter.h"
@interface ESTrackCell ()

@property(nonatomic, strong) ESTrack *track;
@property(nonatomic, weak) UIImageView *imageAvatar;
@property(nonatomic, weak) UIImageView *imageWave;

@end

@implementation ESTrackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
        imageAvatar.clipsToBounds = YES;
        [self.contentView addSubview:imageAvatar];
        self.imageAvatar = imageAvatar;
        
        UIImageView *imageWave = [[UIImageView alloc] initWithFrame:CGRectMake(5, 55, 310, 50)];
        imageWave.contentMode = UIViewContentModeScaleToFill;
        imageWave.backgroundColor = [UIColor darkGrayColor];
        [self.contentView addSubview:imageWave];
        self.imageWave = imageWave;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithTotalRed:239
                         green:239
                          blue:239
                          alpha:1.0] set];
    UIRectFill(rect);
    
    [[UIColor lightGrayColor] set];
    NSString *userName = self.track.user.username;
    NSString *title = self.track.title;
    NSString *timeInterval = self.track.timeIntervalSinceCreatedAt;
    UIFont *smallFont = [UIFont systemFontOfSize:12];
    UIFont *biggerFont = [UIFont boldSystemFontOfSize:13];
    CGSize userNameSize = [userName sizeWithFont:smallFont];
    CGSize titleSize = [title sizeWithFont:biggerFont];
    CGSize timeIntervalSize = [timeInterval sizeWithFont:smallFont];
    
    CGFloat userNameWidth = (320-60-timeIntervalSize.width);
    CGFloat currentY = 5;
    [userName drawAtPoint:CGPointMake(55, 5)
                 forWidth:userNameWidth
                 withFont:smallFont
            lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect timeIntervalRect = CGRectMake(50+userNameWidth, currentY, timeIntervalSize.width, timeIntervalSize.height);
    [timeInterval drawInRect:timeIntervalRect
                    withFont:smallFont
               lineBreakMode:NSLineBreakByTruncatingTail
                   alignment:NSTextAlignmentRight];
    currentY += userNameSize.height;
    
    [[UIColor darkGrayColor] set];
    [title drawAtPoint:CGPointMake(55, currentY)
              forWidth:265
              withFont:biggerFont
         lineBreakMode:NSLineBreakByTruncatingTail];
    
    [[UIColor lightGrayColor] set];
    currentY += titleSize.height;
    NSString *stats = [NSString stringWithFormat:@"Plays %i | Comments %i | Favs %i", self.track.playbackCount, self.track.commentCount, self.track.favoritingsCount];
    [stats drawAtPoint:CGPointMake(55, currentY)
              forWidth:265
              withFont:smallFont
         lineBreakMode:NSLineBreakByTruncatingTail];
}
#pragma mark - custom getter/setter
- (void) setTrack: (ESTrack *) track {
    _track = track;
    [self.imageAvatar setImageWithURL:track.artworkUrl
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self downloadAndCropWaveImage: track];
    [self setNeedsDisplay];
}
- (void) downloadAndCropWaveImage: (ESTrack *) track {
    self.imageWave.image = nil;
    if(track.halfWaveImage){
        self.imageWave.image = track.halfWaveImage;
    }else{
        [SDWebImageManager.sharedManager downloadWithURL:self.track.waveformUrl
                                                 options:0
                                                progress:nil
                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                   if (image){
                                                       track.halfWaveImage = [image halfImage];
                                                       self.imageWave.image = track.halfWaveImage;
                                                   }
                                               }];
    }
}
@end
