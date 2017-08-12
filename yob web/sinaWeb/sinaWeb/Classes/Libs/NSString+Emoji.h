//
//  NSString+Emoji.h
//
//  Created by apple on 14/8/9.
//  Copyright (/Users/Macx/Desktop/微博~/sinaWeb/sinaWeb.xcodeprojc) 2014年  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
@end
