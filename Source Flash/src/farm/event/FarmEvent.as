package farm.event
{
   import flash.events.Event;
   
   public class FarmEvent extends Event
   {
      
      public static const FIELDS_INFO_READY:String = "fieldsInfoReady";
      
      public static const FRIEND_INFO_READY:String = "friendInfoReady";
      
      public static const ENTER_FRIEND_FARM:String = "enterFriendFarm";
      
      public static const HAS_SEEDING:String = "hasSeeding";
      
      public static const FRUSH_FIELD:String = "frushField";
      
      public static const GAIN_FIELD:String = "gainField";
      
      public static const PAY_FIELD:String = "payField";
      
      public static const ACCELERATE_FIELD:String = "accelerateField";
      
      public static const FOOD_COMPOSE_LISE_READY:String = "accelerateField";
      
      public static const HELPER_SWITCH_FIELD:String = "helperSwitchField";
      
      public static const HELPER_KEY_FIELD:String = "helperkeyfield";
      
      public static const KILLCROP_FIELD:String = "killCropField";
      
      public static const UPDATE_HELPERISAUTO:String = "updateHelperIsAuto";
      
      public static const NOENOUTHSEED:String = "NoEnoughSeed";
      
      public static const BEGIN_HELPER:String = "beginHelper";
      
      public static const STOP_HELPER:String = "stopHelper";
      
      public static const OUT_SELF_FARM:String = "outSelfFarm";
      
      public static const CONFIRM_STOP_HELPER:String = "confirmStopHelper";
      
      public static const PAY_HELPER:String = "payHepler";
      
      public static const LOADER_SUPER_PET_FOOD_PRICET_LIST:String = "loaderSuperPetFoodPricetList";
      
      public static const UPDATE_BUY_EXP_REMAIN_NUM:String = "updateBuyExpRemainNum";
      
      public static const FIELDBLOCK_CLICK:String = "fieldblockclick";
      
      public static const FRIENDLIST_UPDATESTOLEN:String = "friendList_updateStolen";
      
      public static const ARRANGE_FRIEND_FARM:String = "arrangeFriendFarm";
       
      
      public function FarmEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
