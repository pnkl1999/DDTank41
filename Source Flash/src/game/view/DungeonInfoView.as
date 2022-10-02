package game.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import game.GameManager;
   import game.view.smallMap.GameTurnButton;
   import labyrinth.LabyrinthManager;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class DungeonInfoView extends Sprite
   {
       
      
      private var _bg:Bitmap;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _title1:FilterFrameText;
      
      private var _title2:FilterFrameText;
      
      private var _title3:FilterFrameText;
      
      private var _title4:FilterFrameText;
      
      private var _info1:FilterFrameText;
      
      private var _info2:FilterFrameText;
      
      private var _info3:FilterFrameText;
      
      private var _info4:FilterFrameText;
      
      private var _info:MissionInfo;
      
      private var _button:GameTurnButton;
      
      private var _container:DisplayObjectContainer;
      
      private var _sourceRect:Rectangle;
      
      private var _tweened:Boolean = false;
      
      private var _totalTrunTrainer:int = 100;
      
      private var _Vy:int;
      
      private var _textFormat:TextFormat;
      
      public function DungeonInfoView(param1:GameTurnButton, param2:DisplayObjectContainer)
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.missionInfoBgAsset");
         addChild(this._bg);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoViewButton");
         addChild(this._helpBtn);
         this._title1 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle1Txt");
         addChild(this._title1);
         this._title2 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle2Txt");
         addChild(this._title2);
         this._title3 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle3Txt");
         addChild(this._title3);
         this._title4 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle4Txt");
         addChild(this._title4);
         this._info1 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo1Txt");
         addChild(this._info1);
         this._info2 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo2Txt");
         addChild(this._info2);
         this._info3 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo3Txt");
         addChild(this._info3);
         this._info4 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo4Txt");
         addChild(this._info4);
         this._info = GameManager.Instance.Current.missionInfo;
         if(this._info.title1)
         {
            this._title1.text = this._info.title1;
         }
         if(this._info.title2)
         {
            this._title2.text = this._info.title2;
            if(this._title2.textHeight < 20)
            {
               this._title2.y = 30;
            }
         }
         if(this._info.title3)
         {
            this._title3.text = this._info.title3;
         }
         if(this._info.title4)
         {
            this._title4.text = this._info.title4;
         }
         this._sourceRect = getBounds(this);
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("asset.game.barrierPos");
         this._sourceRect.x = _loc3_.x;
         this._sourceRect.y = _loc3_.y;
         this._container = param2;
         this._button = param1;
         this._textFormat = ComponentFactory.Instance.model.getSet("game.missionInfoTitle_Text2");
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__openHelpHandler);
      }
      
      private function removeEvent() : void
      {
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__openHelpHandler);
      }
      
      private function __openHelpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new GameEvent(GameEvent.DungeonHelpVisibleChanged,true));
      }
      
      public function barrierInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         this._info = GameManager.Instance.Current.missionInfo;
         var _loc2_:PackageIn = param1.pkg;
         this._info.currentValue1 = _loc2_.readInt();
         this._info.currentValue2 = _loc2_.readInt();
         this._info.currentValue3 = _loc2_.readInt();
         this._info.currentValue4 = _loc2_.readInt();
         this.upView();
         dispatchEvent(new GameEvent(GameEvent.UPDATE_SMALLMAPVIEW,true));
      }
      
      public function trainerView(param1:int) : void
      {
         this._title1.text = "TRUN";
         if(param1 == -1)
         {
            this._info1.text = "";
            return;
         }
         this._info1.text = param1.toString() + "/" + this._totalTrunTrainer.toString();
         if(this._totalTrunTrainer == param1)
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      public function open() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = null;
         TweenLite.killTweensOf(this);
         _loc1_ = this._button.getBounds(this._container);
         x = _loc1_.x;
         y = _loc1_.y;
         width = _loc1_.width;
         height = _loc1_.height;
         this._container.addChild(this);
         TweenLite.to(this,0.3,{
            "x":this._sourceRect.x,
            "y":this._sourceRect.y,
            "width":this._sourceRect.width,
            "height":this._sourceRect.height
         });
      }
      
      private function closeComplete() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._button)
         {
            this._button.shine();
         }
      }
      
      public function close() : void
      {
         TweenLite.killTweensOf(this);
         x = this._sourceRect.x;
         y = this._sourceRect.y;
         width = this._sourceRect.width;
         height = this._sourceRect.height;
         var _loc1_:Rectangle = this._button.getBounds(this._container);
         TweenLite.to(this,0.3,{
            "x":_loc1_.x,
            "y":_loc1_.y,
            "width":_loc1_.width,
            "height":_loc1_.height,
            "onComplete":this.closeComplete
         });
         dispatchEvent(new GameEvent(GameEvent.DungeonHelpVisibleChanged,false));
      }
      
      private function upView() : void
      {
         if(this._info.currentValue1 != -1 && this._info.totalValue1 > 0)
         {
            this._info1.text = this._info.currentValue1 + "/" + this._info.totalValue1;
         }
         if(this._info.currentValue2 != -1 && this._info.totalValue2 > 0)
         {
            this._info2.text = this._info.currentValue2 + "/" + this._info.totalValue2;
         }
         if(this._info.currentValue3 != -1 && this._info.totalValue3 > 0)
         {
            this._info3.text = this._info.currentValue3 + "/" + this._info.totalValue3;
         }
         if(this._info.currentValue4 != -1 && this._info.totalValue4 > 0)
         {
            this._info4.text = this._info.currentValue4 + "/" + this._info.totalValue4;
         }
         if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            this._title3.text = LanguageMgr.GetTranslation("game.view.DungeonInfoView.title3");
            this._info3.text = LabyrinthManager.Instance.model.currentFloor.toString();
            this._title3.setTextFormat(this._textFormat);
            this._info3.setTextFormat(this._textFormat);
         }
      }
      
      public function dispose() : void
      {
         TweenLite.killTweensOf(this);
         this.removeEvent();
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         this._helpBtn.dispose();
         this._helpBtn = null;
         this._title1.dispose();
         this._title1 = null;
         this._title2.dispose();
         this._title2 = null;
         this._title3.dispose();
         this._title3 = null;
         this._title4.dispose();
         this._title4 = null;
         this._info1.dispose();
         this._info1 = null;
         this._info2.dispose();
         this._info2 = null;
         this._info3.dispose();
         this._info3 = null;
         this._info4.dispose();
         this._info4 = null;
         this._info = null;
         this._button = null;
         this._container = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
