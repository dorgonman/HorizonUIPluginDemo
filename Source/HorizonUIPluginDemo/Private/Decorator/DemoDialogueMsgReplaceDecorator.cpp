// Fill out your copyright notice in the Description page of Project Settings.


#include "Decorator/DemoDialogueMsgReplaceDecorator.h"

bool UDemoDialogueMsgReplaceDecorator::PreRun_Implementation(UHorizonDialogueMsgTextBlock* InMsgTextBlock,
	FHorizonDialogueBlockInfo& InDialogueBlockInfo, FHorizonDialogueSegmentInfo& InSegInfo)
{
	if(!SearchText.IsEmpty())
	{ 
		InDialogueBlockInfo.MsgText.ReplaceInline(*SearchText, *ReplacementText);
		return true;
	}
	return false;
}
