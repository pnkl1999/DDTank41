package luckStar.view
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import luckStar.manager.LuckStarManager;
   
   public class LuckStarAwardAction extends Sprite implements Disposeable
   {
       
      
      private var _action:MovieClip;
      
      private var _list:Vector.<Bitmap>;
      
      private var _cell:Function;
      
      private var _num:Vector.<ScaleFrameImage>;
      
      private var _count:int = 0;
      
      private var len:int;
      
      private var arr:Array;
      
      private var _isMaxAward:Boolean;
      
      private var _mc:MovieClip;
      
      private var _image:Bitmap;
      
      private var _content:Sprite;
      
      private var _move:Point;
      
      private var _tweenMax:TweenMax;
      
      public function LuckStarAwardAction()
      {
         this.arr = [9,99,999,9999,99999,999999,9999999];
         super();
      }
      
      public function playAction(param1:Function, param2:DisplayObject, param3:Point, param4:Boolean = false) : void
      {
         var _loc5_:Rectangle = null;
         this._cell = param1;
         this._isMaxAward = param4;
         if(this._isMaxAward)
         {
            this.playMaxAwardAction();
            return;
         }
         this._content = new Sprite();
         addChild(this._content);
         this._image = param2 as Bitmap;
         this._move = param3;
         _loc5_ = ComponentFactory.Instance.creatCustomObject("luckyStar.view.AwardLightRec");
         this._mc = ComponentFactory.Instance.creat("luckyStar.view.TurnMC");
         this._mc.stop();
         this._mc.width = this._mc.height = _loc5_.width;
         this._mc.x = _loc5_.x;
         this._mc.y = _loc5_.y;
         this._mc.gotoAndPlay(1);
         this._mc.addEventListener(Event.ENTER_FRAME,this.__onEnter);
         this._content.addChild(this._mc);
      }
      
      private function playNextAction() : void
      {
         if(this._image)
         {
            this._image.x = this._image.y = -2;
            this._image.scaleX = this._image.scaleY = 0.8;
            this._content.addChild(this._image);
         }
      }
      
      private function __onEnter(param1:Event) : void
      {
         if(this._mc.currentFrame == 40)
         {
            SoundManager.instance.play("125");
            this.playNextAction();
         }
         if(this._mc.currentFrame == 65)
         {
            this._tweenMax = TweenMax.to(this._content,0.7,{
               "x":this._move.x,
               "y":this._move.y,
               "width":60,
               "height":60
            });
         }
         if(this._mc.currentFrame == this._mc.totalFrames - 1)
         {
            this.disposeAction();
         }
      }
      
      public function get actionDisplay() : Sprite
      {
         return this._content;
      }
      
      private function disposeAction() : void
      {
         if(this._mc)
         {
            this._mc.stop();
            this._mc.removeEventListener(Event.ENTER_FRAME,this.__onEnter);
            ObjectUtils.disposeObject(this._mc);
            this._mc = null;
         }
         if(this._image)
         {
            ObjectUtils.disposeObject(this._image);
            this._image = null;
         }
         if(this._tweenMax)
         {
            TweenMax.killChildTweensOf(this._content);
         }
         this._tweenMax = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         if(this._cell != null)
         {
            this._cell.apply();
         }
         this._cell = null;
      }
      
      public function playMaxAwardAction() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         this._list = new Vector.<Bitmap>();
         this._num = new Vector.<ScaleFrameImage>();
         this._count = LuckStarManager.Instance.model.coins;
         this._action = ComponentFactory.Instance.creat("luckyStar.view.maxAwardAction");
         PositionUtils.setPos(this._action,"luckyStar.view.maxAwardActionPos");
         addChild(this._action);
         this._action.addEventListener(Event.ENTER_FRAME,this.__onAction);
         this._action.gotoAndPlay(1);
         SoundManager.instance.play("210");
      }
      
      private function setupCount() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.len > this._num.length)
         {
            this._num.unshift(this.createCoinsNum(0));
         }
         while(this.len < this._num.length)
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         var _loc1_:int = 8 - this.len;
         _loc2_ = _loc1_ / 2 * 25;
         _loc3_ = 0;
         while(_loc3_ < this.len)
         {
            this._num[_loc3_].x = _loc2_ + 280;
            this._num[_loc3_].y = 200;
            _loc2_ += 25;
            _loc3_++;
         }
      }
      
      private function playCount() : void
      {
         this.setupCount();
         if(this.len == 0 || this.len > this.arr.length)
         {
            return;
         }
         var _loc1_:int = Math.random() * int(this.arr[this.len - 1]);
         this.updateCoinsView(_loc1_.toString().split(""));
      }
      
      private function updateCoinsView(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.len)
         {
            if(param1[_loc2_] == 0)
            {
               param1[_loc2_] = 10;
            }
            this._num[_loc2_].setFrame(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function __onAction(param1:Event) : void
      {
         this.updateCoinsView(this._count.toString().split(""));
         if(this._action.currentFrame < 165)
         {
            if(this._action.currentFrame % 20 == 0)
            {
               ++this.len;
               if(this.len > this._count.toString().length)
               {
                  this.len = this._count.toString().length;
               }
               SoundManager.instance.play("210");
            }
            this.playCount();
            this.coinsDrop();
         }
         this.checkDrop();
         if(this._action.currentFrame == this._action.totalFrames - 1)
         {
            this.len = 0;
            this._action.stop();
            this._action.removeEventListener(Event.ENTER_FRAME,this.__onAction);
            this._action = null;
            if(this._cell != null)
            {
               this._cell.apply();
            }
            this._cell = null;
         }
      }
      
      private function coinsDrop() : void
      {
         var _loc1_:int = Math.random() * 3;
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("luckyStar.view.CoinsRain" + _loc1_);
         _loc2_.x = Math.random() * 700 + 100;
         this._list.push(_loc2_);
         addChildAt(_loc2_,0);
      }
      
      private function checkDrop() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._list.length)
         {
            this._list[_loc1_].y += 30;
            if(this._list[_loc1_].y > 500)
            {
               ObjectUtils.disposeObject(this._list[_loc1_]);
               this._list.splice(this._list.indexOf(this._list[_loc1_]),this._list.indexOf(this._list[_loc1_]));
            }
            _loc1_++;
         }
      }
      
      private function createCoinsNum(param1:int = 0) : ScaleFrameImage
      {
         var _loc2_:ScaleFrameImage = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.CoinsNum");
         _loc2_.setFrame(param1);
         if(this._action)
         {
            this._action.addChild(_loc2_);
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         while(this._list && this._list.length)
         {
            ObjectUtils.disposeObject(this._list.pop());
         }
         this._list = null;
         while(this._num && this._num.length)
         {
            ObjectUtils.disposeObject(this._num.pop());
         }
         this._num = null;
         this._cell = null;
         if(this._action)
         {
            this._action.stop();
            this._action.removeEventListener(Event.ENTER_FRAME,this.__onAction);
         }
         this._action = null;
      }
   }
}
