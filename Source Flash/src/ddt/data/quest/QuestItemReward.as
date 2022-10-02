package ddt.data.quest
{
   public class QuestItemReward
   {
       
      
      private var _selectGroup:int;
      
      private var _itemID:int;
      
      private var _count:int;
      
      private var _isOptional:int;
      
      private var _time:int;
      
      private var _StrengthenLevel:int;
      
      private var _AttackCompose:int;
      
      private var _DefendCompose:int;
      
      private var _AgilityCompose:int;
      
      private var _LuckCompose:int;
      
      private var _isBind:Boolean;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var LuckCompose:int;
      
      public var AgilityCompose:int;
      
      public var StrengthenLevel:int;
      
      public var IsCount:Boolean;
      
      public function QuestItemReward(param1:int, param2:int, param3:String, param4:String = "true")
      {
         super();
         this._itemID = param1;
         this._count = param2;
         if(param3 == "true")
         {
            this._isOptional = 1;
         }
         else
         {
            this._isOptional = 0;
         }
         if(param4 == "true")
         {
            this._isBind = true;
         }
         else
         {
            this._isBind = false;
         }
      }
      
      public function get itemID() : int
      {
         return this._itemID;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set time(param1:int) : void
      {
         this._time = param1;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function get ValidateTime() : Number
      {
         return this._time;
      }
      
      public function get isOptional() : int
      {
         return this._isOptional;
      }
      
      public function get isBind() : Boolean
      {
         return this._isBind;
      }
   }
}
