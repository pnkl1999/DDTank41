package game
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.GameEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.model.MissionAgainInfo;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   [Event(name="timeOut",type="ddt.events.GameEvent")]
   [Event(name="tryagain",type="ddt.events.GameEvent")]
   [Event(name="giveup",type="ddt.events.GameEvent")]
   public class TryAgain extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _tryagain:BaseButton;
      
      private var _giveup:BaseButton;
      
      private var _titleField:FilterFrameText;
      
      private var _valueField:FilterFrameText;
      
      private var _valueBack:DisplayObject;
      
      private var _timer:Timer;
      
      private var _numDic:Dictionary;
      
      private var _markshape:Shape;
      
      private var _container:Sprite;
      
      protected var _info:MissionAgainInfo;
      
      private var _buffNote:DisplayObject;
      
      protected var _isShowNum:Boolean;
      
      public function TryAgain(param1:MissionAgainInfo, param2:Boolean = true)
      {
         this._numDic = new Dictionary();
         this._info = param1;
         this._isShowNum = param2;
         super();
         this._timer = new Timer(1000,10);
         if(this._isShowNum)
         {
            this.creatNums();
         }
         this.configUI();
         this.addEvent();
      }
      
      protected function tryagain(param1:Boolean = true) : void
      {
         dispatchEvent(new GameEvent(GameEvent.TRYAGAIN,param1));
      }
      
      public function show() : void
      {
         if(!RoomManager.Instance.current)
         {
            return;
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            switch(GameManager.Instance.TryAgain)
            {
               case GameManager.MissionAgain:
                  this.tryagain(false);
                  break;
               case GameManager.MissionGiveup:
                  this.__giveup(null);
                  break;
               case GameManager.MissionTimeout:
                  this.timeOut();
            }
         }
         else
         {
            this._timer.start();
         }
      }
      
      private function configUI() : void
      {
         this.drawBlack();
         this._container = new Sprite();
         addChild(this._container);
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.tryagain.back");
         this._container.addChild(this._back);
         this._tryagain = ComponentFactory.Instance.creatComponentByStylename("GameTryAgain");
         if(RoomManager.Instance.current)
         {
            this._tryagain.enable = RoomManager.Instance.current.selfRoomPlayer.isHost;
         }
         this._container.addChild(this._tryagain);
         this._giveup = ComponentFactory.Instance.creatComponentByStylename("GameGiveUp");
         if(RoomManager.Instance.current)
         {
            this._giveup.enable = RoomManager.Instance.current.selfRoomPlayer.isHost;
         }
         this._container.addChild(this._giveup);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("GameTryAgainTitle");
         this._container.addChild(this._titleField);
         this._titleField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.title",this._info.host);
         if(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            this._titleField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.titleII",this._info.host);
         }
         this._valueBack = ComponentFactory.Instance.creatBitmap("asset.game.tryagain.text");
         this._container.addChild(this._valueBack);
         this._valueField = ComponentFactory.Instance.creatComponentByStylename("GameTryAgainValue");
         this._container.addChild(this._valueField);
         this._markshape = new Shape();
         this._markshape.y = 80;
         if(this._isShowNum && RoomManager.Instance.current && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.drawMark(this._timer.repeatCount);
         }
         this._container.addChild(this._markshape);
         this._container.x = StageReferance.stageWidth - this._container.width >> 1;
         this._container.y = StageReferance.stageHeight - this._container.height >> 1;
         if(RoomManager.Instance.current && RoomManager.Instance.current.selfRoomPlayer.isHost && this._info.hasLevelAgain)
         {
            this.drawLevelAgainBuff();
            this._valueField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.value",0);
         }
         else
         {
            this._valueField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.value",this._info.value);
         }
      }
      
      private function drawLevelAgainBuff() : void
      {
         this._buffNote = addChild(ComponentFactory.Instance.creat("asset.core.payBuffAsset72.note"));
      }
      
      private function drawBlack() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.beginFill(0,0.4);
         _loc1_.drawRect(0,0,2000,1000);
         _loc1_.endFill();
      }
      
      private function creatNums() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc1_ = ComponentFactory.Instance.creatBitmapData("asset.game.mark.Blue" + _loc2_);
            this._numDic["Blue" + _loc2_] = _loc1_;
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
         this._tryagain.addEventListener(MouseEvent.CLICK,this.__tryagainClick);
         this._giveup.addEventListener(MouseEvent.CLICK,this.__giveup);
         this._timer.addEventListener(TimerEvent.TIMER,this.__mark);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timeComplete);
         GameManager.Instance.addEventListener(GameEvent.MISSIONAGAIN,this.__missionAgain);
      }
      
      private function __missionAgain(param1:GameEvent) : void
      {
         var _loc2_:int = param1.data;
         switch(_loc2_)
         {
            case GameManager.MissionAgain:
               this.tryagain(false);
               break;
            case GameManager.MissionGiveup:
               this.__giveup(null);
               break;
            case GameManager.MissionTimeout:
               this.timeOut();
         }
      }
      
      private function timeOut() : void
      {
         dispatchEvent(new GameEvent(GameEvent.TIMEOUT,null));
      }
      
      private function __timeComplete(param1:TimerEvent) : void
      {
         switch(GameManager.Instance.TryAgain)
         {
            case GameManager.MissionAgain:
               this.tryagain(false);
               break;
            case GameManager.MissionGiveup:
               this.__giveup(null);
               break;
            case GameManager.MissionTimeout:
               this.timeOut();
         }
      }
      
      private function drawMark(param1:int) : void
      {
         var _loc3_:BitmapData = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Graphics = this._markshape.graphics;
         _loc2_.clear();
         var _loc4_:String = param1.toString();
         if(param1 == 10)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc5_ = "Blue" + _loc4_.substr(_loc6_,1);
               _loc3_ = this._numDic[_loc5_];
               _loc2_.beginBitmapFill(_loc3_,new Matrix(1,0,0,1,this._markshape.width));
               _loc2_.drawRect(this._markshape.width,0,_loc3_.width,_loc3_.height);
               _loc2_.endFill();
               _loc6_++;
            }
            this._markshape.x = (this._back.width - _loc3_.width >> 1) - 20;
         }
         else
         {
            _loc3_ = this._numDic["Blue" + _loc4_];
            _loc2_.beginBitmapFill(_loc3_);
            _loc2_.drawRect(0,0,_loc3_.width,_loc3_.height);
            _loc2_.endFill();
            this._markshape.x = this._back.width - _loc3_.width >> 1;
         }
      }
      
      private function __mark(param1:TimerEvent) : void
      {
         SoundManager.instance.play("014");
         if(this._isShowNum)
         {
            this.drawMark(this._timer.repeatCount - this._timer.currentCount);
         }
      }
      
      protected function __tryagainClick(param1:MouseEvent) : void
      {
         if(param1)
         {
            SoundManager.instance.play("008");
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendMissionTryAgain(1,true);
         }
      }
      
      public function checkMoney(param1:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < param1)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function __giveup(param1:MouseEvent) : void
      {
         if(param1)
         {
            SoundManager.instance.play("008");
         }
         dispatchEvent(new GameEvent(GameEvent.GIVEUP,null));
      }
      
      private function removeEvent() : void
      {
         this._tryagain.removeEventListener(MouseEvent.CLICK,this.__tryagainClick);
         this._giveup.removeEventListener(MouseEvent.CLICK,this.__giveup);
         this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeComplete);
         GameManager.Instance.removeEventListener(GameEvent.MISSIONAGAIN,this.__missionAgain);
      }
      
      public function setLabyrinthTryAgain() : void
      {
         this._titleField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.titleII",this._info.host);
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         this.removeEvent();
         for(_loc1_ in this._numDic)
         {
            ObjectUtils.disposeObject(this._numDic[_loc1_]);
            delete this._numDic[_loc1_];
         }
         ObjectUtils.disposeObject(this._buffNote);
         this._buffNote = null;
         ObjectUtils.disposeObject(this._markshape);
         this._markshape = null;
         ObjectUtils.disposeObject(this._valueField);
         this._valueField = null;
         ObjectUtils.disposeObject(this._valueBack);
         this._valueBack = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._giveup);
         this._giveup = null;
         ObjectUtils.disposeObject(this._tryagain);
         this._tryagain = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
