// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Decorator/HorizonDialogueMsgDecorator.h"
#include "DemoDialogueMsgReplaceDecorator.generated.h"

/**
 * 
 */
UCLASS()
class HORIZONUIPLUGINDEMO_API UDemoDialogueMsgReplaceDecorator : public UHorizonDialogueMsgDecorator
{
	GENERATED_BODY()
	virtual bool PreRun_Implementation(UHorizonDialogueMsgTextBlock* InMsgTextBlock,
			FHorizonDialogueBlockInfo& InDialogueBlockInfo,
			FHorizonDialogueSegmentInfo& InSegInfo) override;

public:
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
	FString SearchText;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
	FString ReplacementText;
};
