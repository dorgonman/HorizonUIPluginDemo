----------------------------------------------
              HorizonUIPlugin
                  1.2.4
         http://dorgon.horizon-studio.net
          	dorgonman@hotmail.com
----------------------------------------------

-----------------------
System Requirements
-----------------------

tested UnrealEngine version: 4.11, 4.12, 4.14, 4.15


-----------------------
Installation Guide
-----------------------

put HorizonUIPlugin into YOUR_PROJECT/Plugins folder, 
and then add module to your project 
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

<text color="#77FF77AA" shadowColor="#FF0000FF" shadowOffset="[4,3]">This is rich text simple test:</text>
<br/>
<text color="#FF0000AA">This is strawberry:</text><img filePath="Texture2D'/Game/Item/I_C_Strawberry.I_C_Strawberry'" size="[100, 100]" /><br/>
<text color="#0000FFFF">This is Watermellon:</text><img color="#FF00FF77" filePath="/Game/Item/I_C_Watermellon" size="[100, 100]" /> <br/>
<text color="#FFFF00FF">This is animated man using material:</text><img filePath="Material'/Game/Material/mat_flipbook.mat_flipbook'" size="[100, 100]" /> <br/>


note: both Texture2D'/Game/Item/I_C_Strawberry.I_C_Strawberry' and  /Game/Item/I_C_Strawberry.I_C_Strawberry can work correctly

example 1: rich text simple using style feature

<text style="MyStyle0">This is rich text test using style:</text>
<br/>

<text style="MyStyle1">This is strawberry:</text><img style="MyStyle2" /><br/>

<text style="MyStyle3">This is Watermellon:</text><img style="MyStyle4"/> <br/>


<text style="MyStyle5">This is animated man using material:</text><mat style="MyStyle6" /> <br/>

<text style="MyStyle7">HorizonFlipbookWidget(use tag pfb) Only Supported by using style:</text><pfb style="MyStyle7" /> <br/>


MyStyle0 ~ MyStyle7 is a array that can be setted in UMG editor under HorizonPlugin/Style section
ref: https://drive.google.com/file/d/0BwANUSGaSQn-SlJZWUF5LWJHQTA/view?usp=sharing

By using style="YOUR_STYLE_NAME", you can use the style setting for your RichText block. 
*note: HorizonFlipbookWidget can only use style to work correctly. (Use filePath will not compute UV and Size for HorizonFlipbookWidget correctly.)

example 2: rich text font
<text>This is Default Font</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Regular" fontSize="30">This is Roboto Regular fontSize=30</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Italic" color="#FF0000AA">This is Roboto Italic</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Bold Italic"  fontSize="40" color="#FF3366AA">This is Roboto Bold Italic fontSize=40</text><br/>
<text fontPath="/Engine/EngineFonts/Roboto" fontType="Light" color="#FFFF00AA">This is Roboto Light</text><br/>
<text fontPath="/Engine/EngineFonts/RobotoTiny" fontType="Light" color="#FF0A40AA">This is RobotoTinyLight</text><br/>



example 3: padding

<text fontSize="55">Test case:</text> 
<text padding-right="5" padding-top="20">
 <text padding-left="5">padding text block</text>
 <img filePath="/Game/Material/mat_flipbook"/>
 <img filePath="/Game/Item/I_C_Watermellon" size="[100,100]" />
</text>
<text>after padding</text>

example 4: special character
following character will be replaced:
&nbsp;  == " "
&quot;  == "\"
&amp; ==  "&"
&apos;  =="'"
&lt;  == "<"
&gt;   ==">"

sample:
<text> &nbsp;  == " "</text><br/>
<text> &quot;  == "\"</text><br/>
<text> &amp;  ==  "&"</text><br/>
<text> &apos;"  =="'"</text><br/>
<text> &lt;  == "&lt;"</text><br/>
<text> &gt;   =="&gt; "</text><br/>
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
1.3.0
- UPDATE: update to engine 4.16
- NEW: implement StartDialogue and StopDialogue for HorizonDialogueMsgTextBlock

1.2.4
- UPDATE: update to engine 4.15

1.2.1
- FIX:
	1. The times HorizonFlipbookWidget NumOfLoop for flipbook animation plays incorrectly.
	
1.2.0
- NEW: HorizonFlipbookWidget: 
		Add NumOfLoop that you can specify how much loop this Flipbook will play.
		Expose Blueprint Method: ResetAnimation, PlayAnimation, StopAnimation, PauseAnimation, ResumeAnimation.

1.1.0
- NEW: Add style feature for HorizonDialogueMsgTextBlock
- FIX: 
	1. Fix Crash when putting a flipbook nested in a button.
	2. Fix ensureMsgf check fail by set widget outer to WidgetTree.
	3. Fix some display bug in UMG Hierarchy. Don't call RebuildSegmentInfoList if it is created from palette. 
- REFACTOR: 
	1. Move HorizonUI module from Source/HorizonUI to Source/Runtime/HorizonUI
	2. Rename Blueprint UPROPERTY Category for class members in HorizonFlipbookWidget and HorizonDialogueMsgTextBlock
	3. Minor code refactoring
1.0.0
- NEW: First Version including core features.
	 	1. HorizonFlipbookWidget
	 	2. HorizonDialogueMsgTextBlock
