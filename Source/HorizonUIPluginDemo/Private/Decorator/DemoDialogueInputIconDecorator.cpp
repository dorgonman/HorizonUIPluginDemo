// Fill out your copyright notice in the Description page of Project Settings.


#include "Decorator/DemoDialogueInputIconDecorator.h"
#include "Framework/Application/SlateApplication.h"
#include "MyWidgetFunctionLibrary.h"
#include "Widget/Components/HorizonDialogueMsgTextBlock.h"
#include "Components/Image.h"
#include "PaperSprite.h"
#include "Components/CanvasPanelSlot.h"

bool UDemoDialogueInputIconDecorator::Run_Implementation(UHorizonDialogueMsgTextBlock* InMsgTextBlock,
	FHorizonDialogueBlockInfo& InDialogueBlockInfo,
	FHorizonDialogueSegmentInfo& InSegInfo)
{
	bool bResult = false;

	auto pImage = Cast<UImage>(InDialogueBlockInfo.WidgetWeakPtr.Get());
	if (pImage && InMsgTextBlock)
	{
		InputIconDataTableRowHandle.RowName = *InSegInfo.EventPayload;
		auto pInputIcon = InputIconDataTableRowHandle.GetRow<FDemoInputImageTableRow>("");
		if (pInputIcon)
		{
#if PLATFORM_WINDOWS
			auto genericApplication = FSlateApplication::Get().GetPlatformApplication();
			if (genericApplication.Get() != nullptr && genericApplication->IsGamepadAttached())
			{
				UMyWidgetFunctionLibrary::SetImage(pImage, pInputIcon->XBoxController);
			}
			else
			{
				UMyWidgetFunctionLibrary::SetImage(pImage, pInputIcon->KeyboardAndMouse);
			}
// #elif PLATFORM_XBOXONE
// 			UMyWidgetFunctionLibrary::SetImage(pImage, pInputIcon->XBoxController);
#endif
			if (!InSegInfo.ImageSize.IsSet())
			{
				auto pPaperSprite = Cast<UPaperSprite>(pImage->Brush.GetResourceObject());
				if (pPaperSprite)
				{
					FSlateAtlasData&& atlasData = pPaperSprite->GetSlateAtlasData();
					UCanvasPanelSlot* canvasPanelSlot = Cast<UCanvasPanelSlot>(pImage->Slot);
					canvasPanelSlot->SetSize(atlasData.GetSourceDimensions() * IconSizeScale);
					auto currentPos = canvasPanelSlot->GetPosition();
					currentPos.Y += IconOffset;
					canvasPanelSlot->SetPosition(currentPos);
				}
			}
		}
		else
		{
			if (!InputIconDataTableRowHandle.RowName.IsNone())
			{
				ensureMsgf(false, TEXT("oops! Can't find inputIcon %s"), *InputIconDataTableRowHandle.RowName.ToString());
			}
		}
		bResult = true;
	}

	return bResult;
}
