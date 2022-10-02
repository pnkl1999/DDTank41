package game.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import trainer.controller.NewHandGuideManager;
   
   public class SelfMarkBar extends Sprite implements Disposeable
   {
       
      
      private var _self:LocalPlayer;
      
      private var _timer:Timer;
      
      private var _nums:Vector.<DisplayObject>;
      
      private var _numContainer:Sprite;
      
      private var _alreadyTime:int;
      
      private var _animateFilter:BlurFilter;
      
      private var _scale:Number = 2;
      
      private var _skipButton:SkipButton;
      
      private var _container:DisplayObjectContainer;
      
      private var _numDic:Dictionary;
      
      private var _enabled:Boolean = true;
      
      public function SelfMarkBar(param1:LocalPlayer, param2:DisplayObjectContainer)
      {
         this._nums = new Vector.<DisplayObject>();
         this._animateFilter = new BlurFilter();
         this._numDic = new Dictionary();
         super();
         this._self = param1;
         this._container = param2;
         this._numContainer = new Sprite();
         this._numContainer.mouseEnabled = false;
         this._numContainer.mouseChildren = false;
         addChild(this._numContainer);
         this._skipButton = ComponentFactory.Instance.creatCustomObject("SkipButton");
         this._skipButton.x = -this._skipButton.width >> 1;
         this._skipButton.y = 70;
         addChild(this._skipButton);
         this.creatNums();
         this.addEvent();
      }
      
      private function creatNums() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc1_ = ComponentFactory.Instance.creatBitmap("asset.game.mark.Blue" + _loc2_);
            this._numDic["Blue" + _loc2_] = _loc1_;
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            _loc1_ = ComponentFactory.Instance.creatBitmap("asset.game.mark.Red" + _loc3_);
            this._numDic["Red" + _loc3_] = _loc1_;
            _loc3_++;
         }
      }
      
      private function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackChanged);
         this._self.addEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         this._skipButton.addEventListener(MouseEvent.CLICK,this.__skip);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      private function __skip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._skipButton.enabled)
         {
            this.skip();
         }
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackChanged);
         this._self.removeEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         this._skipButton.removeEventListener(MouseEvent.CLICK,this.__skip);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      private function __beginShoot(param1:LivingEvent) : void
      {
         this.pause();
         this._skipButton.enabled = false;
      }
      
      private function __attackChanged(param1:LivingEvent) : void
      {
         if(this._self.isAttacking && GameManager.Instance.Current.currentLiving && GameManager.Instance.Current.currentLiving.isSelf)
         {
            this.startup(this._self.turnTime);
         }
         else
         {
            this.pause();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         this.removeEvent();
         this.shutdown();
         this.clear();
         if(this._skipButton)
         {
            ObjectUtils.disposeObject(this._skipButton);
            this._skipButton = null;
         }
         for(_loc1_ in this._numDic)
         {
            ObjectUtils.disposeObject(this._numDic[_loc1_]);
            delete this._numDic[_loc1_];
         }
         if(this._numContainer)
         {
            ObjectUtils.disposeObject(this._numContainer);
            this._numContainer = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function startup(param1:int) : void
      {
         if(!this._enabled)
         {
            return;
         }
         this._skipButton.enabled = true;
         this._alreadyTime = param1;
         this.__mark(null);
         this._timer = new Timer(1000,param1);
         this._timer.addEventListener(TimerEvent.TIMER,this.__mark);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
         this._timer.start();
         this._container.addChild(this);
         this._animateFilter.blurX = 40;
         filters = [this._animateFilter];
         TweenLite.to(this._animateFilter,0.3,{
            "blurX":0,
            "onUpdate":this.tweenRender,
            "onComplete":this.tweenComplete
         });
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == KeyStroke.VK_P.getCode() && this._self.isAttacking && NewHandGuideManager.Instance.mapID != 111)
         {
            SoundManager.instance.play("008");
            this.skip();
         }
      }
      
      public function pause() : void
      {
         if(this._timer)
         {
            this._timer.stop();
         }
      }
      
      public function shutdown() : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function clear() : void
      {
         var _loc1_:DisplayObject = this._nums.shift();
         while(_loc1_)
         {
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _loc1_ = this._nums.shift();
         }
      }
      
      private function skip() : void
      {
         this.pause();
         this._self.skip();
      }
      
      private function tweenRender() : void
      {
         filters = [this._animateFilter];
      }
      
      private function tweenComplete() : void
      {
         filters = null;
      }
      
      private function __markComplete(param1:TimerEvent) : void
      {
         this.shutdown();
         this._self.skip();
      }
      
      public function get runnning() : Boolean
      {
         return this._timer != null && this._timer.running;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            if(this._enabled && this.runnning)
            {
               this._container.addChild(this);
            }
            else
            {
               this.shutdown();
            }
         }
      }
      
      private function __mark(param1:TimerEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Shape = null;
         _loc3_ = null;
         _loc4_ = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Graphics = null;
         var _loc7_:Number = NaN;
         TweenLite.killTweensOf(this);
         this.clear();
         --this._alreadyTime;
         var _loc2_:String = this._alreadyTime.toString();
         if(this._alreadyTime > 9)
         {
            if(this._alreadyTime % 11 == 0)
            {
               _loc3_ = this._numDic["Blue" + _loc2_.substr(0,1)];
               _loc3_.x = 0;
               this._numContainer.addChild(_loc3_);
               this._nums.push(_loc3_);
               _loc4_ = new Shape();
               _loc5_ = this._numDic["Blue" + _loc2_.substr(0,1)].bitmapData;
               _loc6_ = _loc4_.graphics;
               _loc6_.beginBitmapFill(_loc5_);
               _loc6_.drawRect(0,0,_loc5_.width,_loc5_.height);
               _loc6_.endFill();
               _loc4_.x = this._nums[0].width;
               this._numContainer.addChild(_loc4_);
               this._nums.push(_loc4_);
               this._numContainer.x = -this._numContainer.width >> 1;
            }
            else
            {
               _loc3_ = this._numDic["Blue" + _loc2_.substr(0,1)];
               _loc3_.x = 0;
               this._numContainer.addChild(_loc3_);
               this._nums.push(_loc3_);
               _loc3_ = this._numDic["Blue" + _loc2_.substr(1,1)];
               _loc3_.x = this._nums[0].width;
               this._numContainer.addChild(_loc3_);
               this._nums.push(_loc3_);
               this._numContainer.x = -this._numContainer.width >> 1;
            }
            SoundManager.instance.play("014");
         }
         else
         {
            if(this._alreadyTime < 0)
            {
               return;
            }
            if(this._alreadyTime <= 4)
            {
               _loc3_ = this._numDic["Red" + _loc2_];
               Bitmap(_loc3_).smoothing = true;
               this._numContainer.addChild(_loc3_);
               this._nums.push(_loc3_);
               SoundManager.instance.stop("067");
               SoundManager.instance.play("067");
               _loc7_ = this._scale - 1;
               this._numContainer.x = -this._numContainer.width * this._scale >> 1;
               this._numContainer.y = -this._numContainer.height * _loc7_ >> 1;
               this._numContainer.scaleX = this._numContainer.scaleY = this._scale;
               TweenLite.to(this._numContainer,0.2,{
                  "x":-_loc3_.width >> 1,
                  "y":0,
                  "scaleX":1,
                  "scaleY":1
               });
            }
            else
            {
               _loc3_ = this._numDic["Blue" + _loc2_];
               if(_loc3_)
               {
                  _loc3_.x = 0;
                  this._numContainer.addChild(_loc3_);
                  this._numContainer.x = -this._numContainer.width >> 1;
                  this._nums.push(_loc3_);
               }
               SoundManager.instance.play("014");
            }
         }
      }
   }
}
