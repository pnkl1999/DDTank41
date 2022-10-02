package consortion.event
{
   import flash.events.Event;
   
   public class ConsortionEvent extends Event
   {
      
      public static const CONSORTIONLIST_IS_CHANGE:String = "consortionListIsChange";
      
      public static const MY_APPLY_LIST_IS_CHANGE:String = "myApplyListIsChange";
      
      public static const INVENT_LIST_IS_CHANGE:String = "inventListIsChange";
      
      public static const LEVEL_UP_RULE_CHANGE:String = "levelUpRuleChange";
      
      public static const EVENT_LIST_CHANGE:String = "eventListChange";
      
      public static const USE_CONDITION_CHANGE:String = "useConditionChange";
      
      public static const DUTY_LIST_CHANGE:String = "dutyListChange";
      
      public static const POLL_LIST_CHANGE:String = "pollListChange";
      
      public static const SKILL_LIST_CHANGE:String = "skillListChange";
      
      public static const SKILL_STATE_CHANGE:String = "skillStateChange";
      
      public static const MEMBERLIST_COMPLETE:String = "memberListLoadComplete";
      
      public static const MEMBER_ADD:String = "addMember";
      
      public static const MEMBER_REMOVE:String = "removeMember";
      
      public static const MEMBER_UPDATA:String = "memberUpdata";
      
      public static const CONSORTION_STATE_CHANGE:String = "consortionStateChange";
      
      public static const CLUB_ITEM_SELECTED:String = "ClubItemSelected";
       
      
      public var data:Object;
      
      public function ConsortionEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.data = param2;
      }
   }
}
