ios-final-night
===============

ios-final-night

###TODO
* BTKitを使ってどんな情報を送るかを検討
* ゲームロジックの実装
* ゲーム遷移画面の実装
* Peripheral(server)選択viewを実装

###BUG


###BUG Fix


### How to use
ソースのダウンロード
```html
  git clone https://github.com/cinemania/ios-final-night.git
```
（上記は本家なので、git pushをして更新を行う場合は、forkしたrepositoryをpushする事)

本家への
```html
  git push
```
は禁止


submoduleのアップデート
```html
  cd ios-final-knight
  git submodule update --init
```

必要があればframework-btのプロジェクトを開いてCtrl+Bでライブラリをビルドする

### Project Structure
```html
├── README.md								<--------this document
├── SlowPushwer
│   ├── FinalKnight.xcodeproj								
│   ├── SlowPushwer							<--------application project folder
│   │   ├── Default-568h@2x.png				
│   │   ├── Default.png
│   │   ├── Default@2x.png
│   │   ├── RMAppDelegate.h					<--------application delegate
│   │   ├── RMAppDelegate.m					<--------application delegate
│   │   ├── RMDebugView
│   │   │   ├── RMDebugView.h				<--------view for debugging bt (currently game logic is also implemented)
│   │   │   └── RMDebugView.m
│   │   ├── RMViewController.h				<--------root view controller
│   │   ├── RMViewController.m
│   │   ├── SlowPushwer-Info.plist
│   │   ├── SlowPushwer-Prefix.pch
│   │   ├── en.lproj
│   │   │   ├── InfoPlist.strings
│   │   │   └── MainStoryboard.storyboard   <--------Currently not used
│   │   ├── images
│   │   │   └── temp						<--------temp image used in debug is put in here
│   │   │       └── FFT_Knights.png			<--------Just temp image
│   │   └── main.m
│   └── SlowPushwerTests					<--------unit tests 
│       ├── SlowPushwerTests-Info.plist
│       ├── SlowPushwerTests.h
│       ├── SlowPushwerTests.m
│       └── en.lproj
│           └── InfoPlist.strings
├── framework-bt							<--------submodule
└── framework-motion						<--------submodule
```