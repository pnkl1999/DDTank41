package game.view.playerThumbnail
{
   import flash.display.Sprite;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GameLiving;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class PlayerThumbnailController extends Sprite
   {
       
      
      private var _info:GameInfo;
      
      private var _team1:DictionaryData;
      
      private var _team2:DictionaryData;
      
      private var _list1:PlayerThumbnailList;
      
      private var _list2:PlayerThumbnailList;
      
      private var _bossThumbnailContainer:BossThumbnail;
      
      public function PlayerThumbnailController(param1:GameInfo)
      {
         this._info = param1;
         this._team1 = new DictionaryData();
         this._team2 = new DictionaryData();
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this.initInfo();
         this._list1 = new PlayerThumbnailList(this._team1,-1);
         this._list2 = new PlayerThumbnailList(this._team2);
         addChild(this._list1);
         this._list1.x = 246;
         this._list2.x = 360;
         addChild(this._list2);
      }
      
      private function initInfo() : void
      {
         var _loc2_:Living = null;
         var _loc1_:DictionaryData = this._info.livings;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ is Player)
            {
               if(_loc2_.team == 1)
               {
                  this._team1.add((_loc2_ as Player).playerInfo.ID,_loc2_);
               }
               else if(this._info.gameMode != 5)
               {
                  this._team2.add((_loc2_ as Player).playerInfo.ID,_loc2_);
               }
            }
         }
      }
      
      public function set currentBoss(param1:Living) : void
      {
         this.removeThumbnailContainer();
         if(param1 == null)
         {
            return;
         }
         this._bossThumbnailContainer = new BossThumbnail(param1);
         this._bossThumbnailContainer.x = this._list1.x + 110;
         this._bossThumbnailContainer.y = -10;
         addChild(this._bossThumbnailContainer);
      }
      
      public function removeThumbnailContainer() : void
      {
         if(this._bossThumbnailContainer)
         {
            this._bossThumbnailContainer.dispose();
         }
         this._bossThumbnailContainer = null;
      }
      
      public function addLiving(param1:GameLiving) : void
      {
         if(param1.info.typeLiving == 4 || param1.info.typeLiving == 5 || param1.info.typeLiving == 6)
         {
            if(this._info.gameMode != 5)
            {
               this.currentBoss = param1.info;
            }
         }
         else if(param1.info.typeLiving == 1 || param1.info.typeLiving == 2)
         {
            this._team2.add(param1.info.LivingID,param1);
         }
      }
      
      private function initEvents() : void
      {
         this._info.livings.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
      }
      
      private function removeEvents() : void
      {
         this._info.livings.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:Player = param1.data as Player;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.character)
         {
            _loc2_.character.resetShowBitmapBig();
         }
         if(this._bossThumbnailContainer && this._bossThumbnailContainer.Id == _loc2_.LivingID)
         {
            this._bossThumbnailContainer.dispose();
            this._bossThumbnailContainer = null;
         }
         else if(_loc2_.team == 1)
         {
            this._team1.remove((param1.data as Player).playerInfo.ID);
         }
         else
         {
            this._team2.remove((param1.data as Player).playerInfo.ID);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(parent)
         {
            parent.removeChild(this);
         }
         this._info = null;
         this._team1 = null;
         this._team2 = null;
         this._list1.dispose();
         this._list2.dispose();
         if(this._bossThumbnailContainer)
         {
            this._bossThumbnailContainer.dispose();
         }
         this._bossThumbnailContainer = null;
         this._list1 = null;
         this._list2 = null;
      }
   }
}
