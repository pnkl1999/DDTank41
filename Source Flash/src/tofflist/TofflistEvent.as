package tofflist
{
   import flash.events.Event;
   
   public class TofflistEvent extends Event
   {
      
      public static const TOFFLIST_DATA_CHANGER:String = "tofflistdatachange";
      
      public static const CROSS_SEREVR_DATA_CHANGER:String = "crossServerTofflistDataChange";
      
      public static const TOFFLIST_TOOL_BAR_SELECT:String = "tofflisttoolbarselect";
      
      public static const TOFFLIST_TYPE_CHANGE:String = "tofflisttypechange";
      
      public static const TOFFLIST_ITEM_SELECT:String = "tofflistitemselect";
      
      public static const TOFFLIST_CURRENT_PLAYER:String = "tofflistcurrentplaye";
      
      public static const TOFFLIST_INDIVIDUAL_GRADE_DAY:String = "individualGradeDay";
      
      public static const TOFFLIST_INDIVIDUAL_GRADE_WEEK:String = "individualgradeWeek";
      
      public static const TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:String = "individualgradeweek";
      
      public static const TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:String = "individualexploitday";
      
      public static const TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:String = "individualexploitweek";
      
      public static const TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:String = "individualexploitaccumulate";
      
      public static const TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:String = "individualcharmvalueday";
      
      public static const TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:String = "individualcharmvalueweek";
      
      public static const TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:String = "individualcharmvalueaccumulate";
      
      public static const TOFFLIST_INDIVIDUAL_MATCHES_WEEK:String = "individualMatchesWeek";
      
      public static const TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:String = "consortiagradeaccumulate";
      
      public static const TOFFLIST_CONSORTIA_ASSET_DAY:String = "consortiaassetday";
      
      public static const TOFFLIST_CONSORTIA_ASSET_WEEK:String = "consortiaassetweek";
      
      public static const TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:String = "consortiaassetaccumulate";
      
      public static const TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:String = "consortiaBattleAccumulate";
      
      public static const TOFFLIST_CONSORTIA_EXPLOIT_DAY:String = "consortiaexploitday";
      
      public static const TOFFLIST_CONSORTIA_EXPLOIT_WEEK:String = "consortiaexploitweek";
      
      public static const TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:String = "consortiaexploitaccumulate";
      
      public static const TOFFLIST_CONSORTIA_CHARMVALUE_DAY:String = "consortiacharmvalueday";
      
      public static const TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:String = "consortiacharmvalueweek";
      
      public static const TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:String = "consortiacharmvalueAccumulate";
      
      public static const TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:String = "personalBattleAccumulate";
      
      public static const TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY:String = "individualAchievementPointDay";
      
      public static const TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK:String = "individualAchievementPointWeek";
      
      public static const TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE:String = "individualAchievementPointAccumulate";
      
      public static const TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY:String = "consortiaAchievementPointDay";
      
      public static const TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK:String = "consortiaAchievementPointWeek";
      
      public static const TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE:String = "consortiaAchievementPointAccumulate";
      
      public static const RANKINFO_READY:String = "rankInfo_ready";
       
      
      private var _info:Object;
      
      public function TofflistEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._info = param2;
      }
      
      public function get data() : Object
      {
         return this._info;
      }
   }
}
