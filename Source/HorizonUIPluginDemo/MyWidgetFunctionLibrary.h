// Crated by dorgon, All Rights Reserved.
// email: dorgonman@hotmail.com
// blog: dorgon.horizon-studio.net

#pragma once
#include "UMG.h"
#include "Horizon/Widget/HorizonFlipbookWidget.h"
#include "Horizon/Widget/HorizonWidgetFunctionLibrary.h"
#include "MyWidgetFunctionLibrary.generated.h"


UCLASS()
class UMyWidgetFunctionLibrary : public UBlueprintFunctionLibrary {
private:
	GENERATED_BODY()
public:


	UFUNCTION(BlueprintCallable, Category = "HorizonPlugin|WidgetHelper")
	static void SetFlipbook(UHorizonFlipbookWidget* flipbookWidget, const TArray<FVector2D>& sourceUV,
			const TArray<FVector2D>& sourceSize)
	{
		flipbookWidget->SetFlipbookSourceUV(sourceUV);
		flipbookWidget->SetFlipbookSourceSize(sourceSize);
	};

};