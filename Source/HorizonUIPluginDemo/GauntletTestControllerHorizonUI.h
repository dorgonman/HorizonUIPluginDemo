// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GauntletTestController.h"
#include "GauntletTestControllerHorizonUI.generated.h"

/**
 * 
 */
UCLASS()
class UGauntletTestControllerHorizonUI : public UGauntletTestController
{
	GENERATED_BODY()
protected:
	virtual void	OnInit() override;
	virtual void	OnTick(float TimeDelta)		override;
};
