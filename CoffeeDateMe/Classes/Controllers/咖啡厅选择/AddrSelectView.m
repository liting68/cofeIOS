//
//  AddrSelectView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/24.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "AddrSelectView.h"
#import "UIView+KGViewExtend.h"

@implementation AddrSelectView

- (void)initAddrSelectViewWithData:(NSArray *)data level:(int)level
{
    
    provinces = data;
    
    self.locatePicker.delegate = self;
}
     
#pragma mark - Actions
     
- (IBAction)cancelAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.top = K_UIMAINSCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
       
        
    }];
}
     
- (IBAction)comfirmAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.top = K_UIMAINSCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    //////////////
    if (self.type == 4) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(addrSelectDidSelectTitle:)]) {
            
            NSString * title = [provinces[self.level] valueForKey:@"name"];
            
            [self.delegate addrSelectDidSelectTitle:title];
            
        }
        
        return;
    
    }else if(self.type == 5) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(addrSelectDidSelectTitle:)]) {
            
            NSString * title = provinces[self.level];
            
            [self.delegate addrSelectDidSelectTitle:title];
            
        }
        
        return;
        
    }else if (self.type == 6) {
        
        NSString * title = nil;
        
        if (self.level1 == 0) {
            
            title = @"保密";
        
        }else {
            
            NSString * tempString = [NSString stringWithFormat:@"%d%d",self.level1 - 1,self.level2];
            
            int tempInt = [tempString intValue];
            
            title = [NSString stringWithFormat:@"%d",tempInt];
            
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(addrSelectDidSelectTitle:)]) {
            
            [self.delegate addrSelectDidSelectTitle:title];
            
        }
        
        return;
    }
    ///////////////
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addrSelectDidSelectProvinceID:cityID:townID:circleID:addrString:)]) {
    
        NSMutableString * addr = [[NSMutableString alloc] initWithCapacity:0];

        NSDictionary * provinceDic = provinces[_level1];
        NSString * proviceID = [provinceDic valueForKey:@"id"];
        NSString * proviceName = [provinceDic valueForKey:@"name"];
        [addr appendString:proviceName];
        
        NSArray * cityArr = [provinceDic valueForKey:self.level1_key];
        NSDictionary * cityDic =  cityArr[_level2];
        NSString * cityID = [cityDic valueForKey:@"id"];
        NSString * cityName = [cityDic valueForKey:@"name"];
        [addr appendString:cityName];
        
        NSArray * circleArr = [cityDic valueForKey:self.level2_key];
        NSDictionary *  circleDic = circleArr[_level3];
        NSString * circleID = [circleDic valueForKey:@"id"];
        NSString * circleName = [circleDic valueForKey:@"name"];
        [addr appendString:circleName];
        
        
        addr = [addr stringByReplacingOccurrencesOfString:@"----" withString:@""];
        
        if (self.type == 0) {
            
            [self.delegate addrSelectDidSelectProvinceID:proviceID cityID:cityID townID:nil circleID:circleID addrString:addr];

        }else if(self.type == 1) {
            
             [self.delegate addrSelectDidSelectProvinceID:proviceID cityID:cityID townID:circleID circleID:nil addrString:addr];
       
        }else if (self.type == 2) {
         
            [self.delegate addrSelectDidSelectProvinceID:proviceID cityID:cityID townID:circleID circleID:nil addrString:addr];

        }
    }
}

#pragma mark - PickerView lifecycle
/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel * label
    
}*/

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if(self.type == 0) {
        
        if (component == 0) {
            
            return 80;
        
        }else if(component == 1) {
            
            return 80;
        
        }else {
            
            return 160;
        }
        
    }else {

        if (self.type == 1 || self.type == 2) {
            
            return K_UIMAINSCREEN_WIDTH / 3;
        
        }else if(self.type == 4) {
            
            return K_UIMAINSCREEN_WIDTH;
        
        }else if (self.type == 5) {
            
            return K_UIMAINSCREEN_WIDTH;
        
        }else {
            
            return K_UIMAINSCREEN_WIDTH/2;
        }
    
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type == 4 || self.type == 5) {
        
        return 1;
    
    }else if(self.type == 6) {
        
        return 2;
    }
    
    return self.level;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    if (self.type == 4 || self.type == 5 ) {
        
        return [provinces count];
    
    }else if (self.type == 6) {
        
        if (component == 0) {
            
            return 11;
        
        }else {
            
            if (self.level1 == 0) {
                
                return 0;
            
            }else {
                
                return 10;
            }
            
        }
        
    }
    ////////////////
    
//    
//    {
//        city =     (
//        );
//        id = 34;
//        name = "\U6fb3\U95e8\U7279\U522b\U884c\U653f\U533a";
//    }
    
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1: {
            
            if (_level < [provinces count]) {
                
                NSDictionary * cityDic = provinces[_level1];
                NSArray * cityArr  = [cityDic valueForKey:self.level1_key];
                return [cityArr count];
           
            }else {
                
                return 0;
            }
        }
        break;
            
         case 2:{
             
             if (_level1 < [provinces count]) {
                 
                 NSDictionary * cityDic = provinces[_level1];
                 NSArray * cityArr  = [cityDic valueForKey:self.level1_key];
                
                 if (_level2 < [cityArr count]) {
                     
                      NSDictionary * townDic = cityArr[_level2];
                     
                     NSArray * townArr = [townDic valueForKey:self.level2_key];
                     return [townArr count];
                 
                 }else {
                     
                     return 0;
                 }
                
             }else {
                 
                 return 0;
             }
        }
            
         break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
   // return @"555";
    
    if (self.type == 4 ) {
        
        return [provinces[row] valueForKey:@"name"];
    
    }else if (self.type == 5) {
        
        return provinces[row];
    
    }else if (self.type == 6) {
        
        if (component == 0) {
            
            if (row == 0) {
               
                return @"保密";
            
            }else {
                
                return  [NSString stringWithFormat:@"%d",row - 1];
            }
            
        }else {
            
             return  [NSString stringWithFormat:@"%d",row ];

        }
    }
    /////////
    
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row]objectForKey:@"name"];
            break;
        case 1:{
            NSDictionary * proviceDic = provinces[_level1];
            NSArray * cityArr  = [proviceDic valueForKey:self.level1_key];
            NSDictionary * cityDic = cityArr[row];
            return [cityDic valueForKey:@"name"];
            
        }case 2:{
            NSDictionary * proviceDic = provinces[_level1];
            NSArray * cityArr  = [proviceDic valueForKey:self.level1_key];
            NSDictionary * cityDic = cityArr[_level2];
            NSArray * townArr = [cityDic valueForKey:self.level2_key];
            return  [townArr[row] valueForKey:@"name"];

        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
 
    if (self.type == 4 || self.type == 5) {
        
        self.level = row;
        
        return;
    
    }else if(self.type == 6) {
        
        if (component == 0) {
            
            self.level1 = row;
            
             [self.locatePicker reloadComponent:1];
        
        }else {
            
            self.level2 = row;
        }
        
        return;
    }
    /////////////////////
    switch (component) {
        case 0:
    
            _level1 = row;
            
            _level2 = 0;
            
            _level3 = 0;
            
           // [self.locatePicker selectRow:0 inComponent:1 animated:NO];
           // [self.locatePicker selectRow:0 inComponent:2 animated:NO];
            
            [self.locatePicker reloadComponent:1];
        
            [self.locatePicker reloadComponent:2];
            
            break;
            
        case 1:
            
            _level2 = row;
            
            _level3 = 0;
            
          //  [self.locatePicker selectRow:0 inComponent:2 animated:NO];
            
            [self.locatePicker reloadComponent:2];
            
            break;
            
        case 2:

            _level3 = row;
            
        default:
            break;
    }
}

@end
