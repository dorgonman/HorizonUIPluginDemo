// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Decorator/HorizonDialogueMsgDecorator.h"
#include "DemoDialogueMsgReplaceDecorator.generated.h"


class UCurveTable;
/**
 * 
 */
UCLASS()
class HORIZONUIPLUGINDEMO_API UDemoDialogueMsgReplaceDecorator : public UHorizonDialogueMsgDecorator
{
	GENERATED_BODY()

public:
	virtual bool BuildSegment_Implementation(UHorizonDialogueMsgTextBlock* InMsgTextBlock,
		int32 InCurrentSegInfoIndex, FHorizonDialogueSegmentInfo& InCurrentSegInfo,
		const TArray<FHorizonDialogueSegmentInfo>& InSegInfos) override;



protected:
	virtual bool TryFindCurveValue(const FName& InRowName, const float InLevel, float& OutValue) const;
protected:
	UPROPERTY(EditAnywhere, BlueprintReadonly, Category = "Content")
	UCurveTable* CurveTable = nullptr;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
	FString SearchText;

};
