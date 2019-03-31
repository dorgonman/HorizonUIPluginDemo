[Marketplace](https://www.unrealengine.com/marketplace/en-US/horizon-ui-plugin) 

[![Build Status](https://hsgame.visualstudio.com/UE4HorizonPlugin/_apis/build/status/HorizonUI/HorizonUIPluginDemo-Shipping-CI?branchName=master)](https://hsgame.visualstudio.com/UE4HorizonPlugin/_build/latest?definitionId=24&branchName=master)

public feed: nuget.org  

[![nuget.org package in feed in ](https://img.shields.io/nuget/v/HorizonUIPluginDemo.svg)](https://www.nuget.org/packages/HorizonUIPluginDemo/)

private feed(only for internal use): 

[![HorizonUIPluginDemo package in UE4HorizonPlugin feed in Azure Artifacts](https://hsgame.feeds.visualstudio.com/_apis/public/Packaging/Feeds/319fdc64-73ff-4910-b3b8-2ee206a67a49/Packages/bcb204d6-38c1-4f26-8e5d-5cf6904a10f9/Badge)](https://hsgame.visualstudio.com/UE4HorizonPlugin/_packaging?_a=package&feed=319fdc64-73ff-4910-b3b8-2ee206a67a49&package=bcb204d6-38c1-4f26-8e5d-5cf6904a10f9&preferRelease=true)



Note: 

master branch may be unstable since it is in development, please switch to tags, for example: release/4.21.0

How to Run Demo Project before purchase:(Only for Win64 editor build, no source code)
1. [Download nuget executable](https://www.nuget.org/downloads) and copy the exe into C:\Windows\system32\ or any place listed in your PATH environment.
2. Install [Git for Windows](https://gitforwindows.org/)
3. Double click install_package_from_nuget.org.sh, and check if UE4Editor-*.dll are installed to Binaries\Win64 and Plugins\HorizonUIPlugin\Binaries\Win64\
4. Double click HorizonUIPluginDemo.uproject  

  
----------------------------------------------
              HorizonUIPlugin
                 4.22.0
         http://dorgon.horizon-studio.net
          	dorgonman@hotmail.com
----------------------------------------------
   
-----------------------
System Requirements
-----------------------

Supported UnrealEngine version: 4.11-4.22
 

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
<text eventName="Seg1">This is simple test: </text>
<text eventName="Seg2">12345678910 
11121314151617181920</text>
```  
![Custome Event Usage](https://raw.githubusercontent.com/dorgonman/HorizonUIPluginDemo/master/ScreenShot/HorizonUI_Screenshot9.png)


-----------------------
Technical Details
-----------------------

List of Modules:
HorizonUI (Runtime)
Intended Platform: All Platforms
Platforms Tested: Win32, Android
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

*4.22.0  

	NEW: Implement HorizonDesignableUserWidget, HorizonUserWidget and HorizonButtonUserWidget

	NEW: HorizonButtonUserWidget  

	NEW: [UHorizonDialogueMsgTextBlock] Implement SkipDialogue and SkipCurrentPage  

	NEW: [UHorizonDialogueMsgTextBlock] Implement DefaultButtonStyleWidget for href  

	NEW: [UHorizonDialogueMsgTextBlock] implement Wait for Dialogue Segment, ex: <text wait="2.5">1234</text> will wail 2.5 second before display msg.    	
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
