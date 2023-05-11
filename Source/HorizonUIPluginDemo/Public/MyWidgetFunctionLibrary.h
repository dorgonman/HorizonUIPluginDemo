// Crated by dorgon, All Rights Reserved.
// email: dorgonman@hotmail.com
// blog: dorgon.horizon-studio.net

#pragma once

// Core
#include "Misc/EngineVersionComparison.h"

// UMG
#include "Components/Image.h"

// HorizonUI
#include "Widget/Components/HorizonDialogueMsgTextBlock.h"
#include "Widget/Components/HorizonFlipbookWidget.h"
#include "Widget/HorizonWidgetFunctionLibrary.h"
// Demo
#include "MyWidgetFunctionLibrary.generated.h"


UCLASS()
class UMyWidgetFunctionLibrary : public UBlueprintFunctionLibrary {
private:
	GENERATED_BODY()
public:

	UFUNCTION(BlueprintCallable, Category = "HorizonPlugin")
	static void SetImage(UImage* InImage, const FSoftObjectPath& InResourceObjectPath)
	{
		if (InImage)
		{
			auto pObj = InResourceObjectPath.TryLoad();
			if (pObj)
			{
				
#if UE_VERSION_OLDER_THAN(5,2,0)
				FSlateBrush newBrush = InImage->Brush;
#else
				FSlateBrush newBrush = InImage->GetBrush();
#endif
				newBrush.SetResourceObject(pObj);
				InImage->SetBrush(newBrush);

			}
			else
			{
				InImage->SetVisibility(ESlateVisibility::Collapsed);
			}
		}
	}



};

