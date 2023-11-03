// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Decorator/HorizonDialogueMsgDecorator.h"
#include "Engine/DataTable.h"
#include "DemoDialogueInputIconDecorator.generated.h"



USTRUCT(BlueprintType)
struct HORIZONUIPLUGINDEMO_API FDemoInputImageTableRow : public FTableRowBase
{
	GENERATED_BODY()
public:

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content", meta = (AllowPrivateAccess = "true", 
		DisplayThumbnail = "true", AllowedClasses = "/Script/Engine.Texture, /Script/Engine.MaterialInterface, /Script/Paper2D.PaperSprite, /Script/Paper2D.PaperFlipbook", 
		DisallowedClasses = "/Script/MediaAssets.MediaTexture"))
	FSoftObjectPath KeyboardAndMouse;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content", meta = (AllowPrivateAccess = "true", 
		DisplayThumbnail = "true", 
		AllowedClasses = "/Script/Engine.Texture, /Script/Engine.MaterialInterface, /Script/Paper2D.PaperSprite, /Script/Paper2D.PaperFlipbook", 
		DisallowedClasses = "/Script/MediaAssets.MediaTexture"))
	FSoftObjectPath XBoxController;


};


/**
 * 
 */
UCLASS()
class HORIZONUIPLUGINDEMO_API UDemoDialogueInputIconDecorator : public UHorizonDialogueMsgDecorator
{
	GENERATED_BODY()
public:
	virtual bool Run_Implementation(UHorizonDialogueMsgTextBlock* InMsgTextBlock,
			FHorizonDialogueBlockInfo& InDialogueBlockInfo,
			FHorizonDialogueSegmentInfo& InSegInfo);


public:
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
	float IconSizeScale = 1.0f;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
	float IconOffset = 0.0f;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
	FDataTableRowHandle InputIconDataTableRowHandle;
};
