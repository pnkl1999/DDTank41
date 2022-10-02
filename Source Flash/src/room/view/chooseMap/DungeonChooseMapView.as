package room.view.chooseMap
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddt.view.ShineSelectButton;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class DungeonChooseMapView extends Sprite implements Disposeable
   {
      
      public static const DUNGEON_NO:int = 100;
      
      public static const DEFAULT_MAP:int = -1;
       
      
      private var _titleLoader:DisplayLoader;
      
      private var _preViewLoader:DisplayLoader;
      
      private var _bg:Scale9CornerImage;
      
      private var _roomMode:Bitmap;
      
      private var _chooseDungeon:Bitmap;
      
      private var _roomHardLevel:Bitmap;
      
      private var _modeDescriptionTxt:FilterFrameText;
      
      private var _dungeonDescriptionBg:Bitmap;
      
      private var _dungeonDescriptionTxt:TextArea;
      
      private var _dungeonTitle:Sprite;
      
      private var _dungeonPreView:Sprite;
      
      private var _dungeonList:SimpleTileList;
      
      private var _maps:Array;
      
      private var _dungeonListContainer:ScrollPanel;
      
      private var _bgTop:Scale9CornerImage;
      
      private var _bgCenter:Scale9CornerImage;
      
      private var _bgBottom:Scale9CornerImage;
      
      private var _bgCenterMap:Scale9CornerImage;
      
      private var _btns:Vector.<ShineSelectButton>;
      
      private var _group:SelectedButtonGroup;
      
      private var _easyBtn:ShineSelectButton;
      
      private var _normalBtn:ShineSelectButton;
      
      private var _hardBtn:ShineSelectButton;
      
      private var _heroBtn:ShineSelectButton;
      
      private var _bossBtn:SelectedCheckButton;
      
      private var _bossIMG:Bitmap;
      
      private var _bossBtnStrip:StripTip;
      
      private var _grayFilters:Array;
      
      private var _currentSelectedItem:DungeonMapItem;
      
      private var _rect1:Rectangle;
      
      private var _rect2:Rectangle;
      
      private var _rect3:Rectangle;
      
      private var _desTxtBg:Sprite;
      
      private var _desTxtBgRect:Rectangle;
      
      private var _dungeonInfoList:Dictionary;
      
      private var _selectedLevel:int = -1;
      
      private var _explainTxt:FilterFrameText;
      
      private var _passTxt:TextInput;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _textImage:Bitmap;
      
      private var _passBg:ScaleFrameImage;
      
      private var _modelIcon:Bitmap;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _mapTypBtn_n:SelectedButton;
      
      private var _mapTypBtn_s:SelectedButton;
      
      private var _mapTypBtn_a:SelectedButton;
      
      private var _selectedDungeonType:int;
      
      public function DungeonChooseMapView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc3_:DungeonMapItem = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonChooseMapViewBg");
         addChild(this._bg);
         this._bgTop = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonChooseMapBgTop");
         addChild(this._bgTop);
         this._bgCenter = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonChooseMapBgCenter");
         addChild(this._bgCenter);
         this._bgCenterMap = ComponentFactory.Instance.creatComponentByStylename("asset.room.mapBg");
         addChild(this._bgCenterMap);
         this._bgBottom = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonChooseMapBgBottom");
         addChild(this._bgBottom);
         this._desTxtBgRect = ComponentFactory.Instance.creatCustomObject("room.roomDescriptionTxtBg");
         this._desTxtBg = new Sprite();
         this._desTxtBg.graphics.beginFill(0,0.3);
         this._desTxtBg.graphics.drawRoundRect(this._desTxtBgRect.x,this._desTxtBgRect.y,this._desTxtBgRect.width,this._desTxtBgRect.height,5);
         this._desTxtBg.graphics.endFill();
         addChild(this._desTxtBg);
         this._roomMode = ComponentFactory.Instance.creatBitmap("asset.room.roomTypeAsset");
         addChild(this._roomMode);
         this._chooseDungeon = ComponentFactory.Instance.creatBitmap("asset.room.chooseDungeonAsset");
         addChild(this._chooseDungeon);
         this._roomHardLevel = ComponentFactory.Instance.creatBitmap("asset.room.roomHardLevelAsset");
         addChild(this._roomHardLevel);
         this._dungeonDescriptionBg = ComponentFactory.Instance.creatBitmap("asset.room.descriptionBgAsset");
         addChild(this._dungeonDescriptionBg);
         this._modeDescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonRoomModeDesTxt");
         addChild(this._modeDescriptionTxt);
         this._modeDescriptionTxt.wordWrap = true;
         this._modeDescriptionTxt.text = LanguageMgr.GetTranslation("room.view.chooseMap.DungeonChooseMapView.dungeonModeDescription");
         this._dungeonDescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonChooseMapDes");
         addChild(this._dungeonDescriptionTxt);
         this._dungeonDescriptionTxt.textField.selectable = false;
         this._dungeonDescriptionTxt.editable = false;
         this._btns = new Vector.<ShineSelectButton>();
         this._group = new SelectedButtonGroup();
         this._easyBtn = ComponentFactory.Instance.creatCustomObject("asset.room.easyButton");
         addChild(this._easyBtn);
         this._btns.push(this._easyBtn);
         this._group.addSelectItem(this._easyBtn);
         this._normalBtn = ComponentFactory.Instance.creatCustomObject("asset.room.normalButton");
         addChild(this._normalBtn);
         this._btns.push(this._normalBtn);
         this._group.addSelectItem(this._normalBtn);
         this._hardBtn = ComponentFactory.Instance.creatCustomObject("asset.room.diffButton");
         addChild(this._hardBtn);
         this._btns.push(this._hardBtn);
         this._group.addSelectItem(this._hardBtn);
         this._heroBtn = ComponentFactory.Instance.creatCustomObject("asset.room.heroButton");
         addChild(this._heroBtn);
         this._btns.push(this._heroBtn);
         this._group.addSelectItem(this._heroBtn);
         this._easyBtn.shineBg = ComponentFactory.Instance.creatBitmap("asset.room.levelBtnShineAsset");
         this._normalBtn.shineBg = ComponentFactory.Instance.creatBitmap("asset.room.levelBtnShineAsset");
         this._hardBtn.shineBg = ComponentFactory.Instance.creatBitmap("asset.room.levelBtnShineAsset");
         this._heroBtn.shineBg = ComponentFactory.Instance.creatBitmap("asset.room.levelBtnShineAsset");
         this._dungeonList = new SimpleTileList(4);
         this._dungeonList.startPos = new Point(4,4);
         this._maps = [];
         this._dungeonList.vSpace = 2;
         this._dungeonList.hSpace = -7;
         var _loc1_:int = 0;
         while(_loc1_ < DUNGEON_NO)
         {
            _loc3_ = new DungeonMapItem();
            this._dungeonList.addChild(_loc3_);
            _loc3_.addEventListener(Event.SELECT,this.__onItemSelect);
            this._maps.push(_loc3_);
            _loc1_++;
         }
         this._dungeonListContainer = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonMapSetScrollPanel");
         this._dungeonListContainer.vScrollProxy = ScrollPanel.ON;
         addChild(this._dungeonListContainer);
         this._dungeonListContainer.setView(this._dungeonList);
         this._dungeonTitle = ComponentFactory.Instance.creatCustomObject("asset.room.chooseDungeonTitle");
         addChild(this._dungeonTitle);
         this._dungeonPreView = ComponentFactory.Instance.creatCustomObject("asset.room.chooseDungeonPreView");
         addChild(this._dungeonPreView);
         this._rect1 = ComponentFactory.Instance.creatCustomObject("room.levelBtnPos1");
         this._rect2 = ComponentFactory.Instance.creatCustomObject("room.levelBtnPos2");
         this._rect3 = ComponentFactory.Instance.creatCustomObject("room.levelBtnPos3");
         this._modelIcon = ComponentFactory.Instance.creatBitmap("asset.roomList.mode_04");
         addChild(this._modelIcon);
         this._modelIcon.x = 125;
         this._modelIcon.y = 2;
         this._textImage = ComponentFactory.Instance.creatBitmap("asset.roomList.txtImage");
         addChild(this._textImage);
         this._textImage.x = 7;
         this._textImage.y = 30;
         this._passBg = ComponentFactory.Instance.creat("roomList.pvpRoomList.textBg");
         addChild(this._passBg);
         this._passBg.x = 83;
         this._passBg.y = 65;
         this._passTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.passText");
         addChild(this._passTxt);
         this._passTxt.x = 83;
         this._passTxt.y = 63;
         this._passTxt.text = "";
         this._passTxt.textField.restrict = "0-9 A-Z a-z";
         this._passTxt.visible = false;
         this._checkBox = ComponentFactory.Instance.creat("roomList.pvpRoomList.simpleSelectBtn");
         addChild(this._checkBox);
         this._checkBox.x = 260;
         this._checkBox.y = 67;
         this._explainTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.ExplainText");
         this._explainTxt.x = 83;
         this._explainTxt.y = 30;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215);
         _loc2_.graphics.drawRect(this._explainTxt.x,this._explainTxt.y,this._explainTxt.width,this._explainTxt.height);
         _loc2_.graphics.endFill();
         addChild(_loc2_);
         addChild(this._explainTxt);
         this._mapTypBtn_n = ComponentFactory.Instance.creatComponentByStylename("asset.room.TypeBtn_A");
         this._mapTypBtn_s = ComponentFactory.Instance.creatComponentByStylename("asset.room.TypeBtn_B");
         this._mapTypBtn_a = ComponentFactory.Instance.creatComponentByStylename("asset.room.TypeBtn_C");
         addChild(this._mapTypBtn_n);
         addChild(this._mapTypBtn_s);
         addChild(this._mapTypBtn_a);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._mapTypBtn_n);
         this._btnGroup.addSelectItem(this._mapTypBtn_s);
         this._btnGroup.addSelectItem(this._mapTypBtn_a);
         this._btnGroup.selectIndex = 0;
         this._bossBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.dungeonRoom.bossBtn");
         this._bossIMG = ComponentFactory.Instance.creatBitmap("asset.ddtroom.dungeonChoose.boss");
         this._bossBtn.addChild(this._bossIMG);
         this._bossBtn.tipData = LanguageMgr.GetTranslation("ddt.dungeonRoom.bossBtn.tiptext");
         addChild(this._bossBtn);
         this._bossBtnStrip = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.bossBtnStrip");
         this._bossBtnStrip.tipData = LanguageMgr.GetTranslation("ddt.dungeonRoom.bossBtn.tiptext");
         PositionUtils.setPos(this._bossBtnStrip,"ddt.dungeonRoom.bossBtnStripPos");
         addChild(this._bossBtnStrip);
         this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
         this.updateDescription();
         this.updatePreView();
         this.updateLevelBtn();
         this.updateRoomInfo();
         this.initInfo();
         if(PlayerManager.Instance.Self.VIPLevel >= 3 && PlayerManager.Instance.Self.IsVIP && this._btnGroup.selectIndex != 1)
         {
            this.setBossBtnState(true);
         }
         else
         {
            this.setBossBtnState(false);
         }
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
      
      private function initInfo() : void
      {
         var _loc2_:DungeonMapItem = null;
         switch(RoomManager.Instance.current.dungeonType)
         {
            case RoomInfo.DUNGEONTYPE_NO:
               this._btnGroup.selectIndex = 0;
               this.updateCommonItem();
               break;
            case RoomInfo.DUNGEONTYPE_SP:
               this._btnGroup.selectIndex = 1;
               this.updateSpecialItem();
               break;
            default:
               this.updateCommonItem();
         }
         var _loc1_:int = RoomManager.Instance.current.mapId;
         if(_loc1_ > 0 && _loc1_ != DEFAULT_MAP)
         {
            for each(_loc2_ in this._maps)
            {
               if(_loc2_.mapId == _loc1_)
               {
                  this._currentSelectedItem = _loc2_;
                  this._currentSelectedItem.selected = true;
               }
            }
            switch(RoomManager.Instance.current.hardLevel)
            {
               case RoomInfo.EASY:
                  this._group.selectIndex = 0;
                  this._selectedLevel = RoomInfo.EASY;
                  break;
               case RoomInfo.NORMAL:
                  this._group.selectIndex = 1;
                  this._selectedLevel = RoomInfo.NORMAL;
                  break;
               case RoomInfo.HARD:
                  this._group.selectIndex = 2;
                  this._selectedLevel = RoomInfo.HARD;
                  break;
               case RoomInfo.HERO:
                  this._group.selectIndex = 3;
                  this._selectedLevel = RoomInfo.HERO;
            }
         }
      }
      
      private function initEvents() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._mapTypBtn_n.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_s.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_a.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._easyBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._normalBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._hardBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._heroBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._bossBtn.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
      }
      
      private function removeEvents() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._mapTypBtn_n.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_s.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_a.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._easyBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._normalBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._hardBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._heroBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._bossBtn.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         if(this._titleLoader != null)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         }
         if(this._preViewLoader != null)
         {
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
         }
      }
      
      private function __changeHandler(param1:Event) : void
      {
         this._selectedDungeonType = this._btnGroup.selectIndex + 1;
         if(this._btnGroup.selectIndex == 0)
         {
            if(PlayerManager.Instance.Self.VIPLevel >= 3 && PlayerManager.Instance.Self.IsVIP)
            {
               this.setBossBtnState(true);
            }
            this.updateCommonItem();
         }
         else if(this._btnGroup.selectIndex == 1)
         {
            this.setBossBtnState(false);
            this.updateSpecialItem();
         }
         else if(this._btnGroup.selectIndex == 2)
         {
            if(PlayerManager.Instance.Self.VIPLevel >= 3 && PlayerManager.Instance.Self.IsVIP)
            {
               this.setBossBtnState(true);
            }
            this.updateAdvancedItem();
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __checkBoxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._checkBox:
               this.upadtePassTextBg();
               break;
            case this._bossBtn:
               this.checkState();
         }
      }
      
      private function updateCommonItem() : void
      {
         var _loc2_:DungeonMapItem = null;
         this.reset();
         var _loc1_:int = 1;
         while(_loc1_ < DUNGEON_NO)
         {
            if(MapManager.getByOrderingDungeonInfo(_loc1_))
            {
               _loc2_ = this._maps[_loc1_ - 1] as DungeonMapItem;
               _loc2_.mapId = MapManager.getByOrderingDungeonInfo(_loc1_).ID;
            }
            _loc1_++;
         }
      }
      
      private function updateSpecialItem() : void
      {
         var _loc2_:DungeonMapItem = null;
         this.reset();
         var _loc1_:int = 1;
         while(_loc1_ < DUNGEON_NO)
         {
            if(MapManager.getByOrderingSpecialDungeonInfo(_loc1_))
            {
               _loc2_ = this._maps[_loc1_ - 1] as DungeonMapItem;
               _loc2_.mapId = MapManager.getByOrderingSpecialDungeonInfo(_loc1_).ID;
            }
            _loc1_++;
         }
      }
      
      private function updateActivityItem() : void
      {
         var _loc2_:DungeonMapItem = null;
         this.reset();
         var _loc1_:int = 1;
         while(_loc1_ < DUNGEON_NO)
         {
            if(MapManager.getByOrderingActivityDungeonInfo(_loc1_))
            {
               _loc2_ = this._maps[_loc1_ - 1] as DungeonMapItem;
               _loc2_.mapId = MapManager.getByOrderingActivityDungeonInfo(_loc1_).ID;
            }
            _loc1_++;
         }
      }
      
      private function updateAdvancedItem() : void
      {
         var _loc3_:DungeonMapItem = null;
         this.reset();
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ < DUNGEON_NO)
         {
            if(MapManager.getByOrderingAdvancedDungeonInfo(_loc2_))
            {
               _loc3_ = this._maps[_loc1_++] as DungeonMapItem;
               _loc3_.mapId = MapManager.getByOrderingAdvancedDungeonInfo(_loc2_).ID;
            }
            _loc2_++;
         }
      }
      
      private function reset() : void
      {
         var _loc3_:DungeonMapItem = null;
         this.InitChooseMapState();
         var _loc1_:int = 1;
         while(_loc1_ < this._maps.length)
         {
            _loc3_ = this._maps[_loc1_ - 1] as DungeonMapItem;
            _loc3_.selected = false;
            _loc3_.stopShine();
            _loc3_.mapId = DEFAULT_MAP;
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._btns.length)
         {
            this._btns[_loc2_].selected = false;
            this._btns[_loc2_].stopShine();
            _loc2_++;
         }
      }
      
      private function InitChooseMapState() : void
      {
         this._currentSelectedItem = null;
         this._normalBtn.visible = this._hardBtn.visible = this._heroBtn.visible = true;
         this._normalBtn.enable = this._hardBtn.enable = this._heroBtn.enable = false;
         this.adaptButtons(0);
         ObjectUtils.disposeAllChildren(this._dungeonPreView);
         if(this._preViewLoader)
         {
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
            this._preViewLoader = null;
         }
         this._preViewLoader = LoaderManager.Instance.creatLoader("image/map/10000/samll_map.png",BaseLoader.BITMAP_LOADER);
         this._preViewLoader.addEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
         LoaderManager.Instance.startLoad(this._preViewLoader);
         if(this._titleLoader != null)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         }
         this._titleLoader = LoaderManager.Instance.creatLoader("image/map/10000/icon.png",BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         LoaderManager.Instance.startLoad(this._titleLoader);
         this._dungeonDescriptionTxt.text = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
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
      
      public function get _roomName() : String
      {
         return this._explainTxt.text;
      }
      
      public function get _roomPass() : String
      {
         this._passTxt.visible = false;
         if(false)
         {
            this._passTxt.text = "";
         }
         return this._passTxt.text;
      }
      
      public function get selectedDungeonType() : int
      {
         return this._selectedDungeonType;
      }
      
      public function get select() : Boolean
      {
         return this._bossBtn.selected;
      }
      
      private function __onItemSelect(param1:Event) : void
      {
         var _loc3_:ShineSelectButton = null;
         this._bossBtn.selected = false;
         var _loc2_:DungeonMapItem = param1.target as DungeonMapItem;
         if(this._currentSelectedItem && this._currentSelectedItem != _loc2_)
         {
            this._currentSelectedItem.selected = false;
         }
         this._currentSelectedItem = param1.target as DungeonMapItem;
         this.stopShineMap();
         this.stopShineLevelBtn();
         for each(_loc3_ in this._btns)
         {
            _loc3_.selected = false;
         }
         this._selectedLevel = -1;
         if(!PathManager.solveDungeonOpen(this._currentSelectedItem.mapId))
         {
            param1.target.selected = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.duplicate.notOpen"));
            this._currentSelectedItem = null;
            return;
         }
         this.updateDescription();
         this.updatePreView();
         this.updateLevelBtn();
      }
      
      private function showAlert() : void
      {
         var _loc1_:Frame = ComponentFactory.Instance.creat("room.FifthPreview");
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onPreResponse);
         _loc1_.escEnable = true;
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onPreResponse(param1:FrameEvent) : void
      {
         var _loc2_:Frame = param1.target as Frame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onPreResponse);
         _loc2_.dispose();
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.stopShineLevelBtn();
         switch(param1.currentTarget)
         {
            case this._easyBtn:
               this._selectedLevel = DungeonInfo.EASY;
               break;
            case this._normalBtn:
               this._selectedLevel = DungeonInfo.NORMAL;
               break;
            case this._hardBtn:
               this._selectedLevel = DungeonInfo.HARD;
               break;
            case this._heroBtn:
               this._selectedLevel = DungeonInfo.HERO;
         }
      }
      
      private function updateDescription() : void
      {
         if(this._titleLoader != null)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         }
         this._titleLoader = LoaderManager.Instance.creatLoader(this.solveTitlePath(),BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         LoaderManager.Instance.startLoad(this._titleLoader);
         if(this._currentSelectedItem)
         {
            this._dungeonDescriptionTxt.text = MapManager.getDungeonInfo(this._currentSelectedItem.mapId).Description;
         }
         else
         {
            this._dungeonDescriptionTxt.text = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
         }
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
            _loc1_ += "10000/icon.png";
         }
         return _loc1_;
      }
      
      private function updatePreView() : void
      {
         ObjectUtils.disposeAllChildren(this._dungeonPreView);
         if(this._preViewLoader)
         {
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
            this._preViewLoader = null;
         }
         this._preViewLoader = LoaderManager.Instance.creatLoader(this.solvePreViewPath(),BaseLoader.BITMAP_LOADER);
         this._preViewLoader.addEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
         LoaderManager.Instance.startLoad(this._preViewLoader);
      }
      
      private function solvePreViewPath() : String
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
      
      private function setBossBtnState(param1:Boolean) : void
      {
         if(param1)
         {
            this._bossBtnStrip.visible = false;
            this._bossBtn.mouseEnabled = this._bossBtn.buttonMode = true;
            this._bossBtn.filters = null;
         }
         else
         {
            this._bossBtnStrip.visible = true;
            this._bossBtn.mouseEnabled = this._bossBtn.buttonMode = false;
            this._bossBtn.filters = this._grayFilters;
         }
         this._bossBtn.selected = false;
      }
      
      private function updateLevelBtn() : void
      {
         this._easyBtn.visible = this._normalBtn.visible = this._hardBtn.visible = this._heroBtn.visible = true;
         this._easyBtn.enable = this._normalBtn.enable = this._hardBtn.enable = this._heroBtn.enable = false;
         if(this._currentSelectedItem && MapManager.getDungeonInfo(this._currentSelectedItem.mapId).isOpen)
         {
            this.adaptButtons(this._currentSelectedItem.mapId);
            this._easyBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,0);
            this._normalBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,1);
            this._hardBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,2);
            this._heroBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,3);
         }
         else
         {
            this.adaptButtons(0);
         }
      }
      
      private function adaptButtons(param1:int) : void
      {
         var _loc2_:DungeonInfo = MapManager.getDungeonInfo(param1);
         if(!_loc2_)
         {
            this._easyBtn.visible = false;
            this._normalBtn.x = this._rect3.x;
            this._hardBtn.x = this._rect3.y;
            this._heroBtn.x = this._rect3.width;
            return;
         }
         this._easyBtn.visible = _loc2_.SimpleTemplateIds != "";
         this._normalBtn.visible = _loc2_.NormalTemplateIds != "";
         this._hardBtn.visible = _loc2_.HardTemplateIds != "";
         this._heroBtn.visible = _loc2_.TerrorTemplateIds != "";
         var _loc3_:Vector.<ShineSelectButton> = new Vector.<ShineSelectButton>();
         var _loc4_:int = 0;
         while(_loc4_ < this._btns.length)
         {
            if(this._btns[_loc4_].visible)
            {
               _loc3_.push(this._btns[_loc4_]);
            }
            _loc4_++;
         }
         switch(_loc3_.length)
         {
            case 0:
               break;
            case 1:
               _loc3_[0].x = 224;
               break;
            case 2:
               _loc3_[0].x = this._rect2.x;
               _loc3_[1].x = this._rect2.y;
               break;
            case 3:
               _loc3_[0].x = this._rect3.x;
               _loc3_[1].x = this._rect3.y;
               _loc3_[2].x = this._rect3.width;
               break;
            case 4:
               _loc3_[0].x = this._rect1.x;
               _loc3_[1].x = this._rect1.y;
               _loc3_[2].x = this._rect1.width;
               _loc3_[3].x = this._rect1.height;
         }
      }
      
      private function __onTitleComplete(param1:LoaderEvent) : void
      {
         if(this._dungeonTitle && this._titleLoader && this._titleLoader.content)
         {
            ObjectUtils.disposeAllChildren(this._dungeonTitle);
            this._dungeonTitle.addChild(Bitmap(this._titleLoader.content));
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
            this._titleLoader = null;
         }
      }
      
      private function __onPreViewComplete(param1:LoaderEvent) : void
      {
         if(this._dungeonPreView && this._preViewLoader && this._preViewLoader.content)
         {
            ObjectUtils.disposeAllChildren(this._dungeonPreView);
            this._dungeonPreView.addChild(Bitmap(this._preViewLoader.content));
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
            this._preViewLoader = null;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:DungeonMapItem = null;
         this.removeEvents();
         for each(_loc1_ in this._maps)
         {
            _loc1_.removeEventListener(Event.SELECT,this.__onItemSelect);
         }
         this._titleLoader = null;
         this._preViewLoader = null;
         this._bg.dispose();
         this._bg = null;
         removeChild(this._roomMode);
         this._roomMode.bitmapData.dispose();
         this._roomMode = null;
         removeChild(this._chooseDungeon);
         this._chooseDungeon.bitmapData.dispose();
         this._chooseDungeon = null;
         removeChild(this._roomHardLevel);
         this._roomHardLevel.bitmapData.dispose();
         this._roomHardLevel = null;
         this._bgCenterMap.dispose();
         this._bgCenterMap = null;
         this._modeDescriptionTxt.dispose();
         this._modeDescriptionTxt = null;
         removeChild(this._dungeonDescriptionBg);
         this._dungeonDescriptionBg.bitmapData.dispose();
         this._dungeonDescriptionBg = null;
         this._dungeonDescriptionTxt.dispose();
         this._dungeonDescriptionTxt = null;
         ObjectUtils.disposeAllChildren(this._dungeonTitle);
         removeChild(this._dungeonTitle);
         this._dungeonTitle = null;
         ObjectUtils.disposeAllChildren(this._dungeonPreView);
         removeChild(this._dungeonPreView);
         this._dungeonPreView = null;
         this._dungeonList.dispose();
         this._dungeonList = null;
         this._maps = null;
         this._dungeonListContainer.dispose();
         this._dungeonListContainer = null;
         this._bgTop.dispose();
         this._bgTop = null;
         this._bgCenter.dispose();
         this._bgCenter = null;
         this._bgBottom.dispose();
         this._bgBottom = null;
         this._btns = null;
         this._group.dispose();
         this._group = null;
         this._easyBtn.dispose();
         this._easyBtn = null;
         this._normalBtn.dispose();
         this._normalBtn = null;
         this._hardBtn.dispose();
         this._hardBtn = null;
         this._heroBtn.dispose();
         this._heroBtn = null;
         if(this._bossBtn)
         {
            ObjectUtils.disposeObject(this._bossBtn);
         }
         this._bossBtn = null;
         if(this._bossBtnStrip)
         {
            ObjectUtils.disposeObject(this._bossBtnStrip);
         }
         this._bossBtnStrip = null;
         this._currentSelectedItem = null;
         removeChild(this._desTxtBg);
         this._desTxtBg = null;
         this._rect1 = null;
         this._rect2 = null;
         this._rect3 = null;
         this._desTxtBgRect = null;
         this._explainTxt.dispose();
         this._explainTxt = null;
         this._passTxt.dispose();
         this._passTxt = null;
         this._checkBox.dispose();
         this._checkBox = null;
         this._passBg.dispose();
         this._passBg = null;
         removeChild(this._textImage);
         this._textImage.bitmapData.dispose();
         this._textImage = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function checkState() : Boolean
      {
         if(!this._currentSelectedItem)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.selectDuplicate"));
            this._bossBtn.selected = false;
            this.shineMap();
            return false;
         }
         if(!MapManager.getDungeonInfo(this._currentSelectedItem.mapId).isOpen)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.duplicate.notOpen"));
            return false;
         }
         if(this._selectedLevel < 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomMapSetPanelDuplicate.choicePermissionType"));
            this._bossBtn.selected = false;
            this.shineLevelBtn();
            return false;
         }
         if(!PathManager.solveDungeonOpen(this._currentSelectedItem.mapId))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.duplicate.notOpen"));
            return false;
         }
         if(FilterWordManager.IsNullorEmpty(this._explainTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
            SoundManager.instance.play("008");
            return false;
         }
         if(FilterWordManager.isGotForbiddenWords(this._explainTxt.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
            SoundManager.instance.play("008");
            return false;
         }
         if(this._checkBox.selected && FilterWordManager.IsNullorEmpty(this._passTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
            SoundManager.instance.play("008");
            return false;
         }
         return true;
      }
      
      private function shineMap() : void
      {
         var _loc1_:DungeonMapItem = null;
         for each(_loc1_ in this._maps)
         {
            if(_loc1_.mapId > 0)
            {
               _loc1_.shine();
            }
         }
      }
      
      private function stopShineMap() : void
      {
         var _loc1_:DungeonMapItem = null;
         for each(_loc1_ in this._maps)
         {
            _loc1_.stopShine();
         }
      }
      
      private function shineLevelBtn() : void
      {
         var _loc1_:ShineSelectButton = null;
         for each(_loc1_ in this._btns)
         {
            if(_loc1_.enable)
            {
               _loc1_.shine();
            }
         }
      }
      
      private function stopShineLevelBtn() : void
      {
         var _loc1_:ShineSelectButton = null;
         for each(_loc1_ in this._btns)
         {
            _loc1_.stopShine();
         }
      }
      
      public function get selectedMapID() : int
      {
         return !!Boolean(this._currentSelectedItem) ? int(int(this._currentSelectedItem.mapId)) : int(int(0));
      }
      
      public function get selectedLevel() : int
      {
         return this._selectedLevel;
      }
   }
}
