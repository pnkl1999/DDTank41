package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.view.chooseMap.ChallengeChooseMapView;
   
   public class ChallengeRoomSmallMapInfoPanel extends MatchRoomSmallMapInfoPanel implements Disposeable
   {
       
      
      private var _btn:SimpleBitmapButton;
      
      private var _roomType:Bitmap;
      
      private var _mapChooser:ChallengeChooseMapView;
      
      private var _titleLoader:DisplayLoader;
      
      private var _titleIconContainer:Sprite;
      
      public function ChallengeRoomSmallMapInfoPanel()
      {
         super();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this._titleIconContainer);
         _info.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__update);
         removeChild(this._roomType);
         removeChild(this._btn);
         this._btn.dispose();
         this._btn = null;
         this._roomType = null;
         if(this._mapChooser)
         {
            this._mapChooser.dispose();
            this._mapChooser = null;
         }
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      override public function set info(param1:RoomInfo) : void
      {
         super.info = param1;
         if(_info)
         {
            _info.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__update);
         }
         if(_info && _info.selfRoomPlayer.isHost)
         {
            buttonMode = true;
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            buttonMode = true;
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
         this.__update();
      }
      
      public function shine() : void
      {
      }
      
      public function stopShine() : void
      {
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._mapChooser = new ChallengeChooseMapView();
         this._btn = ComponentFactory.Instance.creatComponentByStylename("asset.room.view.smallMapInfoPanel.roomSmallMapInfoPanelButtton");
         this._roomType = ComponentFactory.Instance.creatBitmap("asset.room.view.smallMapInfoPanel.roomSmallMapInfoPanelTeamIconAsset");
         this._titleIconContainer = ComponentFactory.Instance.creatCustomObject("room.ChallengeMapSetPanelTitleSprite");
         _timeType.setFrame(2);
         this._btn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIMapSet.room2");
         addChild(this._roomType);
         addChild(this._btn);
         addChild(this._titleIconContainer);
         this._titleIconContainer.visible = false;
         buttonMode = true;
      }
      
      override protected function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("045");
         this._mapChooser.show();
      }
      
      private function __update(param1:RoomPlayerEvent = null) : void
      {
         if(_info.selfRoomPlayer.isHost)
         {
            buttonMode = this._btn.visible = true;
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            buttonMode = this._btn.visible = false;
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      override protected function updateView() : void
      {
         this._titleIconContainer.visible = _info.mapId != 0;
         super.updateView();
         if(this._titleLoader)
         {
            this._titleLoader = null;
         }
         this._titleLoader = LoaderManager.Instance.creatLoader(this.titlePath(),BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__titleCompleteHandler);
         LoaderManager.Instance.startLoad(this._titleLoader);
      }
      
      private function __titleCompleteHandler(param1:LoaderEvent) : void
      {
         ObjectUtils.disposeAllChildren(this._titleIconContainer);
         if(param1.loader.isSuccess)
         {
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__titleCompleteHandler);
            this._titleIconContainer.addChild(param1.loader.content as Bitmap);
         }
      }
      
      private function titlePath() : String
      {
         if(_info && _info.mapId > 0)
         {
            return PathManager.SITE_MAIN + "image/map/" + _info.mapId.toString() + "/icon.png";
         }
         return PathManager.SITE_MAIN + "image/map/0/icon.png";
      }
   }
}
