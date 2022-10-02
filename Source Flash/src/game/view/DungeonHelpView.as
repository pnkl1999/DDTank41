package game.view
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import game.GameManager;
   import game.view.smallMap.GameTurnButton;
   
   public class DungeonHelpView extends Sprite implements Disposeable
   {
       
      
      private var _isFirst:Boolean;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _time:Timer;
      
      private var _opened:Boolean;
      
      private var _container:Sprite;
      
      private var _winTxt1:FilterFrameText;
      
      private var _winTxt2:FilterFrameText;
      
      private var _lostTxt1:FilterFrameText;
      
      private var _lostTxt2:FilterFrameText;
      
      private var _arrow1:Bitmap;
      
      private var _arrow2:Bitmap;
      
      private var _arrow3:Bitmap;
      
      private var _arrow4:Bitmap;
      
      private var _tweened:Boolean = false;
      
      private var _turnButton:GameTurnButton;
      
      private var _barrier:DungeonInfoView;
      
      private var _gameContainer:DisplayObjectContainer;
      
      private var _sourceRect:Rectangle;
      
      private var _showed:Boolean = false;
      
      public function DungeonHelpView(param1:GameTurnButton, param2:DungeonInfoView, param3:DisplayObjectContainer)
      {
         super();
         this._isFirst = true;
         buttonMode = false;
         mouseEnabled = false;
         this._turnButton = param1;
         this._barrier = param2;
         this._gameContainer = param3;
         this._container = new Sprite();
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.missionInfoBG2Asset");
         this._container.addChild(_loc4_);
         this._container.x = 211;
         this._container.y = 65;
         addChild(this._container);
         this._winTxt1 = ComponentFactory.Instance.creat("asset.DungeonHelpView.winTxt1");
         this._container.addChild(this._winTxt1);
         this._winTxt2 = ComponentFactory.Instance.creat("asset.DungeonHelpView.winTxt2");
         this._container.addChild(this._winTxt2);
         this._lostTxt1 = ComponentFactory.Instance.creat("asset.DungeonHelpView.lostTxt1");
         this._container.addChild(this._lostTxt1);
         this._lostTxt2 = ComponentFactory.Instance.creat("asset.DungeonHelpView.lostTxt2");
         this._container.addChild(this._lostTxt2);
         this._closeBtn = ComponentFactory.Instance.creat("asset.game.DungeonHelpView.closeBtn");
         this._container.addChild(this._closeBtn);
         this._arrow1 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow2");
         this._container.addChild(this._arrow1);
         this._arrow1.visible = false;
         this._arrow2 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow2");
         this._container.addChild(this._arrow2);
         this._arrow2.visible = false;
         this._arrow3 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow1");
         this._container.addChild(this._arrow3);
         this._arrow3.visible = false;
         this._arrow4 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow1");
         this._container.addChild(this._arrow4);
         this._arrow4.visible = false;
         this.setText();
         this._sourceRect = new Rectangle(0,0,424,132);
         this._sourceRect.x = StageReferance.stageWidth - this._sourceRect.width >> 1;
         this._sourceRect.y = StageReferance.stageHeight - this._sourceRect.height >> 1;
         addEventListener(MouseEvent.CLICK,this.__closeHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__startEffect);
      }
      
      private function closeComplete() : void
      {
         if(parent)
         {
            parent.removeChild(this);
            if(this._isFirst)
            {
               this._turnButton.isFirst = false;
               this._turnButton.shine();
               this._isFirst = false;
            }
         }
      }
      
      private function openComplete() : void
      {
      }
      
      public function open() : void
      {
         if(this._tweened)
         {
            TweenLite.killTweensOf(this._container,true);
         }
         this._gameContainer.addChild(this);
         this._tweened = true;
         this._opened = true;
         TweenLite.to(this,0.3,{
            "x":this._sourceRect.x,
            "y":this._sourceRect.y,
            "width":this._sourceRect.width,
            "height":this._sourceRect.height,
            "ease":Sine.easeOut,
            "onComplete":this.openComplete
         });
         this._winTxt2.text = "";
         this._winTxt2.visible = false;
      }
      
      public function close(param1:Rectangle) : void
      {
         if(this._tweened)
         {
            TweenLite.killTweensOf(this,true);
         }
         this._tweened = true;
         this._opened = false;
         TweenLite.to(this,0.6,{
            "width":param1.width,
            "height":param1.height,
            "x":param1.x,
            "y":param1.y,
            "ease":Sine.easeIn,
            "onComplete":this.closeComplete
         });
      }
      
      private function __sleepOrStop() : void
      {
         if(this._isFirst)
         {
            this._time = new Timer(2000,1);
            this._time.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._time.start();
            this._showed = true;
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         var _loc2_:Rectangle = this._turnButton.getBounds(this._gameContainer);
         _loc2_.x = 860;
         _loc2_.y = 5;
         this.close(_loc2_);
         this.clearTime();
      }
      
      private function clearTime() : void
      {
         if(this._time)
         {
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._time.stop();
         }
         this._time = null;
      }
      
      private function setText() : void
      {
         var _loc2_:Array = null;
         var _loc1_:Array = null;
         _loc2_ = null;
         _loc1_ = GameManager.Instance.Current.missionInfo.success.split("<br>");
         _loc2_ = GameManager.Instance.Current.missionInfo.failure.split("<br>");
         this._winTxt1.text = _loc1_[0];
         this._arrow1.y = this._winTxt1.y + 5;
         this._arrow1.x = this._winTxt1.x - 15;
         this._arrow1.visible = true;
         if(_loc1_.length >= 2)
         {
            this._winTxt2.text = _loc1_[1];
            this._winTxt2.y = this._winTxt1.y + this._winTxt1.textHeight + 25;
            this._arrow2.y = this._winTxt2.y + 5;
            this._arrow2.x = this._winTxt2.x - 15;
            this._arrow2.visible = true;
         }
         else
         {
            this._arrow2.visible = false;
         }
         this._lostTxt1.text = _loc2_[0];
         this._arrow3.y = this._lostTxt1.y + 5;
         this._arrow3.x = this._lostTxt1.x - 15;
         this._arrow3.visible = true;
         if(_loc2_.length >= 2)
         {
            this._lostTxt2.text = _loc2_[1];
            this._lostTxt2.y = this._lostTxt1.y + this._lostTxt1.textHeight;
            this._arrow4.y = this._lostTxt2.y + 5;
            this._arrow4.x = this._lostTxt2.x - 15;
            this._arrow4.visible = true;
         }
         else
         {
            this._arrow4.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.clearTime();
         if(this._tweened)
         {
            TweenLite.killTweensOf(this._container);
         }
         if(this._closeBtn)
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeHandler);
            ObjectUtils.disposeObject(this._closeBtn);
            this._closeBtn = null;
         }
         removeEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._winTxt1.dispose();
         this._winTxt1 = null;
         this._winTxt2.dispose();
         this._winTxt2 = null;
         this._lostTxt1.dispose();
         this._lostTxt1 = null;
         this._lostTxt2.dispose();
         this._lostTxt2 = null;
         this._container.removeChild(this._arrow1);
         this._arrow1.bitmapData.dispose();
         this._arrow1 = null;
         this._container.removeChild(this._arrow2);
         this._arrow2.bitmapData.dispose();
         this._arrow2 = null;
         this._container.removeChild(this._arrow3);
         this._arrow3.bitmapData.dispose();
         this._arrow3 = null;
         this._container.removeChild(this._arrow4);
         this._arrow4.bitmapData.dispose();
         this._arrow4 = null;
         ObjectUtils.disposeAllChildren(this._container);
         if(this._container.parent)
         {
            removeChild(this._container);
         }
         this._container = null;
         this._turnButton = null;
         if(this._barrier)
         {
            this._barrier.dispose();
         }
         this._barrier = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function __startEffect(param1:Event) : void
      {
         this._opened = true;
         x = StageReferance.stageWidth >> 1;
         y = StageReferance.stageHeight >> 1;
         width = 1;
         height = 1;
         TweenLite.to(this,1,{
            "x":this._sourceRect.x,
            "y":this._sourceRect.y,
            "width":this._sourceRect.width,
            "height":this._sourceRect.height,
            "ease":Sine.easeOut,
            "onComplete":this.__sleepOrStop
         });
      }
      
      private function __closeHandler(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = null;
         SoundManager.instance.play("008");
         if(this._isFirst)
         {
            this.close(new Rectangle(1000,0,2,2));
         }
         else
         {
            _loc2_ = this._barrier.getBounds(this._gameContainer);
            _loc2_.height = 1;
            _loc2_.width = 1;
            this.close(_loc2_);
         }
         StageReferance.stage.focus = null;
      }
      
      public function get opened() : Boolean
      {
         return this._opened;
      }
      
      public function get showed() : Boolean
      {
         return this._showed;
      }
   }
}
