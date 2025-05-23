HTT_updateUI = {}


local function GetTrueEngulfingValue()
	local fullText = GetAbilityDescription(20930)
	fullText = string.gsub(fullText,"%D","")
	fullText = string.sub(fullText,-2)
	if string.sub(fullText,1,1) == "0" then
		return string.sub(fullText,-1)
	end
	return fullText
end


function HTT_updateUI.UpdateAlways()

	if HTT_variables.scene~=SCENE_HIDDEN and HTTsavedVars[HTT_variables.currentlySelectedProfile].isAltResourceUIOn then
		HTTHealth:SetHidden(false)
		HTTStamina:SetHidden(false)
		HTTMagicka:SetHidden(false)
		-- HEALTH AND DAMAGE SHIELDS
		local healthBar = HTTHealth:GetNamedChild("healthBar")
		local healthText = HTTHealth:GetNamedChild("healthText")
		local healthTextPercentage = HTTHealth:GetNamedChild("healthTextPercentage")
		local health,maxHealth = GetUnitPower("player",POWERTYPE_HEALTH)
		local shieldBar = HTTHealth:GetNamedChild("shieldBar")
		local shield = GetUnitAttributeVisualizerEffectInfo("player",ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH) or 0
		if shield > maxHealth then shield = maxHealth end
		healthBar:SetDimensions(64,512*(health/maxHealth))
		healthBar:SetTextureCoords(0,1,1-(health/maxHealth),1)
		shieldBar:SetDimensions(64,512*(shield/maxHealth))
		shieldBar:SetTextureCoords(0,1,1-(shield/maxHealth),1)
		if shield ~= 0 then
			healthText:SetText(health.." ["..shield.."]")
		else
			healthText:SetText(health)
		end
		healthTextPercentage:SetText(math.floor((health/maxHealth)*100).."%")
		-- HEALTH AND DAMAGE SHIELDS

		-- BALANCE 
		local balanceBarIcon = HTTHealth:GetNamedChild("balanceBarIcon")
		local balanceBar = HTTHealth:GetNamedChild("balanceBar")
		local balanceBarOutline = HTTHealth:GetNamedChild("balanceBarOutline")
		local balanceBarOutlineOpaque = HTTHealth:GetNamedChild("balanceBarOutlineOpaque")
		local balanceBarIconFrame = HTTHealth:GetNamedChild("balanceBarIconFrame")
		local isBalanceSlotted,balanceSlotID = HTT_functions.checkIfSkillSlotted({40445,31642,40441})
		local balanceSkillID = HTT_variables.slotToAbilityID[balanceSlotID]
		local balanceRemainingDuration = HTT_functions.GetUnitInfo({balanceSkillID},"player")
		balanceRemainingDuration = balanceRemainingDuration/4
		if isBalanceSlotted then
			balanceBar:SetHidden(false)
			balanceBarIcon:SetHidden(false)
			balanceBarOutline:SetHidden(false)
			balanceBarOutlineOpaque:SetHidden(false)
			balanceBarIconFrame:SetHidden(false)
			balanceBar:SetDimensions(32,128*balanceRemainingDuration)
			balanceBar:SetTextureCoords(0,1,1-balanceRemainingDuration,1)
			balanceBarIcon:SetTexture(GetAbilityIcon(balanceSkillID))
		else
			balanceBar:SetHidden(true)
			balanceBarIcon:SetHidden(true)
			balanceBarOutline:SetHidden(true)
			balanceBarOutlineOpaque:SetHidden(true)
			balanceBarIconFrame:SetHidden(true)
		end
		-- BALANCE

		-- MAJOR MENDING 
		local majorMendingIcon = HTTHealth:GetNamedChild("majorMendingIcon")
		local majorMending = HTTHealth:GetNamedChild("majorMending")
		local majorMendingOutline = HTTHealth:GetNamedChild("majorMendingOutline")
		local majorMendingOutlineOpaque = HTTHealth:GetNamedChild("majorMendingOutlineOpaque")
		local majorMendingIconFrame = HTTHealth:GetNamedChild("majorMendingIconFrame")
		local isIgneousSlotted = HTT_functions.checkIfSkillSlotted({32673,29071,29224})
		local majorMendingRemainingDuration = (HTT_variables.majorMendingExpiresAt - GetGameTimeSeconds())/HTT_variables.majorMendingDuration
		if isIgneousSlotted then
			majorMending:SetHidden(false)
			majorMendingIcon:SetHidden(false)
			majorMendingOutline:SetHidden(false)
			majorMendingOutlineOpaque:SetHidden(false)
			majorMendingIconFrame:SetHidden(false)
			majorMending:SetDimensions(32,128*majorMendingRemainingDuration)
			majorMending:SetTextureCoords(0,1,1-majorMendingRemainingDuration,1)
		else
			majorMending:SetHidden(true)
			majorMendingIcon:SetHidden(true)
			majorMendingOutline:SetHidden(true)
			majorMendingOutlineOpaque:SetHidden(true)
			majorMendingIconFrame:SetHidden(true)
		end
		-- MAJOR MENDING
		local staminaBarOutline = HTTStamina:GetNamedChild("staminaBarOutline")
		local staminaBar = HTTStamina:GetNamedChild("staminaBarFill")
		local staminaText = HTTStamina:GetNamedChild("staminaText")
		local staminaTextPercentage = HTTStamina:GetNamedChild("staminaTextPercentage")
		local staminaLine = HTTStamina:GetNamedChild("staminaBarLine")
		local dodgeRollCost = GetAbilityCost(28549)
		local stamina,maxStamina = GetUnitPower("player",POWERTYPE_STAMINA)
		local dodgeRollDuration = HTT_functions.GetUnitInfo({29721},"player")

		-- Fixes the problem seen in IA when maxStamin is set to 0
		-- This avoids a divide by zero error later.
		if maxStamina == 0 then
			maxStamina = 1
		end
		
		dodgeRollDuration = dodgeRollDuration - 2
		if dodgeRollDuration < 0 and dodgeRollCost > 0 then
			staminaLine:SetHidden(false)
			local correction
			if stamina>dodgeRollCost then
				correction = (stamina-dodgeRollCost)/maxStamina
				staminaLine:SetColor(0,0.3,0)
			else
				correction = dodgeRollCost/maxStamina
				staminaLine:SetColor(1,0,0)
			end
			staminaLine:ClearAnchors()
			staminaLine:SetAnchor(BOTTOMLEFT,staminaBarOutline,BOTTOMLEFT,33-(30*correction*correction*correction),(-256)*correction)
		else
			staminaLine:SetHidden(true)
		end
		staminaBar:SetDimensions(64,256*(stamina/maxStamina))
		staminaBar:SetTextureCoords(0,1,1-(stamina/maxStamina),1)
		staminaText:SetText(stamina)
		staminaTextPercentage:SetText(math.floor((stamina/maxStamina)*100).."%")
		-- DODGE ROLL
		local dodgeRollBar = HTTStamina:GetNamedChild("dodgeRollBarFill")
		local dodgeRollStackCounter = HTTStamina:GetNamedChild("dodgeRollStackCounter")
		local dodgeRollRemainingDuration,dodgeRollStacks = HTT_functions.GetUnitInfo({69143},"player")
		dodgeRollRemainingDuration = dodgeRollRemainingDuration/4
		dodgeRollBar:SetDimensions(32,128*dodgeRollRemainingDuration)
		dodgeRollBar:SetTextureCoords(0,1,1-dodgeRollRemainingDuration,1)
		if dodgeRollStacks > 0 then
			dodgeRollStackCounter:SetHidden(false)
			dodgeRollStackCounter:SetText(dodgeRollStacks)
		else
			dodgeRollStackCounter:SetHidden(true)
		end
		-- DODGE ROLL
		local magickaBar = HTTMagicka:GetNamedChild("magickaBarFill")
		local magickaText = HTTMagicka:GetNamedChild("magickaText")
		local magickaTextPercentage = HTTMagicka:GetNamedChild("magickaTextPercentage")
		local magicka,maxMagicka = GetUnitPower("player",POWERTYPE_MAGICKA)
		magickaBar:SetDimensions(64,256*(magicka/maxMagicka))
		magickaBar:SetTextureCoords(0,1,0,magicka/maxMagicka)
		magickaText:SetText(magicka)
		magickaTextPercentage:SetText(math.floor((magicka/maxMagicka)*100).."%")
		local horseStaminaBar = HTTHealth:GetNamedChild("horseStamina")
		local horseStaminaOutline = HTTHealth:GetNamedChild("horseStaminaOutline")
		local horseStaminaOutlineOpaque = HTTHealth:GetNamedChild("horseStaminaOutlineOpaque")
		local horseStaminaIconFrame = HTTHealth:GetNamedChild("horseStaminaIconFrame")
		local horseStaminaIcon = HTTHealth:GetNamedChild("horseStaminaIcon")
		local horseStamina,horseMaxStamina = GetUnitPower("player",POWERTYPE_MOUNT_STAMINA)
		if IsMounted() then
			horseStaminaBar:SetDimensions(32,128*(horseStamina/horseMaxStamina))
			horseStaminaBar:SetTextureCoords(0,1,0,(horseStamina/horseMaxStamina))
			horseStaminaBar:SetHidden(false)
			horseStaminaOutline:SetHidden(false)
			horseStaminaOutlineOpaque:SetHidden(false)
			horseStaminaIconFrame:SetHidden(false)
			horseStaminaIcon:SetHidden(false)
		else
			horseStaminaBar:SetHidden(true)
			horseStaminaOutline:SetHidden(true)
			horseStaminaOutlineOpaque:SetHidden(true)
			horseStaminaIconFrame:SetHidden(true)
			horseStaminaIcon:SetHidden(true)
		end
	else
		HTTHealth:SetHidden(true)
		HTTStamina:SetHidden(true)
		HTTMagicka:SetHidden(true)
	end
	local reflect = HTTReflect:GetNamedChild("reflect")
	local reflectFill = HTTReflect:GetNamedChild("reflectFill")
	if HTT_variables.scene==SCENE_HIDDEN then
		reflect:SetHidden(true)
		reflectFill:SetHidden(true)
	elseif HTTsavedVars[HTT_variables.currentlySelectedProfile].isReflectIndicatorOn then
		if HTT_variables.reflectExpiresAt < GetGameTimeSeconds() then
			reflect:SetHidden(true)
			reflectFill:SetHidden(true)
		else
			reflect:SetHidden(false)
			reflectFill:SetHidden(false)
		end
		reflectFill:SetDimensions(128*((HTT_variables.reflectExpiresAt-GetGameTimeSeconds())/6),64)
		reflectFill:SetTextureCoords(0.5+(HTT_variables.reflectExpiresAt-GetGameTimeSeconds())/12,0.5-((HTT_variables.reflectExpiresAt-GetGameTimeSeconds())/12),0,1)
	end
end

function HTT_combatUpdate()
	local reticleName = HTT:GetNamedChild("TextReticle")
	local reticleBackground = HTT:GetNamedChild("BackgroundReticle")
	if DoesUnitExist("reticleover") and IsUnitAttackable("reticleover") then
		reticleName:SetHidden(false)
		reticleName:SetText(GetUnitName("reticleover"))
		reticleBackground:SetHidden(false)
	else
		reticleName:SetHidden(true)
		reticleBackground:SetHidden(true)
	end
	---------------- Block UI -------------------------------------------
	if HTTsavedVars[HTT_variables.currentlySelectedProfile].isBlockUIOn and HTT_variables.scene~=SCENE_HIDDEN  then
		HTTBlock:SetHidden(false)
		local block = HTTBlock:GetNamedChild("Block")
		if IsBlockActive() then
			block:SetAlpha(1)
		else
			block:SetAlpha(0.2)
		end
		local blockCost = HTTBlock:GetNamedChild("blockCost")
		local blockMitigation = HTTBlock:GetNamedChild("blockMitigation")
		local _,blockCostValue = GetAdvancedStatValue(1)
		local _,_,blockMitigationValue = GetAdvancedStatValue(7)
		blockCost:SetText(math.floor(blockCostValue))
		blockMitigation:SetText(math.floor(blockMitigationValue).."%")
		if (GetItemWeaponType(BAG_WORN,EQUIP_SLOT_MAIN_HAND) == WEAPONTYPE_FROST_STAFF and GetActiveWeaponPairInfo() == ACTIVE_WEAPON_PAIR_MAIN) or (GetItemWeaponType(BAG_WORN,EQUIP_SLOT_BACKUP_MAIN) == WEAPONTYPE_FROST_STAFF and GetActiveWeaponPairInfo() == ACTIVE_WEAPON_PAIR_BACKUP) then
			blockCost:SetColor(24/255,0,242/255)
			blockMitigation:SetColor(24/255,0,242/255)
		else
			blockCost:SetColor(52/255, 235/255, 70/255)
			blockMitigation:SetColor(52/255, 235/255, 70/255)
		end
		if HTTsavedVars[HTT_variables.currentlySelectedProfile].isBlockCostOn then
			blockCost:SetHidden(false)
			blockMitigation:SetHidden(false)
		else
			blockCost:SetHidden(true)
			blockMitigation:SetHidden(true)
		end
	else
		HTTBlock:SetHidden(true)
	end

	-------------------- Block UI ----------------------------------------




	--------------- Stonefist stacks on yourself // Shimmering ---------------------
	
	if HTTsavedVars[HTT_variables.currentlySelectedProfile].classSpecialIsOn and (GetUnitClassId("player") == 1 or GetUnitClassId("player") == 4) and HTT_variables.scene~=SCENE_HIDDEN  then
		HTTOwnStacks:SetHidden(false)
		local width = HTTsavedVars[HTT_variables.currentlySelectedProfile].specialUIWidth
		local ownStacksTimerBar = HTTOwnStacks:GetNamedChild("StackTimerBar")
		local ownStacksTimerText = HTTOwnStacks:GetNamedChild("StackTimerText")
		local circle1 = HTTOwnStacks:GetNamedChild("CircleInner-1")
		local circle2 = HTTOwnStacks:GetNamedChild("CircleInner0")
		local circle3 = HTTOwnStacks:GetNamedChild("CircleInner1")
		local ownRemainingTime = HTT_variables.specialExpireTime[GetUnitClassId("player")]-GetGameTimeSeconds()
		local ownStacks = HTT_variables.specialStacks[GetUnitClassId("player")]
		if ownRemainingTime < 0 then
			ownRemainingTime = 0
		end
		ownStacksTimerText:SetText(HTT_functions.HTT_processTimer((math.floor(ownRemainingTime*10)/10)).."s")
		if ownRemainingTime ~= 0 then
			ownStacksTimerBar:SetDimensions(math.floor(width * 0.77)*(ownRemainingTime/HTT_variables.specialDuration[GetUnitClassId("player")]),10)
			ownStacksTimerBar:SetTextureCoords(0,ownRemainingTime/HTT_variables.specialDuration[GetUnitClassId("player")],0,1)
		else
			ownStacksTimerBar:SetDimensions(0,10)
			ownStacksTimerBar:SetTextureCoords(0,1,0,1)
		end
		if ownStacks == 3 then
			circle3:SetHidden(false)
		else
			circle3:SetHidden(true)
		end
		if ownStacks >= 2 then
			circle2:SetHidden(false)
		else
			circle2:SetHidden(true)
		end
		if ownStacks >= 1 then
			circle1:SetHidden(false)
		else
			circle1:SetHidden(true)
		end
	elseif HTTsavedVars[HTT_variables.currentlySelectedProfile].classSpecialIsOn and GetUnitClassId("player") == 5 and HTT_variables.scene~=SCENE_HIDDEN  then
		HTTOwnStacks:SetHidden(false)
		local width = HTTsavedVars[HTT_variables.currentlySelectedProfile].specialUIWidth
		local height = HTTsavedVars[HTT_variables.currentlySelectedProfile].specialUIHeight
		local countMembers = 0
		local background = HTTOwnStacks:GetNamedChild("EmpowerBackground")
		for i=1, 12 do

			local searchBy = "group"..i
			if not IsUnitGrouped("player") then
				searchBy = "player"
			end
			local bar = HTTOwnStacks:GetNamedChild("EmpowerBar"..i)
			local textInBar = HTTOwnStacks:GetNamedChild("EmpowerTextInBar"..i)
			local icon = HTTOwnStacks:GetNamedChild("EmpowerRoleIcon"..i)
			local timer = HTTOwnStacks:GetNamedChild("EmpowerTimer"..i)
			if (DoesUnitExist("group"..i) and (GetGroupMemberSelectedRole(searchBy) == 1 or (not HTTsavedVars[HTT_variables.currentlySelectedProfile].trackOnlyDD))) or (i==1 and not IsUnitGrouped("player")) then
				bar:SetHidden(false)
				textInBar:SetHidden(false)
				icon:SetHidden(false)
				timer:SetHidden(false)
				countMembers = countMembers + 1
			else
				bar:SetHidden(true)
				textInBar:SetHidden(true)
				icon:SetHidden(true)
				timer:SetHidden(true)
			end
			icon:SetTexture(HTT_variables.roleIcons[GetGroupMemberSelectedRole(searchBy)])
			textInBar:SetText(GetUnitName(searchBy))
			timeRemaining = HTT_functions.GetUnitInfo({61737},searchBy)
			if timeRemaining > 5 then
				timeRemaining = 5
			end
			timer:SetText((math.floor(timeRemaining*10)/10).."s")
			if timeRemaining <= 0 then
				bar:SetDimensions(width*0.75,height/3)
				bar:SetTextureCoords(0,1,0,1)
				bar:SetColor(50,50,51,0.5)
			else
				bar:SetDimensions(width*(0.75)*(timeRemaining/5),height/3)
				bar:SetTextureCoords(0,timeRemaining/5,0,1)
				bar:SetColor(unpack(HTTsavedVars[HTT_variables.currentlySelectedProfile].classSpecialColor))
			end
		end
		background:SetDimensions(width,(countMembers*(height/2.7))+(height/1.6))
	else
		HTTOwnStacks:SetHidden(true)
	end
	--------------- Stonefist stacks on yourself --------------------- 

	---------------- Debuffs -------------------
	if HTTsavedVars[HTT_variables.currentlySelectedProfile].isDebuffUIOn and HTT_variables.scene~=SCENE_HIDDEN  then
		HTT:SetHidden(false)
		local width = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffUIWidth
		local height = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffUIHeight
		local scale = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffUIScale
		for _,trackerID in pairs(HTTsavedVars[HTT_variables.currentlySelectedProfile].orderOfDebuffs) do
			local tracker = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffTable[trackerID]
			local textInBar = HTT:GetNamedChild("TextInBarReticle"..trackerID)
			local durationTimer = HTT:GetNamedChild("DurationTimerReticle"..trackerID)
			local durationBar = HTT:GetNamedChild("DurationBarReticle"..trackerID)
			local icon = HTT:GetNamedChild("IconReticle"..trackerID)
			if DoesUnitExist("reticleover") and IsUnitAttackable("reticleover") and tracker.turnedOn then
				if tracker.name == "Weapon Skill" then
					remainingTime = tracker.expiresAt - GetGameTimeSeconds()
					stacks = 1
					duration = tracker.duration	
				else
					remainingTime,stacks,_,abilityID = HTT_functions.GetUnitInfo(tracker.IDs,"reticleover")
					duration = (tracker.duration[GetUnitName("reticleover")] or 0)
				end
				if tracker.name == "Weapon Skill" then
					local crusher = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffTable["Crusher"] or nil
					if crusher ~= nil and (crusher.expiresAt[GetUnitName("reticleover")] or 0) > GetGameTimeSeconds() then
						tracker.text = HTT_functions.crushersLeft(remainingTime,(crusher.expiresAt[GetUnitName("reticleover")] or 0) - GetGameTimeSeconds()).." crushers left"
					else
						tracker.text = HTT_functions.crushersLeft(remainingTime,0).." crushers left"
					end
				end	
				durationTimer:SetHidden(false)
				durationBar:SetHidden(false)
				icon:SetHidden(false)
				textInBar:SetHidden(false)
				if remainingTime > 0 then
					durationTimer:SetText(HTT_functions.HTT_processTimer((math.floor(remainingTime*10)/10)).."s")
				else
					durationTimer:SetText("0.0s")
				end
				if remainingTime ~= 0 then
					durationBar:SetDimensions(width*0.75*(remainingTime/duration),height)
					durationBar:SetTextureCoords(0,remainingTime/duration,0,1)
					if stacks == 3 then
						durationBar:SetColor(unpack(tracker.color3))
					elseif stacks == 2 or (tracker.name == "Off-Balance/Off-Balance Immunity" and abilityID==134599) then
						durationBar:SetColor(unpack(tracker.color2))
					else
						durationBar:SetColor(unpack(tracker.color))
					end
				end
				if  remainingTime <= 0 then
					textInBar:SetText(tracker.textWhenMissing)
					durationBar:SetColor(50,50,51,0.5)
					durationBar:SetTextureCoords(0,1,0,1)
					durationBar:SetDimensions(width*0.75,height)
				elseif tracker.name == "Engulfing Flames" then
					textInBar:SetText(GetTrueEngulfingValue().."% fire damage")
				elseif tracker.name == "Alkosh" and HTT_variables.alkoshHits[HTT_variables.targetNameUnitID[GetUnitName("reticleover")]] then
					textInBar:SetText(HTT_variables.alkoshHits[HTT_variables.targetNameUnitID[GetUnitName("reticleover")]].." penetration")
				elseif tracker.name == "Alkosh" then
					textInBar:SetText("unknown penetration")
				elseif tracker.name == "Stagger" then
					textInBar:SetText((stacks*65).." damage increase")
				elseif tracker.name == "Off-Balance/Off-Balance Immunity" and abilityID==134599 then
					textInBar:SetText(HTTsavedVars[HTT_variables.currentlySelectedProfile].offBalanceImmunityText)
				else
					textInBar:SetText(tracker.text)
				end
			else
				durationTimer:SetHidden(true)
				durationBar:SetHidden(true)
				icon:SetHidden(true)
				textInBar:SetHidden(true)
			end
		end
	else
		HTT:SetHidden(true)
	end
	---------------- Debuffs -------------------


	--------------- Boss Debuffs ----------------------

	if HTTsavedVars[HTT_variables.currentlySelectedProfile].isBossDebuffUIOn and HTT_variables.scene~=SCENE_HIDDEN  then
		local width = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffBossUIWidth
		local height = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffBossUIHeight
		local scale = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffBossUIScale
		for i=1, MAX_BOSSES do
			_G["HTTBoss"..i]:SetHidden(false)
			local bossName = _G["HTTBoss"..i]:GetNamedChild("TextBoss"..i)
			local bossBackground = _G["HTTBoss"..i]:GetNamedChild("BackgroundBoss"..i)
			if DoesUnitExist("boss"..i) then
				_G["HTTBoss"..i]:SetHidden(false)
				bossName:SetHidden(false)
				bossName:SetText(GetUnitName("boss"..i))
				bossBackground:SetHidden(false)

			for _,trackerID in pairs(HTTsavedVars[HTT_variables.currentlySelectedProfile].orderOfDebuffs) do
			local tracker = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffTable[trackerID]
			local textInBar = _G["HTTBoss"..i]:GetNamedChild("TextInBarBoss"..trackerID..i)
			local durationTimer = _G["HTTBoss"..i]:GetNamedChild("DurationTimerBoss"..trackerID..i)
			local durationBar = _G["HTTBoss"..i]:GetNamedChild("DurationBarBoss"..trackerID..i)
			local icon = _G["HTTBoss"..i]:GetNamedChild("IconBoss"..trackerID..i)
			if tracker.turnedOnBoss then
				if tracker.name == "Weapon Skill" then
					remainingTime = tracker.expiresAt - GetGameTimeSeconds()
					stacks = 1
					duration = tracker.duration		
				else
					
					remainingTime,stacks,_,abilityID = HTT_functions.GetUnitInfo(tracker.IDs,"boss"..i)
					duration = (tracker.duration[GetUnitName("boss"..i)] or 0)
				end
				if tracker.name == "Weapon Skill" then
					local crusher = HTTsavedVars[HTT_variables.currentlySelectedProfile].debuffTable["Crusher"] or nil
					if crusher ~= nil and (crusher.expiresAt[GetUnitName("boss"..i)] or 0) > GetGameTimeSeconds() then
						tracker.text = HTT_functions.crushersLeft(remainingTime,(crusher.expiresAt[GetUnitName("boss"..i)] or 0) - GetGameTimeSeconds()).." crushers left"
					else
						tracker.text = HTT_functions.crushersLeft(remainingTime,0).." crushers left"
					end
				end	
				durationTimer:SetHidden(false)
				durationBar:SetHidden(false)
				icon:SetHidden(false)
				textInBar:SetHidden(false)
				if remainingTime > 0 then
					durationTimer:SetText(HTT_functions.HTT_processTimer((math.floor(remainingTime*10)/10)).."s")
				else
					durationTimer:SetText("0.0s")
				end
				if remainingTime ~= 0 then
					durationBar:SetDimensions(width*0.75*(remainingTime/duration),height)
					durationBar:SetTextureCoords(0,remainingTime/duration,0,1)
					if stacks == 3 then
						durationBar:SetColor(unpack(tracker.color3))
					elseif stacks == 2 or (tracker.name == "Off-Balance/Off-Balance Immunity" and abilityID==134599) then
						durationBar:SetColor(unpack(tracker.color2))
					else
						durationBar:SetColor(unpack(tracker.color))
					end
				end
				if  remainingTime <= 0 then
					textInBar:SetText(tracker.textWhenMissing)
					durationBar:SetColor(50,50,51,0.5)
					durationBar:SetTextureCoords(0,1,0,1)
					durationBar:SetDimensions(width*0.75,height)
				elseif tracker.name == "Engulfing Flames" then
					textInBar:SetText(GetTrueEngulfingValue().."% fire damage")
				elseif tracker.name == "Alkosh" and HTT_variables.alkoshHits[HTT_variables.targetNameUnitID[GetUnitName("boss"..i)]] then
					textInBar:SetText(HTT_variables.alkoshHits[HTT_variables.targetNameUnitID[GetUnitName("boss"..i)]].." penetration")
				elseif tracker.name == "Alkosh" then
					textInBar:SetText("unknown penetration")
				elseif tracker.name == "Stagger" then
					textInBar:SetText((stacks*65).." damage increase")
				elseif tracker.name == "Off-Balance/Off-Balance Immunity" and abilityID==134599 then
					textInBar:SetText(HTTsavedVars[HTT_variables.currentlySelectedProfile].offBalanceImmunityText)
				else
					textInBar:SetText(tracker.text)
				end
			else
				durationTimer:SetHidden(true)
				durationBar:SetHidden(true)
				icon:SetHidden(true)
				textInBar:SetHidden(true)
			end
		end	
			else
				bossName:SetHidden(true)
				bossBackground:SetHidden(true)
				_G["HTTBoss"..i]:SetHidden(true)
			end
		end	
	else
		for i=1, MAX_BOSSES do
			_G["HTTBoss"..i]:SetHidden(true)
		end
	end

	--------------- Boss Debuffs ----------------------


	------------------ Self Buffs --------------------------------
	if HTTsavedVars[HTT_variables.currentlySelectedProfile].isBuffUIOn and HTT_variables.scene~=SCENE_HIDDEN  then
		local width = HTTsavedVars[HTT_variables.currentlySelectedProfile].buffUIWidth
		local height = HTTsavedVars[HTT_variables.currentlySelectedProfile].buffUIHeight
		local scale = HTTsavedVars[HTT_variables.currentlySelectedProfile].buffUIScale
		HTTSelfBuffs:SetHidden(false)
		for _,trackerID in pairs(HTTsavedVars[HTT_variables.currentlySelectedProfile].orderOfBuffs) do
			local tracker = HTTsavedVars[HTT_variables.currentlySelectedProfile].buffTable[trackerID]
			local textInBar = HTTSelfBuffs:GetNamedChild("SelfBuffTextInBar"..trackerID)
			local durationTimer = HTTSelfBuffs:GetNamedChild("SelfBuffDurationTimer"..trackerID)
			local durationBar = HTTSelfBuffs:GetNamedChild("SelfBuffDurationBar"..trackerID)
			local icon = HTTSelfBuffs:GetNamedChild("SelfBuffIcon"..trackerID)
			if tracker.turnedOn then
				if tracker.name == "Dragon Blood" then
					remainingTime = tracker.expiresAt - GetGameTimeSeconds()
					if remainingTime > 0 then
						isActive = true
					else
						isActive = false
					end
				else
					remainingTime,_,isActive = HTT_functions.GetUnitInfo(tracker.IDs,"player")
				end
				duration = tracker.duration
				durationTimer:SetHidden(false)
				durationBar:SetHidden(false)
				icon:SetHidden(false)
				textInBar:SetHidden(false)
				if remainingTime > 0 then
					durationTimer:SetText(HTT_functions.HTT_processTimer((math.floor(remainingTime*10)/10)).."s")
				else
					durationTimer:SetText("0.0s")
				end
				if isActive then
					durationBar:SetColor(unpack(tracker.color))
					if remainingTime > 0 then
						durationBar:SetDimensions(width*0.75*(remainingTime/tracker.duration),height)
						durationBar:SetTextureCoords(0,remainingTime/tracker.duration,0,1)
					else
						durationBar:SetDimensions(width*0.75,height)
					end
				end
				if  remainingTime <= 0 and not isActive then
					textInBar:SetText(tracker.textWhenMissing)
					durationBar:SetColor(50,50,51,0.5)
					durationBar:SetTextureCoords(0,1,0,1)
					durationBar:SetDimensions(width*0.75,height)
				else
					if tracker.name == "Puncturing Remedy" and HTT_variables.masterSnB ~= nil then
						textInBar:SetText("+"..HTT_variables.masterSnB.." armor")
					else
						textInBar:SetText(tracker.text)
					end
				end
				else
					durationTimer:SetHidden(true)
					durationBar:SetHidden(true)
					icon:SetHidden(true)
					textInBar:SetHidden(true)
				end
			end
	else
		HTTSelfBuffs:SetHidden(true)
	end

	------------------ Self Buffs --------------------------------

	------------------ Cooldowns --------------------------------
	if HTTsavedVars[HTT_variables.currentlySelectedProfile].isCooldownUIOn and HTT_variables.scene~=SCENE_HIDDEN  then
		local width = HTTsavedVars[HTT_variables.currentlySelectedProfile].cooldownUIWidth
		local height = HTTsavedVars[HTT_variables.currentlySelectedProfile].cooldownUIHeight
		local scale = HTTsavedVars[HTT_variables.currentlySelectedProfile].cooldownUIScale
		HTTCooldowns:SetHidden(false)	
		for _,trackerID in pairs(HTTsavedVars[HTT_variables.currentlySelectedProfile].orderOfCooldowns) do
			local tracker = HTTsavedVars[HTT_variables.currentlySelectedProfile].cooldownTable[trackerID]
			local textInBar = HTTCooldowns:GetNamedChild("CooldownTextInBar"..trackerID)
			local durationTimer = HTTCooldowns:GetNamedChild("CooldownDurationTimer"..trackerID)
			local durationBar = HTTCooldowns:GetNamedChild("CooldownsDurationBar"..trackerID)
			local icon = HTTCooldowns:GetNamedChild("CooldownIcon"..trackerID)
			if tracker.turnedOn then
			remainingTime = tracker.expiresAt - GetGameTimeSeconds()
			duration = tracker.duration
			durationTimer:SetHidden(false)
			durationBar:SetHidden(false)
			icon:SetHidden(false)
			textInBar:SetHidden(false)
			if remainingTime > 0 then
				durationTimer:SetText(HTT_functions.HTT_processTimer((math.floor(remainingTime*10)/10)).."s")
			else
				durationTimer:SetText("0.0s")
			end	
			durationBar:SetColor(unpack(tracker.color))
			if remainingTime > 0 then
				durationBar:SetTextureCoords(0,remainingTime/duration,0,1)
				durationBar:SetDimensions(width*0.75*(remainingTime/duration),height)
			else
				durationBar:SetDimensions(width*0.75,height)
			end
			if  remainingTime <= 0 then
				textInBar:SetText(tracker.textWhenMissing)
				durationBar:SetTextureCoords(0,1,0,1)
				durationBar:SetColor(50,50,51,0.5)
				durationBar:SetDimensions(width*0.75,height)
			else
				textInBar:SetText(tracker.text)
			end
			else
				durationTimer:SetHidden(true)
				durationBar:SetHidden(true)
				icon:SetHidden(true)
				textInBar:SetHidden(true)
			end
		end
	else
		HTTCooldowns:SetHidden(true)
	end

	------------------ Cooldowns --------------------------------

	------------------- Synergies ----------------------------------

	if HTTsavedVars[HTT_variables.currentlySelectedProfile].isSynergiesUIOn and HTT_variables.scene~=SCENE_HIDDEN  then
		local width = HTTsavedVars[HTT_variables.currentlySelectedProfile].synergiesUIWidth
		local height = HTTsavedVars[HTT_variables.currentlySelectedProfile].synergiesUIHeight
		local scale = HTTsavedVars[HTT_variables.currentlySelectedProfile].synergiesUIScale
		HTTSynergies:SetHidden(false)
		for _,trackerID in pairs(HTTsavedVars[HTT_variables.currentlySelectedProfile].orderOfSynergies) do
			local tracker = HTTsavedVars[HTT_variables.currentlySelectedProfile].synergiesTable[trackerID]
			local textInBar = HTTSynergies:GetNamedChild("SynergiesTextInBar"..trackerID)
			local durationTimer = HTTSynergies:GetNamedChild("SynergiesDurationTimer"..trackerID)
			local durationBar = HTTSynergies:GetNamedChild("SynergiesDurationBar"..trackerID)
			local icon = HTTSynergies:GetNamedChild("SynergiesIcon"..trackerID)
			if tracker.turnedOn then
			remainingTime = tracker.expiresAt - GetGameTimeSeconds()
			durationTimer:SetHidden(false)
			durationBar:SetHidden(false)
			icon:SetHidden(false)
			textInBar:SetHidden(false)
			if remainingTime > 0 then
				durationTimer:SetText(HTT_functions.HTT_processTimer((math.floor(remainingTime*10)/10)).."s")
			else
				durationTimer:SetText("0.0s")
			end
			durationBar:SetColor(unpack(tracker.color))
			if remainingTime > 0 then
				durationBar:SetTextureCoords(0,remainingTime/20,0,1)
				durationBar:SetDimensions(width*0.75*(remainingTime/20),height)
			else
				durationBar:SetDimensions(width*0.75,height)
			end
			if  remainingTime <= 0 then
				textInBar:SetText(tracker.textWhenMissing)
				durationBar:SetTextureCoords(0,1,0,1)
				durationBar:SetColor(50,50,51,0.5)
				durationBar:SetDimensions(width*0.75,height)
			else
				textInBar:SetText(tracker.text)
			end
			else
				durationTimer:SetHidden(true)
				durationBar:SetHidden(true)
				icon:SetHidden(true)
				textInBar:SetHidden(true)
			end
		end
	else
		HTTSynergies:SetHidden(true)
	end

	----------------------- Synergies -----------------------------------





end

