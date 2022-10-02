package game.view.playerThumbnail
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.PlayerThumbnailTip;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.model.Player;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class PlayerThumbnailList extends Sprite implements Disposeable
   {
       
      
      private var _info:DictionaryData;
      
      private var _players:DictionaryData;
      
      private var _dirct:int;
      
      private var _thumbnailTip:PlayerThumbnailTip;
      
      public function PlayerThumbnailList(param1:DictionaryData, param2:int = 1)
      {
         super();
         this._dirct = param2;
         this._info = param1;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:PlayerThumbnail = null;
         this._players = new DictionaryData();
         if(this._info)
         {
            _loc1_ = 0;
            for(_loc2_ in this._info)
            {
               _loc3_ = new PlayerThumbnail(this._info[_loc2_],this._dirct);
               _loc3_.addEventListener("playerThumbnailEvent",this.__onTipClick);
               this._players.add(_loc2_,_loc3_);
               addChild(_loc3_);
            }
         }
         this.arrange();
      }
      
      private function __onTipClick(param1:Event) : void
      {
         var e:Event = null;
         var __addTip:Function = null;
         e = param1;
         __addTip = function(param1:Event):void
         {
            if((param1.currentTarget as PlayerThumbnailTip).tipDisplay)
            {
               (param1.currentTarget as PlayerThumbnailTip).tipDisplay.recoverTip();
            }
         };
         this._thumbnailTip = ShowTipManager.Instance.getTipInstanceByStylename("ddt.view.tips.PlayerThumbnailTip") as PlayerThumbnailTip;
         if(this._thumbnailTip == null)
         {
            this._thumbnailTip = ShowTipManager.Instance.createTipByStyleName("ddt.view.tips.PlayerThumbnailTip");
            this._thumbnailTip.addEventListener("playerThumbnailTipItemClick",__addTip);
         }
         this._thumbnailTip.tipDisplay = e.currentTarget as PlayerThumbnail;
         this._thumbnailTip.x = this.mouseX;
         this._thumbnailTip.y = e.currentTarget.height + e.currentTarget.y + 12;
         PositionUtils.setPos(this._thumbnailTip,localToGlobal(new Point(this._thumbnailTip.x,this._thumbnailTip.y)));
         LayerManager.Instance.addToLayer(this._thumbnailTip,LayerManager.GAME_DYNAMIC_LAYER,false);
      }
      
      private function arrange() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(this._dirct < 0)
            {
               _loc2_.x = (_loc1_ + 1) * (_loc2_.width + 4) * this._dirct;
            }
            else
            {
               _loc2_.x = _loc1_ * (_loc2_.width + 4) * this._dirct;
            }
            _loc1_++;
         }
      }
      
      private function initEvents() : void
      {
         this._info.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._info.addEventListener(DictionaryEvent.ADD,this.__addLiving);
      }
      
      private function removeEvents() : void
      {
         this._info.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._info.removeEventListener(DictionaryEvent.ADD,this.__addLiving);
      }
      
      private function __addLiving(param1:DictionaryEvent) : void
      {
      }
      
      public function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:Player = param1.data as Player;
         if(_loc2_ && _loc2_.playerInfo)
         {
            if(this._players[_loc2_.playerInfo.ID])
            {
               this._players[_loc2_.playerInfo.ID].removeEventListener("playerThumbnailEvent",this.__onTipClick);
               this._players[_loc2_.playerInfo.ID].dispose();
               delete this._players[_loc2_.playerInfo.ID];
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         this.removeEvents();
         for(_loc1_ in this._players)
         {
            if(this._players[_loc1_])
            {
               this._players[_loc1_].removeEventListener("playerThumbnailEvent",this.__onTipClick);
               this._players[_loc1_].dispose();
            }
         }
         this._players = null;
         if(this._thumbnailTip)
         {
            this._thumbnailTip.tipDisplay = null;
         }
         this._thumbnailTip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
