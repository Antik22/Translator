//
//  LanguageSelecting.h
//  translater
//
//  Created by Tony Hrabovskyi on 2/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguageSelectingDelegate <NSObject>

- (void)receiveSelectedLanguage:(NSString*)language;

@end

@interface LanguageSelecting : UIViewController
@property (weak, nonatomic) id<LanguageSelectingDelegate> delegate;
- (void)selectLanguageFromList:(NSArray<NSString *> *)languageList;
@end
