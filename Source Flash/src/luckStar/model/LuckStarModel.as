package luckStar.model
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.EventDispatcher;
   import luckStar.event.LuckStarEvent;
   
   public class LuckStarModel extends EventDispatcher
   {
       
      
      private var _rank:Array;
      
      private var _reward:Vector.<InventoryItemInfo>;
      
      private var _goods:Vector.<InventoryItemInfo>;
      
      private var _newRewardList:Vector.<Array>;
      
      private var _coins:int = 0;
      
      private var _activityDate:Array;
      
      private var _selfInfo:LuckStarPlayerInfo;
      
      private var _lastDate:String;
      
      private var _minUseNum:int;
      
      public function LuckStarModel()
      {
         super();
         this._goods = new Vector.<InventoryItemInfo>();
      }
      
      public function set reward(param1:Vector.<InventoryItemInfo>) : void
      {
         this._reward = param1;
      }
      
      public function set rank(param1:Array) : void
      {
         this._rank = param1;
      }
      
      public function set newRewardList(param1:Vector.<Array>) : void
      {
         this._newRewardList = param1;
         dispatchEvent(new LuckStarEvent(LuckStarEvent.NEW_REWARD_LIST));
      }
      
      public function set goods(param1:Vector.<InventoryItemInfo>) : void
      {
         this._goods = param1;
         dispatchEvent(new LuckStarEvent(LuckStarEvent.GOODS));
      }
      
      public function set coins(param1:int) : void
      {
         if(this._coins == param1)
         {
            return;
         }
         this._coins = param1;
         dispatchEvent(new LuckStarEvent(LuckStarEvent.COINS));
      }
      
      public function setActivityDate(param1:Date, param2:Date) : void
      {
         if(this._activityDate == null)
         {
            this._activityDate = new Array(2);
         }
         this._activityDate[0] = param1;
         this._activityDate[1] = param2;
      }
      
      public function set selfInfo(param1:LuckStarPlayerInfo) : void
      {
         this._selfInfo = param1;
      }
      
      public function set lastDate(param1:String) : void
      {
         this._lastDate = param1;
      }
      
      public function get lastDate() : String
      {
         return this._lastDate;
      }
      
      public function get selfInfo() : LuckStarPlayerInfo
      {
         return this._selfInfo;
      }
      
      public function get activityDate() : Array
      {
         return this._activityDate;
      }
      
      public function get rank() : Array
      {
         return this._rank;
      }
      
      public function get goods() : Vector.<InventoryItemInfo>
      {
         return this._goods;
      }
      
      public function get reward() : Vector.<InventoryItemInfo>
      {
         return this._reward;
      }
      
      public function get newRewardList() : Vector.<Array>
      {
         return this._newRewardList;
      }
      
      public function get coins() : int
      {
         return this._coins;
      }
      
      public function set minUseNum(param1:int) : void
      {
         this._minUseNum = param1;
      }
      
      public function get minUseNum() : int
      {
         return this._minUseNum;
      }
   }
}
