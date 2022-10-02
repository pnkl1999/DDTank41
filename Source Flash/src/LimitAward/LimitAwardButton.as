package LimitAward
{
   import calendar.CalendarManager;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.bossbox.TimeTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class LimitAwardButton extends Component
   {
      
      public static const HALL_POINT:int = 0;
      
      public static const PVR_ROOMLIST_POINT:int = 1;
      
      public static const PVP_ROOM_POINT:int = 2;
      
      public static const PVE_ROOMLIST_POINT:int = 3;
      
      public static const PVE_ROOM_POINT:int = 4;
       
      
      private var _openLimitAward:Sprite;
      
      private var _LimitAwardButton:MovieImage;
      
      private var _delayText:Sprite;
      
      private var timeText:FilterFrameText;
      
      private var _eventActives:Array;
      
      private var timeDiff:int;
      
      private var beginTime:Date;
      
      private var endTime:Date;
      
      private var _pointArray:Vector.<Point>;
      
      private var _timeSprite:TimeTip;
      
      private var _timer:Timer;
      
      private var _taskShineEffect:IEffect;
      
      public function LimitAwardButton(param1:int)
      {
         super();
         this.initView(param1);
         this.initEvent();
      }
      
      private function initView(param1:int) : void
      {
         this._getPoint();
         this._eventActives = CalendarManager.getInstance().eventActives;
         this.timeDiff = (CalendarManager.getInstance().getShowActiveInfo().end.getTime() - TimeManager.Instance.Now().getTime()) / 1000;
         this._delayText = new Sprite();
         this._openLimitAward = new Sprite();
         this._openLimitAward.graphics.beginFill(0,0);
         this._openLimitAward.graphics.drawRect(950,240,115,70);
         this._openLimitAward.graphics.endFill();
         this._LimitAwardButton = ComponentFactory.Instance.creat("LimitAward.Button");
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.timeBox.timeBGAsset");
         this.timeText = ComponentFactory.Instance.creat("LimitAward.TimeBoxStyle");
         addChild(this._openLimitAward);
         this._openLimitAward.addChild(this._LimitAwardButton);
         this._delayText.addChild(_loc2_);
         this._delayText.addChild(this.timeText);
         addChild(this._delayText);
         this._timeSprite = ComponentFactory.Instance.creat("LimitAwardBox.TimeTipTwo");
         this._timeSprite.tipData = LanguageMgr.GetTranslation("tanl.timebox.LimitAwardTip");
         this._timeSprite.setView(this._openLimitAward,this._delayText);
         this._timeSprite.buttonMode = true;
         addChild(this._timeSprite);
         this._timer = new Timer(1000,int(this.timeDiff));
         this._timer.start();
         if((param1 == PVE_ROOMLIST_POINT || param1 == PVR_ROOMLIST_POINT) && this.timeDiff > -1)
         {
            this._delayText.x = 79;
            this._delayText.y = -29;
            this._delayText.width = 130;
            this._LimitAwardButton.setFrame(1);
         }
         else if((param1 == PVP_ROOM_POINT || param1 == PVE_ROOM_POINT) && this.timeDiff > -1)
         {
            this._openLimitAward.x = 3;
            this._openLimitAward.y = -3;
            this._delayText.x = -30;
            this._delayText.y = 20;
            this._delayText.width = 115;
            this._LimitAwardButton.setFrame(1);
         }
         else if(param1 == HALL_POINT && this.timeDiff > -1)
         {
            this._openLimitAward.x = 3;
            this._openLimitAward.y = -3;
            this._delayText.x = -30;
            this._delayText.y = 20;
            this._delayText.width = 115;
         }
         x = this._pointArray[param1].x;
         y = this._pointArray[param1].y;
      }
      
      private function initEvent() : void
      {
         if(this._openLimitAward)
         {
            this._openLimitAward.addEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(this._timeSprite)
         {
            this._timeSprite.addEventListener(MouseEvent.CLICK,this.onClick);
         }
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__complete);
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         this.timeText.text = this.getTimeDiff(this.timeDiff);
         --this.timeDiff;
      }
      
      private function __complete(param1:TimerEvent) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function getTimeDiff(param1:int) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 >= 0)
         {
            _loc2_ = Math.floor(param1 / 60 / 60 / 24);
            param1 %= 60 * 60 * 24;
            _loc3_ = Math.floor(param1 / 60 / 60);
            param1 %= 60 * 60;
            _loc4_ = Math.floor(param1 / 60);
         }
         return _loc2_ + LanguageMgr.GetTranslation("day") + this.fixZero(_loc3_) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.hour") + this.fixZero(_loc4_) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.minute");
      }
      
      private function fixZero(param1:uint) : String
      {
         return param1 < 10 ? "0" + String(param1) : String(param1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         CalendarManager.getInstance().qqOpen(CalendarManager.getInstance().getShowActiveInfo().ActiveID);
         this._LimitAwardButton.setFrame(1);
      }
      
      private function _getPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("limitAwardButton.point" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         if(this._openLimitAward)
         {
            this._openLimitAward.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(this._timeSprite)
         {
            this._timeSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__complete);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._delayText)
         {
            ObjectUtils.disposeObject(this._delayText);
         }
         this._delayText = null;
         if(this._openLimitAward)
         {
            ObjectUtils.disposeObject(this._openLimitAward);
         }
         this._openLimitAward = null;
         if(this._LimitAwardButton)
         {
            ObjectUtils.disposeObject(this._LimitAwardButton);
         }
         this._LimitAwardButton = null;
         if(this.timeText)
         {
            ObjectUtils.disposeObject(this.timeText);
         }
         this.timeText = null;
         if(this._timeSprite)
         {
            ObjectUtils.disposeObject(this._timeSprite);
         }
         this._timeSprite = null;
         this._pointArray = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
