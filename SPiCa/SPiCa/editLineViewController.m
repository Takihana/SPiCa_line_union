//
//  editLineViewController.m
//  test0921
//
//  Created by takuya on 2014/09/22.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "editLineViewController.h"
#import "DragView.h"

@interface editLineViewController();
@property  NSMutableArray *TouchArray;
@property (assign, nonatomic) Boolean flag;

@property float x;
@property float y;

@end


@implementation editLineViewController
//ベースとなる画像
UIImageView *showImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //ナビゲーションツールバーを除いた大きさの取得
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screen);
    CGFloat screenHeight = CGRectGetHeight(screen);
    CGFloat statusBarHeight = 30;
    CGFloat navBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat availableHeight = screenHeight - statusBarHeight - navBarHeight;
    CGFloat availableWidth = screenWidth;
    
    //ここで渡された画像を表示
    showImageView = [[UIImageView alloc] init];
    showImageView.image = self.picture;
    //[showImageView setFrame:[[UIScreen mainScreen]applicationFrame]];
    
    showImageView.frame = CGRectMake(0, statusBarHeight + navBarHeight, availableWidth, availableHeight);
    
    showImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:showImageView];
    
    for (DragView *subview in self.stars) {
        NSLog(@"%f",subview.frame.origin.x);
        
    }
    
    //ここから線を引くための下処理
    //初期フラグ
    self.flag = false;
    //線をつなぐための配列
    self.TouchArray = [NSMutableArray array];
    
    CGPoint org = CGPointMake(self.view.frame.size.width/2,
                              self.view.frame.size.height/2);
    
    CGPoint Init = CGPointMake(0,0);
    NSValue* InitPoint = [NSValue valueWithCGPoint:Init];
    
    [self.TouchArray addObject:InitPoint];
    [self.TouchArray addObject:InitPoint];
    
    NSLog(@"org.x:%f org.y:%f", org.x, org.y);
    
    self.x = org.x;
    self.y = org.y;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{// シングルタッチの場合
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:showImageView];
    
    NSLog(@"location.x:%f location.y:%f", location.x, location.y);
    
    //座標の周りに領域を作る。今回は決めうちしているが、本来は座標の配列分繰り返して判定する。
    //CGRect rc = CGRectMake(300,300,100,100);
    //CGRect rc2 = CGRectMake(300,500,100,100);
    
    
    
     
    //星座標を取得
    //NSValue* Starvalue = [NSValue new];
    CGPoint Starpoints[100];
    //星に収束したかを表すフラグ
    bool touchflag = false;
    
    int starCount1=0;
    //for (NSValue *Starvalue in self.stars) {
    for(DragView *StarView in self.stars){
        Starpoints[starCount1++] = StarView.frame.origin;
    }
    
    //星座標をタッチしたか確認
    int starCount2=0;
    for(starCount2 = 0; starCount2<starCount1;starCount2++){
        //CGRect rc = CGRectMake(Starpoints[starCount2].x,Starpoints[starCount2].y,100,100);
        
        float rx = location.x - Starpoints[starCount2].x-10;
        float ry = location.y - Starpoints[starCount2].y+34;
        //距離rを求める
        float r = sqrt(rx*rx + ry*ry);
        NSLog(@"距離：%f", r);
        
        if(r <= 10) {
            NSLog(@"this touch! Stars!");
            touchflag = true;
            location.x = Starpoints[starCount2].x+10;
            location.y = Starpoints[starCount2].y-34;
        }
        
        //if(CGRectContainsPoint(rc,location)){
        //    NSLog(@"this touch! Stars!");
        //    location.x = Starpoints[starCount2].x;
        //    location.y = Starpoints[starCount2].y;
        //
        //}
        
    }
    
    //星以外をタッチしたらフラグそのままでスルーするようにする処理を書くこと（フラグでも使う）
    if(touchflag == false){
        NSLog(@"this Not touch!? Stars!?");
        return;
    }
    
    /*
     if(CGRectContainsPoint(rc,location)){
        //if(CGRectContainsPoint(self.uiView.frame,location)){
        NSLog(@"this touch! rc!");
        
        location.x=300;
        location.y=300;
        
        
    }
    
    if(CGRectContainsPoint(rc2,location)){
        //if(CGRectContainsPoint(self.uiView.frame,location)){
        NSLog(@"this touch! rc2!");
        
        location.x=300;
        location.y=500;
        
        
    }
    */
    
    //float x = location.x - org.x;
    //float y = -(location.y - org.y);
    // 距離rを求める
    //float r = sqrt(x*x + y*y);
    //NSLog(@"距離：%f", r);
    
    //if(r <= 200) {
    //    location.x = org.x;
    //    location.y = org.y;
    //
    //    NSLog(@"変化後.x:%f 変化後.y:%f", location.x, location.y);
    //
    //}
    
    
    
    // NSMutableArray *toucharray = [NSMutableArray array];
    NSValue *value = [NSValue valueWithCGPoint:location];
    
    //一回目は線を引かない
    if(self.flag == false){
        
        [self.TouchArray addObject:value];
        self.flag = true;
        
    }
    else
    {
        //線を引く処理開始
        
        //タッチした座標をプロパティで保持できる形にする
        
        [self.TouchArray addObject:value];
        
        //削除するインデックスを確保する配列
        NSMutableIndexSet* indexes = [NSMutableIndexSet new];
        
        //[indexes addIndex:idx];    // 削除する位置だけ記録
        // まとめて削除
        //[mutableArray removeObjectAtIndexes:indexes];
        
        //現在の線を引くための座標が格納されている配列の値を取得したもの
        NSValue* valueline = [self.TouchArray objectAtIndex:0];
        CGPoint linepoints[100];
        
        //重複を削除するために一度点の座標をもってくる
        int w=0;
        for (NSValue *valueline in self.TouchArray) {
            linepoints[w++] = [valueline CGPointValue];
        }
        //削除処理
        for(int a = 0 ;a < w-1; a = a+2){
            //対象となる始点と終点の組を取得
            float FromX = linepoints[a].x;
            float FromY = linepoints[a].y;
            float ToX   = linepoints[a+1].x;
            float ToY   = linepoints[a+1].y;
            //配列の中に重複があったら削除するためにインデックスを取得
            for(int b = a + 2;b < w-1;b=b+2){
                if((FromX == linepoints[b].x ) && (FromY == linepoints[b].y)){
                    if((ToX == linepoints[b+1].x) && (ToY == linepoints[b+1].y)){
                        [indexes addIndex:a];
                        [indexes addIndex:a+1];
                        [indexes addIndex:b];
                        [indexes addIndex:b+1];
                    }
                    
                }
                if((FromX == linepoints[b+1].x ) && (FromY == linepoints[b+1].y)){
                    if((ToX == linepoints[b].x) && (ToY == linepoints[b].y)){
                        [indexes addIndex:a];
                        [indexes addIndex:a+1];
                        [indexes addIndex:b];
                        [indexes addIndex:b+1];
                    }
                    
                }
                
            }
            
            
        }
        
        // まとめて削除
        [self.TouchArray removeObjectsAtIndexes:indexes];
        
        showImageView.image = self.picture;
        
        //線を引くための頂点を格納する配列(現在は固定長だが可変長にしたい)
        
        NSValue* value = [self.TouchArray objectAtIndex:0];
        CGPoint points[100];
        
        //線を引くための頂点を取得
        int j=0;
        for (NSValue *value in self.TouchArray) {
            points[j++] = [value CGPointValue];
        }
        
        // 線を引くキャンパスのサイズや不透明度、スケールを指定する
        UIGraphicsBeginImageContextWithOptions(showImageView.frame.size, YES, 0.0);
        //指定したキャンパスの場所を取得
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 今まで記述したものを描く（このシステムでは存在していないはず）
        [showImageView.image drawInRect:showImageView.bounds];
        // 描画する線の情報を記述
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetRGBStrokeColor(context, 255, 255, 255, 50);
        
        // 線で一回目と二回目でタッチした所をつなぐ
        //for(int i = 0 ; i < j-1;i++){
        for(int i = 0 ; i < j-1 ; i = i + 2){
            // 始点と終点を設定
            CGContextMoveToPoint(context,points[i].x,points[i].y);
            CGContextAddLineToPoint(context,points[i+1].x, points[i+1].y);
            // 実際に線を描画
            CGContextStrokePath(context);
            
            //NSLog(@"%f", points[i].x);
            //NSLog(@"%f", points[i].y);
            //NSLog(@"%f", points[j-i].x);
            //NSLog(@"%f", points[j-i].y);
            
            
        }
        //描画した線を実際に画面に書き写す
        showImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        // メモリ領域を解放
        UIGraphicsEndImageContext();
        // フラグを一回目にする
        self.flag = false;
        
        
        
        
    }
    
    
    
}



- (IBAction)closeView:(UIBarButtonItem *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)actionsocial:(id)sender {
    //投稿するテキスト
    NSString *sharedText = @"テキスト #SPiCa";
    //投稿するコンテンツ、ここに画像を記載
    NSArray *activityItems = @[sharedText];
    
    //連携できるアプリの取得
    UIActivity *activity = [[UIActivity alloc] init];
    NSArray *appActivivities = @[activity];
    
    //アクティビティ作成
    UIActivityViewController *activityVC =[[UIActivityViewController alloc]
                                           initWithActivityItems:
                                           activityItems
                                           applicationActivities:
                                           appActivivities];
    //表示
    [self presentViewController:activityVC animated:YES completion:nil];
    
    }
@end

