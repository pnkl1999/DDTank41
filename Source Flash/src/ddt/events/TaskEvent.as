package ddt.events
{
   import ddt.data.quest.QuestDataInfo;
   import ddt.data.quest.QuestInfo;
   import flash.events.Event;
   
   public class TaskEvent extends Event
   {
      
      public static const INIT:String = "init";
      
      public static const CHANGED:String = "changed";
      
      public static const ADD:String = "add";
      
      public static const REMOVE:String = "remove";
      
      public static const FINISH:String = "finish";
       
      
      private var _info:QuestInfo;
      
      private var _data:QuestDataInfo;
      
      public function TaskEvent(param1:String, param2:QuestInfo, param3:QuestDataInfo)
      {
         this._info = param2;
         this._data = param3;
         super(param1,false,false);
      }
      
      public function get info() : QuestInfo
      {
         return this._info;
      }
      
      public function get data() : QuestDataInfo
      {
         return this._data;
      }
   }
}
