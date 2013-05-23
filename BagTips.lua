--[[ =================================================================
    Description:
        BagTips gives you a peek at what is in a particular bag
        without having to open the bag

    Download:
        BagTips - http://fmeus.wordpress.com/bagtips/

    Contact:
        For questions, bug reports visit the website or send an email
        to the following address: wowaddon@xs4all.nl

    Dependencies:
        None

    Credits:
        A big 'Thank You' to all the people at Blizzard Entertainment
        for making World of Warcraft.

    Revision:
        $Id: BagTips.lua 772 2013-02-05 15:32:54Z fmeus_lgs $
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
        local bagName = self:GetName();
        local bagID = BT_BAG_IDS[bagName];
        local hasContent = false;
        local itemLink, itemid, itemCount, itemName, itemQuality, itemTexture, r, g, b, hex;
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

                if ( itemCount > 0 ) then
                    hasContent = true;
                    items[itemid] = ( items[itemid] or 0 ) + itemCount;
                end;
            end;
        end;

        -- Add items to tooltip
        tooltip:AddLine( "|n"..BT_CONTENTS );
        if ( hasContent ) then
            for key, value in pairs( items ) do
                itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, sellPrice = GetItemInfo( key );
                r, g, b, hex = GetItemQualityColor( itemQuality );
                tooltip:AddDoubleLine( "  |T"..itemTexture..":0|t "..itemName, value, r, g, b );
                vendorvalue = vendorvalue + ( value * sellPrice );
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
        BT_Hooks["BankFrameBag1"] = BankFrameBag1.UpdateTooltip;
        BT_Hooks["BankFrameBag2"] = BankFrameBag2.UpdateTooltip;
        BT_Hooks["BankFrameBag3"] = BankFrameBag3.UpdateTooltip;
        BT_Hooks["BankFrameBag4"] = BankFrameBag4.UpdateTooltip;
        BT_Hooks["BankFrameBag5"] = BankFrameBag5.UpdateTooltip;
        BT_Hooks["BankFrameBag6"] = BankFrameBag6.UpdateTooltip;
        BT_Hooks["BankFrameBag7"] = BankFrameBag7.UpdateTooltip;

        -- Set new OnEnter/UpdateTooltip functions
        MainMenuBarBackpackButton:SetScript( "OnEnter", BagTips_OnEnter );
        CharacterBag0Slot.UpdateTooltip = BagTips_OnEnter;
        CharacterBag1Slot.UpdateTooltip = BagTips_OnEnter;
        CharacterBag2Slot.UpdateTooltip = BagTips_OnEnter;
        CharacterBag3Slot.UpdateTooltip = BagTips_OnEnter;
        BankFrameBag1.UpdateTooltip = BagTips_OnEnter;
        BankFrameBag2.UpdateTooltip = BagTips_OnEnter; 
        BankFrameBag3.UpdateTooltip = BagTips_OnEnter; 
        BankFrameBag4.UpdateTooltip = BagTips_OnEnter; 
        BankFrameBag5.UpdateTooltip = BagTips_OnEnter; 
        BankFrameBag6.UpdateTooltip = BagTips_OnEnter; 
        BankFrameBag7.UpdateTooltip = BagTips_OnEnter; 
    end;
