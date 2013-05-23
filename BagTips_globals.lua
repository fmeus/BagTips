--[[ =================================================================
    Description:
        All globals used within BagTips.
    ================================================================= --]]

-- Colors used within BagTips
    C_GREEN  = "|cFF00FF00";
    C_CLOSE  = "|r";

-- Global variables
    BT = _G[ "BagTips" ]; -- AddOn object itself
    BT_NAME = GetAddOnMetadata( "BagTips", "Title" );
    BT_VERSION = GetAddOnMetadata( "BagTips", "Version" );

-- Hook related stuff
    BT_Hooks = {};
    BT_Hooks["MainMenuBarBackpackButton"] = {};
    BT_Hooks["CharacterBag0Slot"] = {};
    BT_Hooks["CharacterBag1Slot"] = {};
    BT_Hooks["CharacterBag2Slot"] = {};
    BT_Hooks["CharacterBag3Slot"] = {};
    BT_Hooks["BankFrameBag1"] = {};
    BT_Hooks["BankFrameBag2"] = {};
    BT_Hooks["BankFrameBag3"] = {};
    BT_Hooks["BankFrameBag4"] = {};
    BT_Hooks["BankFrameBag5"] = {};
    BT_Hooks["BankFrameBag6"] = {};
    BT_Hooks["BankFrameBag7"] = {};

-- Bag items
    items = {};

-- Bag IDs
    BT_BAG_IDS = { ["MainMenuBarBackpackButton"] = 0,
                   ["CharacterBag0Slot"] = 1,
                   ["CharacterBag1Slot"] = 2,
                   ["CharacterBag2Slot"] = 3,
                   ["CharacterBag3Slot"] = 4,
                   ["BankFrameBag1"] = 5,
                   ["BankFrameBag2"] = 6,
                   ["BankFrameBag3"] = 7,
                   ["BankFrameBag4"] = 8,
                   ["BankFrameBag5"] = 9,
                   ["BankFrameBag6"] = 10,
                   ["BankFrameBag7"] = 11,
                   };