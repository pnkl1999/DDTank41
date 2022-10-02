package room.view.bigMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.RoomTicketView;
   
   public class MissionRoomBigMapInfoPanel extends Sprite implements Disposeable
   {
       
      
      protected var _bg:Bitmap;
      
      protected var _mapShowContainer:Sprite;
      
      protected var _dropList:DropList;
      
      protected var _pos1:Point;
      
      protected var _pos2:Point;
      
      protected var _info:RoomInfo;
      
      private var _loader:DisplayLoader;
      
      protected var _ticketView:RoomTicketView;
      
      public function MissionRoomBigMapInfoPanel()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      protected function initEvents() : void
      {
         this._dropList.addEventListener(DropList.LARGE,this.__dropListLarge);
         this._dropList.addEventListener(DropList.SMALL,this.__dropListSmall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,this.__lastMission);
      }
      
      protected function removeEvents() : void
      {
         this._dropList.removeEventListener(DropList.LARGE,this.__dropListLarge);
         this._dropList.removeEventListener(DropList.SMALL,this.__dropListSmall);
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
         this._info.removeEventListener(RoomEvent.MAP_CHANGED,this.__onMapChanged);
         this._info.removeEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__updateHard);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,this.__lastMission);
      }
      
      private function __lastMission(param1:CrazyTankSocketEvent) : void
      {
         this._ticketView.visible = RoomManager.Instance.IsLastMisstion;
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.mathRoomBigMapInfoPanelBgAsset");
         addChild(this._bg);
         this._mapShowContainer = ComponentFactory.Instance.creatCustomObject("asset.room.bigMapIconContainer");
         addChild(this._mapShowContainer);
         this._pos1 = ComponentFactory.Instance.creatCustomObject("room.dropListPos1");
         this._pos2 = ComponentFactory.Instance.creatCustomObject("room.dropListPos2");
         this._dropList = new DropList();
         this._dropList.x = this._pos1.x;
         this._dropList.y = this._pos1.y;
         addChild(this._dropList);
         this._dropList.visible = false;
         this._info = RoomManager.Instance.current;
         if(this._info)
         {
            this._info.addEventListener(RoomEvent.MAP_CHANGED,this.__onMapChanged);
            this._info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__updateHard);
            this.updateMap();
         }
         if(this._ticketView == null)
         {
            this._ticketView = ComponentFactory.Instance.creatCustomObject("asset.warriorsArena.ticketView");
            this._ticketView.visible = RoomManager.Instance.IsLastMisstion;
            addChild(this._ticketView);
         }
         if(this._info)
         {
            this.updateDropList();
         }
      }
      
      protected function __onMapChanged(param1:RoomEvent) : void
      {
         this.updateMap();
         this.updateDropList();
      }
      
      protected function __updateHard(param1:RoomEvent) : void
      {
         this.updateDropList();
      }
      
      protected function updateMap() : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
         }
         this._loader = LoaderManager.Instance.creatLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__showMap);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      private function __showMap(param1:LoaderEvent) : void
      {
         if(param1.loader.isSuccess)
         {
            ObjectUtils.disposeAllChildren(this._mapShowContainer);
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
            this._mapShowContainer.addChild(param1.loader.content as Bitmap);
         }
      }
      
      protected function updateDropList() : void
      {
         var _loc1_:DungeonInfo = MapManager.getDungeonInfo(this._info.mapId);
         if(this._info.mapId != 0 && this._info.mapId != 10000)
         {
            if(this._ticketView)
            {
               this._ticketView.giftBtnEnable();
            }
            switch(this._info.hardLevel)
            {
               case RoomInfo.EASY:
                  this._dropList.info = _loc1_.SimpleTemplateIds.split(",");
                  break;
               case RoomInfo.NORMAL:
                  this._dropList.info = _loc1_.NormalTemplateIds.split(",");
                  break;
               case RoomInfo.HARD:
                  this._dropList.info = _loc1_.HardTemplateIds.split(",");
                  break;
               case RoomInfo.HERO:
                  this._dropList.info = _loc1_.TerrorTemplateIds.split(",");
            }
            this._dropList.visible = true;
         }
         else
         {
            this._dropList.visible = false;
         }
      }
      
      private function __dropListLarge(param1:Event) : void
      {
         this._dropList.x = this._pos2.x;
         this._dropList.y = this._pos2.y;
         if(this._ticketView)
         {
            this._ticketView.y = this._dropList.y - 50;
         }
      }
      
      private function __dropListSmall(param1:Event) : void
      {
         this._dropList.x = this._pos1.x;
         this._dropList.y = this._pos1.y;
         if(this._ticketView)
         {
            this._ticketView.y = this._dropList.y - 44;
         }
      }
      
      protected function solvePath() : String
      {
         var _loc1_:String = "";
         if(RoomManager.Instance.current.isOpenBoss)
         {
            _loc1_ = PathManager.SITE_MAIN + "image/map/" + this._info.mapId + "/" + RoomManager.Instance.current.pic;
         }
         else
         {
            _loc1_ = PathManager.SITE_MAIN + "image/map/" + this._info.mapId + "/" + GameManager.Instance.Current.missionInfo.pic;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bg.parent != null)
         {
            this._bg.parent.removeChild(this._bg);
         }
         this._bg.bitmapData.dispose();
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._mapShowContainer);
         if(this._mapShowContainer.parent != null)
         {
            this._mapShowContainer.parent.removeChild(this._mapShowContainer);
         }
         this._mapShowContainer = null;
         if(this._dropList != null)
         {
            this._dropList.dispose();
         }
         this._dropList = null;
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
         }
         this._loader = null;
         this._info = null;
         if(this._ticketView)
         {
            this._ticketView.dispose();
         }
         this._ticketView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
