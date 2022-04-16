// Fill out your copyright notice in the Description page of Project Settings.


#include "Decorator/DemoDialogueMsgReplaceDecorator.h"
#include "Engine/CurveTable.h"
#include "Kismet/KismetStringLibrary.h"


bool UDemoDialogueMsgReplaceDecorator::BuildSegment_Implementation(UHorizonDialogueMsgTextBlock* InMsgTextBlock,
	int32 InCurrentSegInfoIndex, FHorizonDialogueSegmentInfo& InCurrentSegInfo,
	const TArray<FHorizonDialogueSegmentInfo>& SegInfos)
{
	bool bResult = false;

	do 
	{

		if (InCurrentSegInfo.EventPayload.IsEmpty()) break;
		if (SearchText.IsEmpty()) break;
		if (CurveTable)
		{
			TArray<FString> parameterStrings;
			InCurrentSegInfo.EventPayload.ParseIntoArray(parameterStrings, TEXT(","), true);
			if(parameterStrings.Num() < 2) break;

			const FName rowName(parameterStrings[0]);
			const float level = FCString::Atof(*parameterStrings[1]);
			float value = 0.0f;
			if (TryFindCurveValue(rowName, level, value))
			{
				InCurrentSegInfo.Text.ReplaceInline(*SearchText, *FString::SanitizeFloat(value));
				bResult = true;
			}
		
		}
		else
		{
			InCurrentSegInfo.Text.ReplaceInline(*SearchText, *InCurrentSegInfo.EventPayload);
			bResult = true;
		}
	


	} while (0);

	return bResult;
}

bool UDemoDialogueMsgReplaceDecorator::TryFindCurveValue(const FName& InRowName, const float InLevel, float& OutValue) const
{
	bool bResult = false;

	do 
	{
		if(!CurveTable) break;
		FRealCurve* pRealCurve = CurveTable->FindCurve(InRowName, FString(TEXT("")));
		if (!pRealCurve) break;
		OutValue = pRealCurve->Eval(InLevel);
		bResult = true;
	} while (0);
	

	return bResult;
}
