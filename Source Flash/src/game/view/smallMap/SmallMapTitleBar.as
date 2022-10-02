package game.view.smallMap
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PathInfo;
   import ddt.data.map.MissionInfo;
   import ddt.events.DungeonInfoEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import game.GameManager;
   import game.view.DungeonHelpView;
   import room.RoomManager;
   import room.model.RoomInfo;
   import setting.controll.SettingController;
   
   public class SmallMapTitleBar extends Sprite implements Disposeable
   {
      
      private static const Ellipse:int = 4;
       
      
      private var _w:int = 162;
      
      private var _h:int = 23;
      
      private var _hardTxt:FilterFrameText;
      
      private var _back:BackBar;
      
      private var _exitBtn:SimpleBitmapButton;
      
      private var _settingBtn:SimpleBitmapButton;
      
      private var _turnButton:GameTurnButton;
      
      private var _mission:MissionInfo;
      
      private var _missionHelp:DungeonHelpView;
      
      private var _fieldNameLoader:DisplayLoader;
      
      private var _fieldName:Bitmap;
      
      private var alert:BaseAlerFrame;
      
      private var alert1:BaseAlerFrame;
      
      private var _startDate:Date;
      
      public function SmallMapTitleBar(param1:MissionInfo)
      {
         super();
         this._startDate = TimeManager.Instance.Now();
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = new BackBar();
         addChild(this._back);
         this._hardTxt = ComponentFactory.Instance.creatComponentByStylename("asset.game.smallMapHardTxt");
         addChild(this._hardTxt);
         this._settingBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.settingButton");
         this.setTip(this._settingBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.set"));
         addChild(this._settingBtn);
         this._exitBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.exitButton");
         this.setTip(this._exitBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.exit"));
         addChild(this._exitBtn);
         this._turnButton = ComponentFactory.Instance.creatCustomObject("GameTurnButton",[this]);
         var _loc1_:int = RoomManager.Instance.current.type;
         if(!RoomManager.Instance.current.isDungeonType && _loc1_ != RoomInfo.FIGHT_LIB_ROOM && _loc1_ != RoomInfo.FRESHMAN_ROOM)
         {
            this._fieldNameLoader = LoaderManager.Instance.creatLoader(this.solveMapPath(),BaseLoader.BITMAP_LOADER);
            this._fieldNameLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
            LoaderManager.Instance.startLoad(this._fieldNameLoader);
            this._back.tipStyle = "ddt.view.tips.PreviewTip";
            this._back.tipDirctions = "3,1";
            this._back.tipGapV = 5;
         }
         this.drawBackgound();
      }
      
      private function __onLoadComplete(param1:LoaderEvent) : void
      {
         this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         this._back.tipData = Bitmap(this._fieldNameLoader.content);
         ShowTipManager.Instance.addTip(this._back);
      }
      
      private function solveMapPath() : String
      {
         var _loc1_:String = PathManager.SITE_MAIN + "image/map/";
         if(GameManager.Instance.Current.gameMode == 8)
         {
            return _loc1_ + "1133/icon.png";
         }
         var _loc2_:int = GameManager.Instance.Current.mapIndex;
         if(RoomManager.Instance.current.mapId > 0)
         {
            _loc2_ = RoomManager.Instance.current.mapId;
         }
         return _loc1_ + (_loc2_.toString() + "/icon.png");
      }
      
      public function get turnButton() : GameTurnButton
      {
         return this._turnButton;
      }
      
      private function setTip(param1:SimpleBitmapButton, param2:String) : void
      {
         param1.tipStyle = "ddt.view.tips.OneLineTip";
         param1.tipDirctions = "3,6,1";
         param1.tipGapV = 5;
         param1.tipData = param2;
      }
      
      private function drawBackgound() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,3355443,1,true);
         _loc1_.beginFill(16777215,0.8);
         _loc1_.endFill();
         _loc1_.moveTo(0,this._h);
         _loc1_.lineTo(0,Ellipse);
         _loc1_.curveTo(0,0,Ellipse,0);
         _loc1_.lineTo(this._w - Ellipse,0);
         _loc1_.curveTo(this._w,0,this._w,Ellipse);
         _loc1_.lineTo(this._w,this._h);
         _loc1_.endFill();
         this._exitBtn.x = this._w - this._exitBtn.width - 2;
         this._settingBtn.x = this._exitBtn.x - this._settingBtn.width - 2;
         this._turnButton.x = this._w - this._turnButton.width >> 1;
         if(this._turnButton.x + this._turnButton.width > this._settingBtn.x)
         {
            this._turnButton.x = this._settingBtn.x - this._turnButton.width - 4;
         }
      }
      
      public function setBarrier(param1:int, param2:int) : void
      {
         this._turnButton.text = param1 + "/" + param2;
      }
      
      private function removeEvent() : void
      {
         this._exitBtn.removeEventListener(MouseEvent.CLICK,this.__exit);
         this._settingBtn.removeEventListener(MouseEvent.CLICK,this.__set);
         this._turnButton.removeEventListener(MouseEvent.CLICK,this.__turnFieldClick);
      }
      
      private function addEvent() : void
      {
         this._exitBtn.addEventListener(MouseEvent.CLICK,this.__exit);
         this._settingBtn.addEventListener(MouseEvent.CLICK,this.__set);
         this._turnButton.addEventListener(MouseEvent.CLICK,this.__turnFieldClick);
      }
      
      private function __turnFieldClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new DungeonInfoEvent(DungeonInfoEvent.DungeonHelpChanged));
         StageReferance.stage.focus = null;
      }
      
      private function __turnCountChanged(param1:RoomEvent) : void
      {
         this._turnButton.text = this._mission.turnCount + "/" + this._mission.maxTurnCount;
      }
      
      private function __set(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SettingController.Instance.switchVisible();
      }
      
      private function __exit(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == 5)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitLib"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(!GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(GameManager.Instance.Current.selfGamePlayer.selfDieTimeDelayPassed)
            {
               if(RoomManager.Instance.current.type < 2)
               {
                  this.alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitPVP"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  this.alert1.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
                  this.alert1.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
               }
               else
               {
                  this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
                  this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
               }
            }
            return;
         }
         var _loc2_:Number = TimeManager.Instance.TimeSpanToNow(this._startDate).time;
         if(RoomManager.Instance.current.type >= 2 && RoomManager.Instance.current.type != RoomInfo.SCORE_ROOM && RoomManager.Instance.current.type != RoomInfo.RANK_ROOM && RoomManager.Instance.current.type != RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(_loc2_ < PathInfo.SUCIDE_TIME)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ToolStripView.cannotExit"));
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         this.alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitPVP"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this.alert1.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.alert1.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function __onKeyDown(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            (param1.currentTarget as BaseAlerFrame).dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            (param1.currentTarget as BaseAlerFrame).dispatchEvent(new FrameEvent(FrameEvent.ESC_CLICK));
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         (param1.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         (param1.target as BaseAlerFrame).dispose();
         if(param1.target == this.alert)
         {
            this.alert = null;
         }
         else if(param1.target == this.alert1)
         {
            this.alert1 = null;
         }
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGamePlayerExit();
         }
      }
      
      public function set enableExit(param1:Boolean) : void
      {
         this._exitBtn.enable = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this._w = param1;
         this._back.width = param1 + 0.5;
         this.drawBackgound();
      }
      
      override public function set height(param1:Number) : void
      {
         this._h = param1;
         this.drawBackgound();
      }
      
      public function set title(param1:String) : void
      {
         this._hardTxt.text = param1;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._hardTxt)
         {
            ObjectUtils.disposeObject(this._hardTxt);
            this._hardTxt = null;
         }
         if(this._exitBtn)
         {
            ObjectUtils.disposeObject(this._exitBtn);
            this._exitBtn = null;
         }
         if(this._settingBtn)
         {
            ObjectUtils.disposeObject(this._settingBtn);
            this._settingBtn = null;
         }
         if(this._turnButton)
         {
            ObjectUtils.disposeObject(this._turnButton);
            this._turnButton = null;
         }
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(this._fieldName)
         {
            ObjectUtils.disposeObject(this._fieldName);
         }
         this._fieldName = null;
         if(this._fieldNameLoader)
         {
            this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         }
         this._fieldNameLoader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.ui.core.ITipedDisplay;
import com.pickgliss.utils.ObjectUtils;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Matrix;

class BackBar extends Sprite implements Disposeable, ITipedDisplay
{
    
   
   private var _w:Number = 1;
   
   private var _back1:Bitmap;
   
   private var _back2:Bitmap;
   
   private var _back3:Bitmap;
   
   protected var _tipData:Object;
   
   protected var _tipDirction:String;
   
   protected var _tipGapV:int;
   
   protected var _tipGapH:int;
   
   protected var _tipStyle:String;
   
   function BackBar()
   {
      super();
      this._back1 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack1");
      this._back2 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack2");
      this._back3 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack3");
   }
   
   override public function set width(param1:Number) : void
   {
      this._w = param1;
      this.draw();
   }
   
   private function draw() : void
   {
      var _loc1_:Graphics = graphics;
      _loc1_.clear();
      _loc1_.beginBitmapFill(this._back1.bitmapData,null,true,true);
      _loc1_.drawRect(0,0,this._back1.width,this._back1.height);
      _loc1_.endFill();
      _loc1_.beginBitmapFill(this._back2.bitmapData,null,true,true);
      _loc1_.drawRect(this._back1.width,0,this._w - this._back1.width - this._back3.width,this._back1.height);
      _loc1_.endFill();
      var _loc2_:Matrix = new Matrix();
      _loc2_.tx = this._w - this._back3.width;
      _loc1_.beginBitmapFill(this._back3.bitmapData,_loc2_,true,true);
      _loc1_.drawRect(this._w - this._back3.width,0,this._back3.width,this._back1.height);
      _loc1_.endFill();
   }
   
   public function get tipData() : Object
   {
      return this._tipData;
   }
   
   public function set tipData(param1:Object) : void
   {
      if(this._tipData == param1)
      {
         return;
      }
      this._tipData = param1;
   }
   
   public function get tipDirctions() : String
   {
      return this._tipDirction;
   }
   
   public function set tipDirctions(param1:String) : void
   {
      if(this._tipDirction == param1)
      {
         return;
      }
      this._tipDirction = param1;
   }
   
   public function get tipGapV() : int
   {
      return this._tipGapV;
   }
   
   public function set tipGapV(param1:int) : void
   {
      if(this._tipGapV == param1)
      {
         return;
      }
      this._tipGapV = param1;
   }
   
   public function get tipGapH() : int
   {
      return this._tipGapH;
   }
   
   public function set tipGapH(param1:int) : void
   {
      if(this._tipGapH == param1)
      {
         return;
      }
      this._tipGapH = param1;
   }
   
   public function get tipStyle() : String
   {
      return this._tipStyle;
   }
   
   public function set tipStyle(param1:String) : void
   {
      if(this._tipStyle == param1)
      {
         return;
      }
      this._tipStyle = param1;
   }
   
   public function asDisplayObject() : DisplayObject
   {
      return this;
   }
   
   public function dispose() : void
   {
      if(this._back1)
      {
         ObjectUtils.disposeObject(this._back1);
         this._back1 = null;
      }
      if(this._back2)
      {
         ObjectUtils.disposeObject(this._back2);
         this._back2 = null;
      }
      if(this._back3)
      {
         ObjectUtils.disposeObject(this._back3);
         this._back3 = null;
      }
      if(parent)
      {
         parent.removeChild(this);
      }
   }
}
