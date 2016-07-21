--[[ =================================================================
    Description:
        BagTips gives you a peek at what is in a particular bag
        without having to open the bag

    Dependencies:
        None

    Credits:
        A big 'Thank You' to all the people at Blizzard Entertainment
        for making World of Warcraft.
    ================================================================= --]]

-- Send message to the default chat frame
    function BagTips_Message( msg, prefix )
        -- Initialize
        local prefixText = "";

        -- Add application prefix
        if ( prefix and true ) then
            prefixText = C_GREEN.."BT: "..C_CLOSE;
        end;

        -- Send message to chatframe
        DEFAULT_CHAT_FRAME:AddMessage( prefixText..( msg or "" ) );
    end;

-- Add bag contents to tooltip
    function BagTips_OnEnter( self )
        -- Initialize
        local tooltip = GameTooltip;
        local items = items;
        local bagName = self:GetName() or "BankFrameBag"..self:GetID();
        local bagID = BT_BAG_IDS[bagName];
        local hasContent = false;
        local itemLink, itemid, itemCount, itemName, itemQuality, itemTexture, r, g, b, hex, _;
        local vendorvalue = 0;

        -- Clear data
        wipe( items );

        -- Execute original code
        BT_Hooks[bagName]( self );

        -- Group items by name
        for slotID = 1, GetContainerNumSlots( bagID ) do
            -- Get itemlink
            itemLink = GetContainerItemLink( bagID, slotID );

            -- Retrieve item information
            if ( itemLink ) then
                _, itemid = strsplit( ":", itemLink );

                itemid = tonumber( itemid );
                _, itemCount = GetContainerItemInfo( bagID, slotID );
                itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, sellPrice = GetItemInfo( itemid );

                if ( not items[itemid] ) then
                    items[itemid] = { count = 0, name = itemName, quality = itemQuality, texture = itemTexture, price = ( sellPrice or 0 ) };
                end;

                if ( strfind( itemLink, "battlepet:" ) ) then
                    local _, icon = C_PetJournal.GetPetInfoBySpeciesID( itemid );
                    items[itemid].name = strmatch( itemLink, "%[(.+)%]" );
                    items[itemid].quality = 3;
                    items[itemid].texture = icon; 
                end;

                if ( itemCount > 0 ) then
                    hasContent = true;
                    items[itemid].count = ( items[itemid].count or 0 ) + itemCount;
                end;
            end;
        end;

        -- Add items to tooltip
        tooltip:AddLine( "|n"..BT_CONTENTS );
        if ( hasContent ) then
            for key, value in pairs( items ) do
                r, g, b, hex = GetItemQualityColor( value.quality );
                tooltip:AddDoubleLine( "  |T"..value.texture..":0|t "..value.name, value.count, r, g, b );
                vendorvalue = vendorvalue + ( value.count * value.price );
            end;
        else
            tooltip:AddLine( "  "..BT_EMPTY );
        end;

        -- Vendor value
        if ( vendorvalue > 0 ) then
            tooltip:AddLine( "|n" );
            tooltip:AddDoubleLine( BT_VENDORVALUE, GetCoinTextureString( vendorvalue ) );
        end;

        -- Add free slot info
        tooltip:AddLine( "|n" );
        tooltip:AddDoubleLine( BT_FREESLOTS, BT_FREE:format( GetContainerNumFreeSlots( bagID ) , GetContainerNumSlots( bagID ) ) );

        -- Forces tooltip to properly resize
        tooltip:Show();
    end;

-- Install all of the hooks and tracked events used by BagTips
    function BagTips_Install_Hooks()
        -- Show startup message
        BagTips_Message( BT_STARTUP_MESSAGE, false );

        -- Save original OnEnter/UpdateTooltip functions
        BT_Hooks["MainMenuBarBackpackButton"] = MainMenuBarBackpackButton:GetScript( "OnEnter" );
        BT_Hooks["CharacterBag0Slot"] = CharacterBag0Slot.UpdateTooltip;
        BT_Hooks["CharacterBag1Slot"] = CharacterBag1Slot.UpdateTooltip;
        BT_Hooks["CharacterBag2Slot"] = CharacterBag2Slot.UpdateTooltip;
        BT_Hooks["CharacterBag3Slot"] = CharacterBag3Slot.UpdateTooltip;
        for i = 1, NUM_BANKBAGSLOTS, 1 do
            BT_Hooks["BankFrameBag"..i] = BankSlotsFrame["Bag"..i].UpdateTooltip;
        end;

        -- Set new OnEnter/UpdateTooltip functions
        MainMenuBarBackpackButton:SetScript( "OnEnter", BagTips_OnEnter );
        CharacterBag0Slot.UpdateTooltip = BagTips_OnEnter;
        CharacterBag1Slot.UpdateTooltip = BagTips_OnEnter;
        CharacterBag2Slot.UpdateTooltip = BagTips_OnEnter;
        CharacterBag3Slot.UpdateTooltip = BagTips_OnEnter;
        for i = 1, NUM_BANKBAGSLOTS, 1 do
            BankSlotsFrame["Bag"..i].UpdateTooltip = BagTips_OnEnter;
        end;
    end;
