[Marketplace](https://www.unrealengine.com/marketplace/en-US/horizon-ui-plugin)

[![Build Status](https://dev.azure.com/hsgame/UE4HorizonPlugin/_apis/build/status/HorizonUI/HorizonUIPluginDemo-Shipping-CI?repoName=HorizonUIPluginDemo&branchName=main)](https://dev.azure.com/hsgame/UE4HorizonPlugin/_build/latest?definitionId=24&repoName=HorizonUIPluginDemo&branchName=main)

public feed: nuget.org  

[![nuget.org package in feed in ](https://img.shields.io/nuget/v/HorizonUIPluginDemo.svg)](https://www.nuget.org/packages/HorizonUIPluginDemo/)
  
[Automation Test Result](http://horizon-studio.net/ue4/HorizonUIPluginDemo_TestReport/)


Note: 

master branch may be unstable since it is in development, please switch to tags, for example: editor/hsgame/4.25.0.290

How to Run Demo Project before purchase:(Only for Win64 editor build, no source code)
1. Double click install_game_package_from_nuget_org.cmd, and check if UE4Editor-*.dll are installed to Binaries\Win64 and Plugins\HorizonUIPlugin\Binaries\Win64\
2. Double click HorizonUIPluginDemo.uproject  

  
----------------------------------------------
              HorizonUIPlugin
                 4.27.0
         http://dorgon.horizon-studio.net
          	dorgonman@hotmail.com
----------------------------------------------
   
-----------------------
System Requirements
-----------------------

Supported UnrealEngine version: 4.11-4.27
 

-----------------------
Installation Guide
-----------------------

If you want to use plugins in C++, you should add associated module to your project's 
YOUR_PROJECT.Build.cs:
PublicDependencyModuleNames.AddRange(new string[] { "HorizonUI"});

-----------------------
User Guide: HorizonFlipbookWidget
-----------------------

This widget support using PaperFlipbook directly in UMG!

-----------------------
User Guide: HorizonDialogueMsgTextBlock
-----------------------

example 1: rich text simple
```
<text color="#77FF77AA" shadowColor="#FF0000FF" shadowOffset="[4,3]">This is rich text simple test:</text>
<br/>
<text color="#FF0000AA">This is strawberry:</text><img filePath="Texture2D'/Game/Item/I_C_Strawberry.I_C_Strawberry'" size="[100, 100]" /><br/>
<text color="#0000FFFF">This is Watermellon:</text><img color="#FF00FF77" filePath="/Game/Item/I_C_Watermellon" size="[100, 100]" /> <br/>
<text color="#FFFF00FF">This is animated man using material:</text><img filePath="Material'/Game/Material/mat_flipbook.mat_flipbook'" size="[100, 100]" /> <br/>
 ```

note: both Texture2D'/Game/Item/I_C_Strawberry.I_C_Strawberry' and  /Game/Item/I_C_Strawberry.I_C_Strawberry can work correctly

example 1: rich text simple using style feature
```
<text style="MyStyle0">This is rich text test using style:</text>
<br/>

<text style="MyStyle1">This is strawberry:</text><img style="MyStyle2" /><br/>

<text style="MyStyle3">This is Watermellon:</text><img style="MyStyle4"/> <br/>


<text style="MyStyle5">This is animated man using material:</text><mat style="MyStyle6" /> <br/>

<text style="MyStyle7">HorizonFlipbookWidget(use tag pfb) Only Supported by using style:</text><pfb style="MyStyle7" /> <br/>
```

MyStyle0 ~ MyStyle7 is a array that can be setted in UMG editor under HorizonPlugin/Style section
ref: https://drive.google.com/file/d/0BwANUSGaSQn-SlJZWUF5LWJHQTA/view?usp=sharing

By using style="YOUR_STYLE_NAME", you can use the style setting for your RichText block. 
*note: HorizonFlipbookWidget can only use style to work correctly. (Use filePath will not compute UV and Size for HorizonFlipbookWidget correctly.)
example 2: rich text font
```
<text>This is Default Font</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Regular" fontSize="30">This is Roboto Regular fontSize=30</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Italic" color="#FF0000AA">This is Roboto Italic</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Bold Italic"  fontSize="40" color="#FF3366AA">This is Roboto Bold Italic fontSize=40</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Light" color="#FFFF00AA">This is Roboto Light</text><br/>
<text fontPath="/Engine/EngineFonts/RobotoTiny" fontType="Light" color="#FF0A40AA">This is RobotoTinyLight</text><br/>

```
example 3: padding
```
<text fontSize="55">Test case:</text> 
<text padding-right="5" padding-top="20">
 <text padding-left="5">padding text block</text>
 <img filePath="/Game/Material/mat_flipbook"/>
 <img filePath="/Game/Item/I_C_Watermellon" size="[100,100]" />
</text>
<text>after padding</text>
```
example 4: special character
following character will be replaced:
```
&nbsp;  == " "
&quot;  == "
&amp; ==  "&"
&apos;  =="'"
&lt;  == "<"
&gt;   ==">"
```
sample:
```
<text> &nbsp;  == " "</text><br/>
<text> &quot;  == " </text><br/>
<text> &amp;  ==  "&"</text><br/>
<text> &apos;"  =="'"</text><br/>
<text> &lt;  == "&lt;"</text><br/>
<text> &gt;   =="&gt; "</text><br/>
```
example 5: hyperlink
```
<a href="Seg1ClickMessage" bgColor="#555555FF" hoverColor="#FFFF0055" 
filePath="Blueprint'/Game/UMG/DialogueMsgTextTest/ButtonStyle/BP_DialogueBackgroundButtonStyle1.BP_DialogueBackgroundButtonStyle1'">
<text color="#FF0000FF"> Test Click Seg1  </text>
</a>
<br />

<a href="Seg2ClickMessage" bgColor="#FF0000FF" hoverColor="#FFFF0055"
 filePath="Blueprint'/Game/UMG/DialogueMsgTextTest/ButtonStyle/BP_DialogueBackgroundButtonStyle2'">
<text color="#00FF00FF"> Test Click Seg2  </text>
</a>

<br />

<a href="Seg3ClickMessage" bgColor="#FF0000FF" hoverColor="#FFFF0055" 
filePath="/Game/UMG/DialogueMsgTextTest/ButtonStyle/BP_DialogueBackgroundButtonStyle3">
<text color="#0000FFFF"> Test Click Seg3  </text>
</a>
```
When you click, you will receive info assigned in href if you bind button's click callback.  
Please check WidgetBlueprint'/Game/UMG/DialogueMsgTextTest/Tuto8_HyperText.Tuto8_HyperText'  

example 6: sound  

```
<text style="MyStyle3">HorizonFlipbookWidget( use tag pfb ) Only Supported by using style:</text>
<pfb sound="SoundWave'/Engine/VREditor/Sounds/UI/Click_on_Button.Click_on_Button'" 
soundVolumn="0.5" soundPitch="0.1" soundStartTime="0.05" style="MyStyle4" /> <br/>
<text>

```  

example 7: Custom Event && Callback

Please Check WidgetBlueprint'/Game/UMG/DialogueMsgTextTest/Tuto06_EventTrigger.Tuto06_EventTrigger'

```
<text eventName="Seg1", eventPayload="{"A":"Data1", "B":"Data2"}">This is simple test: </text>
<text eventName="Seg2">12345678910 
11121314151617181920</text>
```  
![Custome Event Usage](https://raw.githubusercontent.com/dorgonman/HorizonUIPluginDemo/master/ScreenShot/HorizonUI_Screenshot9.png)



example 7: RubyText  

```
<text style="test">
<text>Test &nbsp;</text>
<text ruby.text="furigana">RubyText</text>
<br/>

<text ruby.text="ふ">振</text>
<text>り</text>
<text ruby.text="がな">仮名</text>
<br/>

<text ruby.text="ㄨㄛˇㄕˋ">我是</text>
<text ruby.text="變態">紳士</text>
</text>
```  




example 8: Decorator  

We can implement our own logic in Decorator, ex: Load InputIcon from DataTable.
  
```
<text> Please press &nbsp;</text>
<img eventPayload="ConfirmIcon" padding-top="-15"/>
<text> &nbsp; to start </text>
```  
![Decorator1](https://raw.githubusercontent.com/dorgonman/HorizonUIPluginDemo/master/ScreenShot/Decorator/Decorator1.png)  

![Decorator2](https://raw.githubusercontent.com/dorgonman/HorizonUIPluginDemo/master/ScreenShot/Decorator/Decorator2.png)  

![Decorator3](https://raw.githubusercontent.com/dorgonman/HorizonUIPluginDemo/master/ScreenShot/Decorator/Decorator3.png)  

  
  
example 9: New Page Tag  
  
  
```
<p style="Page1">
<text>Page1 Test </text>
<br/>
<text>Page1.1 </text>
<br/>
<text>Page1.2 </text>

</p>

<p style="Page2">
<text>Page2 Test</text>
<br/>
<text>Page2.1 </text>
<br/>
<text>Page2.2 </text>

</p>
<p style="Page3">
<text>Page3 Test</text>
<br/>
<text>Page3.1 </text>
<br/>
<text>Page3.2 </text>
</p>
```  

-----------------------
Technical Details
-----------------------

List of Modules:
HorizonUI (Runtime)
Intended Platform: All Platforms
Platforms Tested: Win64, Android
Currently has two widget implemented:
	1. HorizonFlipbookWidget: This widget support using PaperFlipbook directly in UMG!
	2. HorizonDialogueMsgTextBlock: Combine both rich text and dialogue text function in this widget! 
	   For rich text feature: you can control text Color, Shadow Color, Font, Font size and padding for each text block.
	   For dialogue text feature: you can control dialogue speed and whether it will repeated after finish.  
Demo Project: https://github.com/dorgonman/HorizonUIPluginDemo  
DemoVideo: https://www.youtube.com/watch?v=GQBd2qAEpCg&feature=youtu.be  

-----------------------
What does your plugin do/What is the intent of your plugin
-----------------------  

This Plugin contains some extension for UMG Widget. 
	Currently have two widget included:
	1. HorizonFlipbookWidget
	2. HorizonDialogueMsgTextBlock  
	
-----------------------
Contact and Support
-----------------------

email: dorgonman@hotmail.com  

-----------------------
 Version History
-----------------------

*4.27.0 

* AB#2120 [New][HorizonWidgetFunctionLibrary] Implement SetInputMode

* AB#2117 [HorizonMultiToggleButtonWidget] Change HorizonMultiToggleButtonState's TextColor to White

* AB#2118 [HorizonTileView] Remove constructor, so inherited class can use default constructor without compiler error

* AB#1990 [BugFix][HorizonRadioButtonUserWidge] Should not get multiple checked radio button when use IsChecked in OnCheckedDelegate

* AB#1957 [BugFix] Set HorizonButton, HorizonMultiToggleButton, and HorizonRadioButton as bIsFocusable and Visible by default

* AB#1954 AB#1955 AB#1956 [BugFix] Fix widget callbacks added multiple times by move binding to NativeOnInitialized

* AB#1952 [New][HorizonDialogueMsgTextBlock] Implement Force setter for SetShadowColorAndOpacity, SetShadowOffset, SetFont, SetJustification, and SetDialogueMsgSpeed.

* AB#1950 AB#1951 [BugFix][HorizonDialogueMsgTextBlock] OnDialoguePageEndFunction and OnDialogueMsgLoopFunction not work as expected

* AB#1949 [New][HorizonTileView] Implement OnRefreshDesignerItems, so we don't need to implement it in every child widget

* AB#1948 [New][HorizonTileView] Expose GetNumGeneratedChildren from slate

* AB#1947 [New][TileView] Expose IsPendingRefresh to TileView Widget from slate

* AB#1944 [New][HorizonTileView] Focus EntryWidget when HandleListEntryHovered

* AB#1943 [New][HorizonTileView] Implement NavigateToAndSelectIndex

* AB#1937 [New][HorizonFlipbookWidget] Implement OnAnimationStart and OnAnimationFinished

* AB#1941 [Bugfix] Failed to load /Script/HorizonUI.HorizonDialogueMsgTextBlock Referenced by WidgetTree

* AB#1877 [BugFix][HorizonDialogueMsgTextBlock] AutoPage line should fill up entire page

* AB#1862 AB#1863 [HorizonDialogueMsgTextBlock] Implement GetNumPage and SkipCurrentDialoguePage when DialogueMsgSpeed less then 0

* AB#2177 [BugFix] TextOverflowWarpNormal should break segment text to next line

* AB#2186 [New] Add SCOPED_NAMED_EVENT_TEXT and DECLARE_SCOPE_CYCLE_COUNTER to some functions for performance measure

* [Refactor] Remove Deprecated code

* [BugFix] Hotfix Explicit PCH compile error

* AB#2233 [Optimization] Add PrivatePCHHeaderFile to .Build.cs to optimizae build speed

* [New][Build] PublicDefinitions.Add("WITH_HORIZONUI=1")




*4.26.1  

* [BugFix][HorizonDialogueMsgTextBlock] AutoPage line should fill up entire page

* [HorizonDialogueMsgTextBlock] Implement GetNumPage and SkipCurrentDialoguePage when DialogueMsgSpeed less then 0


*4.26.0  

* [Refactor] Fix Typo from EHorizonDialogueTextOverflowWarpMethod to EHorizonDialogueTextOverflowWrapMethod

* [New][HorizonDialogueMsgTextBlock] Russian OverflowWrap support

* GITHUB#6 [BugFix] Remove empty line with only space and skip space char at beginning of line for some edge case  
    
* [New][HorizonDialogueMsgTextBlock] Implement NewPage tag <p>

* [New][HorizonDialogueMsgTextBlock] Add bForceRebuildDialogueMsgText as workaround that geometry.Size.X is 0 in some case

* [BugFix][HorizonFlipbookWidget] GetPaletteCategory

* [BugFix] Fix AddBackgroundButton BlockSize

* [BugFix][HorizonDialogueMsgTextBlock] Flipbook should be able loaded using filePath

* [New][HorizonDialogueMsgTextBlock] Implement PreBuildDecoration

* [New][HorizonDialogueMsgTextBlock] RubyText Implmenetation

* [BugFix][HotFix][HorizonDialogueMsgTextBlock] Don't crash

* [BugFix][HorizonDialogueMsgTextBlock] Fix Create BlockInfo's CurrentLineWidth calculation when Decoration change block size

* [BugFix][HorizonButton] RemoveDynamic before AddDynamic for delegates  

* [BugFix][HorizonDialogueMsgTextBlock] Fix auto page padding bugs

* [Refactor][HorizonDialogueMsgTextBlock] Add meta = (TitleProperty = "StyleName") for SegmentStyleList

* [UHorizonDialogueMsgTextBlock] RebuildBlockInfoDecoration to public

* [New][UHorizonDialogueMsgTextBlock] Implement HorizonDialogueMsgDecorator

* [Refactor] Coding style

* [New] Implement HorizonMultiToggleButtonWidget

* [BugFix][HorizonDialogueMsgTextBlock] Fix SkipDialogue, NextDialogueMsgPage and PrevDialogueMsgPage didn't work as intend

	1. Should not call SetDialogueMsgPage if current page didn't change
	2. SetDialogueMsgPage should reset CurrentDialogueLineIndex to StartLineIndex ,CurrentDialogueBlockIndex to 0 and CurrentCharIndex to  0
	3. SetIsStartTickDialogueMsg should has bShouldResetDialogue, that user can choose when to reset dialogue index.

* [New] Expose FHorizonDialogueBlockInfo and FHorizonDialogueLineInfo to BP and adjust category

* [Refactor][HorizonMultiToggleButtonWidget] Adjust Some assumption and api usage


*4.25.0  
Update to 4.25

	New: [UHorizonDialogueMsgTextBlock] Move semantics version of SetTextAndRebuildDialogue

	New: [UHorizonWidgetFunctionLibrary] GetUserIndex

	New: [UHorizonWidgetFunctionLibrary] IsChildWidget

	New: [UHorizonWidgetFunctionLibrary] Implement ContainWidgetType

	New: [HorizonWidgetFunctionLibrary] GetInputMode

	New: [UHorizonButtonUserWidget] Implement UHorizonButtonUserWidget::NativeOnFocusReceived for Button_Main focus

	BugFix: [UHorizonButtonUserWidget] bFocusOnHovered should trigger OnButtonFocusDelegate && OnButtonFocusLostDelegate

	New: [HorizonTileView]

	Refactor: [HorizonFlipbookWidget] Inherited from UImage instead of UCanvasPanel

	Refactor: [UHorizonFlipbookWidget] Use SlateAtlasData for SourceUV and SourceSize, so we don't need to bake at editor time anymore

 	[Refactor][UHorizonFlipbookWidget] Expose Tick to public

 	[BugFix][HorizonFlipbookWidget] ResetAnimation should set to first frame




*4.24.0  

	New: [HorizonRadioButton]   

	New: [UHorizonDialogueMsgTextBlock] Implement CharAdvancedDelegate, so user can add the typewriter sound in this callback.  

	New: [UHorizonDialogueMsgTextBlock] Add eventPayload for custom evnet(see example 7)

	New: [UHorizonDialogueMsgTextBlock] Use CreateDialogueImage, CreateDialogueFlipbook, CreateDialogueTextBlock instead of NewObject for each DialogueBlockInfo, so it can be customizable in child class.  

	BugFix: [UHorizonDialogueMsgTextBlock] Should not call AddBackgroundButton if segInfo.HypertextReference not set
	


*4.23.0  

	BugFix: Size to Content not working   
	
	BugFix: Fix using Flipbook in UHorizonDialogueMsgTextBlock  

    Bugfix: [UHorizonDialogueMsgTextBlock] remove DefaultButtonStyleWidgetClass

*4.22.1  

	BugFix: Size to Content not working  

*4.22.0  

	NEW: Implement HorizonDesignableUserWidget, HorizonUserWidget and HorizonButtonUserWidget

	NEW: HorizonButtonUserWidget  

	NEW: [UHorizonDialogueMsgTextBlock] Implement SkipDialogue and SkipCurrentPage  

	NEW: [UHorizonDialogueMsgTextBlock] Implement DefaultButtonStyleWidget for href  

	NEW: [UHorizonDialogueMsgTextBlock] implement Wait for Dialogue Segment, ex: <text wait="2.5">1234</text> will wait 2.5 second before display next msg block.    	
	BugFix: href DefaultButtonStyleWidgetClass should not apply to other block  

	BugFix: [UHorizonDialogueMsgTextBlock] SetTextAndRebuildDialogue Should Build Text only after we get correct CachedGeometry  


*4.21.2  

	NEW: [UHorizonDialogueMsgTextBlock] CustomEventDelegate will be triggered, if there is an eventName specified in segment tags.  

	NEW: [UHorizonDialogueMsgTextBlock] Implement SkipDialogue and SkipCurrentPage  



*4.21.1  

	New: [UHorizonDialogueMsgTextBlock] pause and resume dialogue

	BugFix: RebuildFlipbook

	BugFix: Rebuild Only check GetCachedGeometry().Size.X > 0

*4.21.0  

	New: [HorizonDialogueMsgTextBlock] Add OnRebuildDialogueDelegate callback.  

	BugFix: [HorizonDialogueMsgTextBlock] under scalebox.  

	BugFix: [HorizonDialogueMsgTextBlock] Didn't advance to next char when segStartCharIndex == segCharIndex.  

	BugFix: [HorizonDialogueMsgTextBlock] GetCurrentPageTextLength crash when no page.  

	Refactor: [HorizonDialogueMsgTextBlock] Remove UCanvasPanel dependency and fix Behavior under SizeBox.  

	Refactor: [HorizonDialogueMsgTextBlock] Adjust Warning message when style not found,  

	Refactor: [HorizonDialogueMsgTextBlock] Put all seperate .cpp code into HorizonDialogueMsgTextBlock.cpp.  

	New: [UHorizonFlipbookWidget] Remove Dependency from UCanvasPanelSlot* pCanvasPanelSlot, now this widget can be used under any panel widget.  


*4.20.0  

	New: Sprite support for UHorizonDialogueMsgTextBlock.  

	New: GlobalTimeDilation Support in UHorizonDialogueMsgTextBlock Tick.  

	New: UHorizonDialogueMsgTextBlock::GetCurrentPageTextLength.  

	New: UHorizonDialogueMsgTextBlock::GetPageTextByIndex.  

	BugFix: Fix first line and first word overflow for UHorizonDialogueMsgTextBlock.  

	BugFix: Crash when hypertext is click and change text in UHorizonDialogueMsgTextBlock.  

	Refactor: Use Emplace instead of Add for TArray for UHorizonDialogueMsgTextBlock.  

*4.19.0  

	New: UHorizonDialogueMsgTextBlock [Auto Page](https://www.youtube.com/watch?v=kbjyGSoLpCk&feature=youtu.be) will split Dialogue Text into multiple pages.  

	New: UHorizonDialogueMsgTextBlock::IsDialogueMsgCompleted.  

	New: UHorizonWidgetFunctionLibrary::GetWidgetFromNameRecursively.  

	New: UVRegion for UHorizonImage.  

	New: UHorizonDialogueMsgTextBlock [Justification](https://www.dropbox.com/s/lp9i2qlkcb3j3ut/HorizonUI_HorizonDialogueMsgTextBlock_Justification.png?dl=0) for Left, Right and Center.  

	Refactor: C++ Classes folders Reorganized.  

	Refactor: Use TSoftObjectPtr for assets refenence in StyleInfo.  

	BugFix: SegmentStyleList are overrided by one of StyleInfoClassList.  

	BugFix: Style referenced assets are not loaded in some case.  

	BugFix: Break all for non english character in TextOverflowWarpNormal_Implement.  


*4.18.0  

	New: Implement Hypertext for HorizonDialogueMsgTextBlock：you will be able to use all button's features in dialogue segments.

	New: Implement Sound trigger for HorizonDialogueMsgTextBlock.

	New: Implement DialogueStyleInfo as Blueprintable UObject: Now you can management all HorizonDialogueSegmentInfoStyle in one or more BP class and apply to all HorizonDialogueMsgTextBlock.

	New: Crash when  tried add a new style and set its color.

	BugFix: Should ignore space at end of line for TextOverflowWarpNormal.(Empty new line bug)

	BugFix: Duplicate HorizonDialogueMsgTextBlock crash bug

	BugFix: LineWidth when adjust widget anchor

*4.17.0  
	UPDATE: update to engine 4.17.0, and plugin's VersionName will also follow engine's version.

	FIX: DialogueMsgSpeed crash when set the value to 0

	NEW: implement UHorizonDialogueMsgTextBlock::SetTextAndRebuildDialogue for Blueprints user, please use this method instead of SetText if you want to change Dialogue text at runtime.
	NEW: implement UHorizonFlipbookWidget::SetFlipbookSource for blueprints user, now you can adjust FlipbookSource UV and Size in blueprint. 

	NEW: 
	implement HorizonDialogueTextOverflowWarpMethod for UHorizonDialogueMsgTextBlock. You will be able to select "Normal" or "BreakAll" method, by default, plugin will change default warp method from BreakAll to Normal. 

	Normal Warp method means if the word overflow current line width(for both CJK or non-CJK), it will try move to next line and use BreakAll rule in next line. BreakAll method is plugin's previously implementation, the word will break at any character when text overflow occur.   


*1.3.0  

	UPDATE: update to engine 4.16
	NEW: implement StartDialogue and StopDialogue for HorizonDialogueMsgTextBlock

*1.2.4  

	UPDATE: update to engine 4.15

*1.2.1  

	FIX: The times HorizonFlipbookWidget NumOfLoop for flipbook animation plays incorrectly.
		
*1.2.0  

	NEW: HorizonFlipbookWidget: 
		1. Add NumOfLoop that you can specify how much loop this Flipbook will play.
		2. Expose Blueprint Method: ResetAnimation, PlayAnimation, StopAnimation, PauseAnimation, ResumeAnimation.

*1.1.0  

	NEW: Add style feature for HorizonDialogueMsgTextBlock
	FIX: 
		1. Fix Crash when putting a flipbook nested in a button.
		2. Fix ensureMsgf check fail by set widget outer to WidgetTree.
		3. Fix some display bug in UMG Hierarchy. Don't call RebuildSegmentInfoList if it is created from palette. 
	REFACTOR: 
		1. Move HorizonUI module from Source/HorizonUI to Source/Runtime/HorizonUI
		2. Rename Blueprint UPROPERTY Category for class members in HorizonFlipbookWidget and HorizonDialogueMsgTextBlock
		3. Minor code refactoring

1.0.0  

	NEW: First Version including core features.
			1. HorizonFlipbookWidget
			2. HorizonDialogueMsgTextBlock
