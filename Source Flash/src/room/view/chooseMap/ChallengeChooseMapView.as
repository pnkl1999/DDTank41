package room.view.chooseMap
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.MapInfo;
   import ddt.loader.MapSmallIcon;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class ChallengeChooseMapView extends Sprite implements Disposeable
   {
       
      
      private var _frame:BaseAlerFrame;
      
      private var _bg:Scale9CornerImage;
      
      private var _roomMode:Bitmap;
      
      private var _roomModeBlackBg:Scale9CornerImage;
      
      private var _roundTime:Bitmap;
      
      private var _roundTimeBlackBg:Scale9CornerImage;
      
      private var _roundTimeBg:Shape;
      
      private var _chooseMap:Bitmap;
      
      private var _mapPreview:Sprite;
      
      private var _previewLoader:DisplayLoader;
      
      private var _titlePreview:Sprite;
      
      private var _titleLoader:DisplayLoader;
      
      private var _currentSelectedItem:BaseMapItem;
      
      private var _mapList:SimpleTileList;
      
      private var _srollPanel:ScrollPanel;
      
      private var _roundTime5sec:SelectedButton;
      
      private var _roundTime7sec:SelectedButton;
      
      private var _roundTime10sec:SelectedButton;
      
      private var _roundTimeGroup:SelectedButtonGroup;
      
      private var _bottomBg:Scale9CornerImage;
      
      private var _decriptionBg:Bitmap;
      
      private var _mapInfoList:Vector.<MapInfo>;
      
      private var _mapDecription:TextArea;
      
      private var _mapId:int;
      
      private var _isDisposed:Boolean;
      
      private var _isReset:Boolean;
      
      private var _isChanged:Boolean = false;
      
      private var _explainTxt:FilterFrameText;
      
      private var _passTxt:TextInput;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _textImage:Bitmap;
      
      private var _passBg:ScaleFrameImage;
      
      private var _ModelIcon:Bitmap;
      
      public function ChallengeChooseMapView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc5_:MapInfo = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:BaseMapItem = null;
         this._roundTimeBg = new Shape();
         this._titlePreview = new Sprite();
         this._mapInfoList = new Vector.<MapInfo>();
         this._mapList = new SimpleTileList(4);
         this._roundTimeGroup = new SelectedButtonGroup();
         this._frame = ComponentFactory.Instance.creatComponentByStylename("room.ChallengeChooseMapFrame");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.room.challengeChooseMapViewBg");
         this._roomMode = ComponentFactory.Instance.creatBitmap("asset.room.roomTypeAsset");
         this._roomModeBlackBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.challengeChooseMapViewBgTopLeft");
         this._roundTime = ComponentFactory.Instance.creatBitmap("asset.room.challengeChooseMap.RoundTime");
         this._roundTimeBlackBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.challengeChooseMapViewBgTopRight");
         this._chooseMap = ComponentFactory.Instance.creatBitmap("asset.room.challengeChooseMap.ChooseMapBitmap");
         this._srollPanel = ComponentFactory.Instance.creatComponentByStylename("asset.room.challengeMapSetScrollPanel");
         this._roundTime5sec = ComponentFactory.Instance.creatComponentByStylename("room.RoundTime5SecBtn");
         this._roundTime7sec = ComponentFactory.Instance.creatComponentByStylename("room.RoundTime7SecBtn");
         this._roundTime10sec = ComponentFactory.Instance.creatComponentByStylename("room.RoundTime10SecBtn");
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.challengeChooseMapViewBgBottom");
         this._decriptionBg = ComponentFactory.Instance.creatBitmap("asset.room.challengeChooseMap.ChallengeMapInfoBg");
         this._mapPreview = ComponentFactory.Instance.creatCustomObject("room.ChallengePreviewSprite");
         this._mapDecription = ComponentFactory.Instance.creatComponentByStylename("room.ChallengeChooseMapDescription");
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
         _loc1_.showCancel = _loc1_.moveEnable = false;
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         this._isDisposed = false;
         this._frame.info = _loc1_;
         this._roundTime5sec.displacement = this._roundTime7sec.displacement = this._roundTime10sec.displacement = false;
         this._roundTimeGroup.addSelectItem(this._roundTime5sec);
         this._roundTimeGroup.addSelectItem(this._roundTime7sec);
         this._roundTimeGroup.addSelectItem(this._roundTime10sec);
         this._roundTimeGroup.selectIndex = RoomManager.Instance.current.timeType == -1 ? int(int(1)) : int(int(RoomManager.Instance.current.timeType - 1));
         var _loc2_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.chooseMapView.rect");
         var _loc3_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.chooseMapView.rect1");
         this._roundTimeBg.graphics.beginFill(0,0.3);
         this._roundTimeBg.graphics.drawRoundRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc2_.height,5,5);
         this._roundTimeBg.graphics.endFill();
         PositionUtils.setPos(this._roomMode,"room.ChallengeChooseMapRoomModeTitlePos");
         PositionUtils.setPos(this._roundTimeBg,"room.ChallengeChooseMapRoundTimeBgPos");
         PositionUtils.setPos(this._titlePreview,"room.ChallengeChooseMapMapTitlePos");
         this._mapList.vSpace = this._mapList.hSpace = -9;
         this._mapList.startPos = ComponentFactory.Instance.creatCustomObject("room.chooseMap.mapListStartPos");
         this._srollPanel.setView(this._mapList);
         this._srollPanel.hScrollProxy = ScrollPanel.OFF;
         this._srollPanel.vScrollProxy = ScrollPanel.ON;
         this._srollPanel.vUnitIncrement = 15;
         this._mapInfoList = MapManager.getListByType(MapManager.PVP_TRAIN_MAP);
         this._ModelIcon = ComponentFactory.Instance.creatBitmap("asset.roomList.mode_01");
         this._passTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.passText");
         this._passTxt.text = "";
         this._passTxt.textField.restrict = "0-9 A-Z a-z";
         this._passTxt.visible = false;
         this._explainTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.ExplainText");
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(16777215);
         _loc4_.graphics.drawRect(this._explainTxt.x,this._explainTxt.y,this._explainTxt.width,this._explainTxt.height);
         _loc4_.graphics.endFill();
         this._checkBox = ComponentFactory.Instance.creat("roomList.pvpRoomList.simpleSelectBtn");
         this._textImage = ComponentFactory.Instance.creatBitmap("asset.roomList.txtImage");
         this._passBg = ComponentFactory.Instance.creat("roomList.pvpRoomList.textBg");
         for each(_loc5_ in this._mapInfoList)
         {
            if(!(_loc5_.Type != 0 && _loc5_.Type != 1 && _loc5_.Type != 3))
            {
               if(_loc5_.canSelect)
               {
                  _loc6_ = new MapSmallIcon(_loc5_.ID);
                  if(_loc6_ != null)
                  {
                     _loc7_ = new BaseMapItem();
                     if(_loc5_.ID == RoomManager.Instance.current.mapId)
                     {
                        _loc7_.selected = true;
                        this._currentSelectedItem = _loc7_;
                        this._mapId = _loc5_.ID;
                     }
                     if(_loc5_.isOpen)
                     {
                        _loc7_.mapId = _loc5_.ID;
                        _loc7_.addEventListener(Event.SELECT,this.__mapItemClick);
                        this._mapList.addChild(_loc7_);
                     }
                  }
               }
            }
         }
         this._frame.addToContent(this._bg);
         this._frame.addToContent(this._roomMode);
         this._frame.addToContent(this._roomModeBlackBg);
         this._frame.addToContent(this._roundTime);
         this._frame.addToContent(this._roundTimeBlackBg);
         this._frame.addToContent(this._roundTimeBg);
         this._frame.addToContent(this._roundTime5sec);
         this._frame.addToContent(this._roundTime7sec);
         this._frame.addToContent(this._roundTime10sec);
         this._frame.addToContent(this._bottomBg);
         this._frame.addToContent(this._chooseMap);
         this._frame.addToContent(this._decriptionBg);
         this._frame.addToContent(this._titlePreview);
         this._frame.addToContent(this._mapDecription);
         this._frame.addToContent(this._mapPreview);
         this._frame.addToContent(this._srollPanel);
         this._frame.addToContent(this._ModelIcon);
         this._frame.addToContent(this._textImage);
         this._frame.addToContent(this._passBg);
         this._frame.addToContent(this._passTxt);
         this._frame.addToContent(this._checkBox);
         this._frame.addToContent(_loc4_);
         this._frame.addToContent(this._explainTxt);
         addChild(this._frame);
         this.updatePreview();
         this.updateDescription();
         this.updateRoomInfo();
         this._roundTime5sec.addEventListener(MouseEvent.CLICK,this.__roundTimeClick);
         this._roundTime7sec.addEventListener(MouseEvent.CLICK,this.__roundTimeClick);
         this._roundTime10sec.addEventListener(MouseEvent.CLICK,this.__roundTimeClick);
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function updateRoomInfo() : void
      {
         this._explainTxt.text = RoomManager.Instance.current.Name;
         if(RoomManager.Instance.current.roomPass)
         {
            this._checkBox.selected = true;
            this._passBg.setFrame(1);
            this._passTxt.visible = true;
            this._passTxt.text = RoomManager.Instance.current.roomPass;
         }
         else
         {
            this._checkBox.selected = false;
            this._passBg.setFrame(2);
            this._passTxt.visible = false;
         }
      }
      
      private function __checkBoxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.upadtePassTextBg();
      }
      
      private function upadtePassTextBg() : void
      {
         if(this._checkBox.selected)
         {
            this._passBg.setFrame(1);
            this._passTxt.visible = true;
            this._passTxt.setFocus();
         }
         else
         {
            this._passBg.setFrame(2);
            this._passTxt.text = "";
            this._passTxt.visible = false;
         }
      }
      
      private function __roundTimeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._isChanged = true;
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(FilterWordManager.IsNullorEmpty(this._explainTxt.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
                  SoundManager.instance.play("008");
               }
               else if(FilterWordManager.isGotForbiddenWords(this._explainTxt.text,"name"))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
                  SoundManager.instance.play("008");
               }
               else if(this._checkBox.selected && FilterWordManager.IsNullorEmpty(this._passTxt.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
                  SoundManager.instance.play("008");
               }
               else
               {
                  GameInSocketOut.sendGameRoomSetUp(this._mapId,RoomInfo.CHALLENGE_ROOM,false,this._passTxt.text,this._explainTxt.text,this._roundTimeGroup.selectIndex + 1,0,0,false,0);
                  RoomManager.Instance.current.roomName = this._explainTxt.text;
                  RoomManager.Instance.current.roomPass = this._passTxt.text;
                  this.hide();
               }
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.hide();
         }
      }
      
      public function set mapId(param1:int) : void
      {
         if(param1 != this._mapId)
         {
            this._mapId = param1;
         }
      }
      
      private function updatePreview() : void
      {
         ObjectUtils.disposeAllChildren(this._mapPreview);
         this._previewLoader = LoaderManager.Instance.creatLoader(this.solvePreviewPath(),BaseLoader.BITMAP_LOADER);
         this._previewLoader.addEventListener(LoaderEvent.COMPLETE,this.__onPreviewComplete);
         LoaderManager.Instance.startLoad(this._previewLoader);
      }
      
      private function updateDescription() : void
      {
         ObjectUtils.disposeAllChildren(this._titlePreview);
         this._titleLoader = LoaderManager.Instance.creatLoader(this.solveTitlePath(),BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         LoaderManager.Instance.startLoad(this._titleLoader);
         if(this._currentSelectedItem)
         {
            this._mapDecription.text = MapManager.getMapInfo(this._currentSelectedItem.mapId).Description;
         }
         else
         {
            this._mapDecription.text = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         }
      }
      
      private function __mapItemClick(param1:*) : void
      {
         if(this._isReset)
         {
            this._isReset = false;
            return;
         }
         this._isChanged = true;
         if(this._currentSelectedItem)
         {
            this._currentSelectedItem.selected = false;
         }
         this._currentSelectedItem = param1.target as BaseMapItem;
         this.mapId = this._currentSelectedItem.mapId;
         this.updateDescription();
         this.updatePreview();
      }
      
      private function solvePreviewPath() : String
      {
         var _loc1_:String = PathManager.SITE_MAIN + "image/map/";
         if(this._currentSelectedItem)
         {
            _loc1_ += this._currentSelectedItem.mapId.toString() + "/samll_map.png";
         }
         else
         {
            _loc1_ += "10000/samll_map.png";
         }
         return _loc1_;
      }
      
      private function solveTitlePath() : String
      {
         var _loc1_:String = PathManager.SITE_MAIN + "image/map/";
         if(this._currentSelectedItem)
         {
            _loc1_ += this._currentSelectedItem.mapId.toString() + "/icon.png";
         }
         else
         {
            _loc1_ += "0/icon.png";
         }
         return _loc1_;
      }
      
      private function __onPreviewComplete(param1:LoaderEvent) : void
      {
         if(param1.currentTarget.isSuccess)
         {
            if(this._mapPreview)
            {
               this._mapPreview.addChild(Bitmap(param1.currentTarget.content));
            }
         }
      }
      
      private function __onTitleComplete(param1:LoaderEvent) : void
      {
         if(param1.currentTarget.isSuccess)
         {
            if(this._titlePreview)
            {
               this._titlePreview.addChild(Bitmap(param1.currentTarget.content));
            }
         }
      }
      
      public function show() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._mapList.numChildren)
         {
            (this._mapList.getChildAt(_loc1_) as BaseMapItem).selected = false;
            if((this._mapList.getChildAt(_loc1_) as BaseMapItem).mapId == RoomManager.Instance.current.mapId)
            {
               this._isReset = true;
               this._currentSelectedItem = this._mapList.getChildAt(_loc1_) as BaseMapItem;
               this._currentSelectedItem.selected = true;
               this.mapId = this._currentSelectedItem.mapId;
               this.updateDescription();
               this.updatePreview();
            }
            _loc1_++;
         }
         this._roundTimeGroup.selectIndex = RoomManager.Instance.current.timeType == -1 ? int(int(1)) : int(int(RoomManager.Instance.current.timeType - 1));
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         StageReferance.stage.focus = this._frame;
         this._explainTxt.text = RoomManager.Instance.current.Name;
         this.updateRoomInfo();
      }
      
      public function hide() : void
      {
         this._isChanged = false;
         if(parent)
         {
            this._explainTxt.text = "";
         }
         this._passTxt.text = "";
         parent.removeChild(this);
      }
      
      public function dispose() : void
      {
         var _loc1_:BaseMapItem = null;
         if(!this._isDisposed)
         {
            while(this._mapList.numChildren)
            {
               _loc1_ = this._mapList.getChildAt(0) as BaseMapItem;
               _loc1_.removeEventListener(Event.SELECT,this.__mapItemClick);
               this._mapList.removeChild(_loc1_);
            }
            this._roundTime5sec.removeEventListener(MouseEvent.CLICK,this.__roundTimeClick);
            this._roundTime7sec.removeEventListener(MouseEvent.CLICK,this.__roundTimeClick);
            this._roundTime10sec.removeEventListener(MouseEvent.CLICK,this.__roundTimeClick);
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
            this._previewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreviewComplete);
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
            this._checkBox.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
            ObjectUtils.disposeAllChildren(this._mapPreview);
            ObjectUtils.disposeAllChildren(this._titlePreview);
            removeChild(this._frame);
            if(parent)
            {
               parent.removeChild(this);
            }
            this._frame.dispose();
            this._frame = null;
            this._bg.dispose();
            this._bg = null;
            this._roomMode = null;
            this._roomModeBlackBg.dispose();
            this._roomModeBlackBg = null;
            this._roundTime = null;
            this._roundTimeBlackBg.dispose();
            this._roundTimeBlackBg = null;
            this._roundTimeBg = null;
            this._chooseMap = null;
            this._mapPreview = null;
            this._previewLoader = null;
            this._ModelIcon = null;
            this._explainTxt.dispose();
            this._explainTxt = null;
            this._passTxt.dispose();
            this._passTxt = null;
            this._checkBox.dispose();
            this._checkBox = null;
            this._textImage = null;
            this._passBg.dispose();
            this._passBg = null;
            this._passBg = null;
            this._titleLoader = null;
            if(this._currentSelectedItem)
            {
               this._currentSelectedItem.dispose();
            }
            this._currentSelectedItem = null;
            this._mapList.disposeAllChildren();
            this._mapList.dispose();
            this._mapList = null;
            this._srollPanel.dispose();
            this._srollPanel = null;
            this._roundTime5sec.dispose();
            this._roundTime5sec = null;
            this._roundTime7sec.dispose();
            this._roundTime7sec = null;
            this._roundTime10sec.dispose();
            this._roundTime10sec = null;
            this._roundTimeGroup.dispose();
            this._roundTimeGroup = null;
            this._bottomBg.dispose();
            this._bottomBg = null;
            this._decriptionBg = null;
            this._mapInfoList = null;
            this._mapDecription = null;
            this._titlePreview = null;
            this._isDisposed = true;
         }
      }
   }
}
