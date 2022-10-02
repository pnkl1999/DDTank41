package game.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.animations.DirectionMovingAnimation;
   import game.view.map.MapView;
   
   public class SpringArrowView extends Sprite
   {
       
      
      private var _rect:Shape;
      
      private var _arrow:Bitmap;
      
      private var _map:MapView;
      
      private var _direction:String;
      
      private var _anit:DirectionMovingAnimation;
      
      private var _hand:MovieClip;
      
      private var _allowDrag:Boolean;
      
      public function SpringArrowView(param1:String, param2:MapView = null)
      {
         super();
         this._direction = param1;
         this.initView();
         this.initEvent();
         this._map = param2;
      }
      
      public function set allowDrag(param1:Boolean) : void
      {
         this._allowDrag = param1;
      }
      
      private function initView() : void
      {
         this._rect = new Shape();
         this._rect.graphics.beginFill(0,1);
         this._rect.graphics.drawRect(-66,-32,132,63);
         this._rect.graphics.endFill();
         this._rect.alpha = 0;
         addChild(this._rect);
         this._arrow = ComponentFactory.Instance.creatBitmap("asset.game.springArrowAsset");
         this._hand = ComponentFactory.Instance.creatCustomObject("asset.game.handHotAsset");
         this._hand.mouseChildren = false;
         this._hand.mouseEnabled = false;
         buttonMode = true;
         useHandCursor = true;
         switch(this._direction)
         {
            case DirectionMovingAnimation.LEFT:
               this._arrow.rotation = 180;
               this._arrow.x -= 20;
               this._hand.x = this._arrow.x - 22;
               this._hand.y = this._arrow.y - 28;
               x = width / 2 + 10;
               y = StageReferance.stageHeight / 2 + 10;
               break;
            case DirectionMovingAnimation.RIGHT:
               x = StageReferance.stageWidth - width / 2 - 60;
               y = StageReferance.stageHeight / 2;
               this._hand.x = this._arrow.x + 4;
               this._hand.y = this._arrow.y - 4;
               break;
            case DirectionMovingAnimation.UP:
               this._arrow.rotation = -90;
               this._rect.rotation = -90;
               x = StageReferance.stageWidth / 2;
               y = height / 2 + 20;
               this._hand.x = this._arrow.x;
               this._hand.y = this._arrow.y - 20;
               break;
            case DirectionMovingAnimation.DOWN:
               this._arrow.rotation = 90;
               this._rect.rotation = 90;
               x = StageReferance.stageWidth / 2;
               y = StageReferance.stageHeight - height / 2 - 90;
               this._hand.x = this._arrow.x - 30;
               this._hand.y = this._arrow.y;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__over,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.__down,false,0,true);
         addEventListener(MouseEvent.MOUSE_UP,this.__up,false,0,true);
      }
      
      private function __over(param1:MouseEvent) : void
      {
         addChild(this._arrow);
         addChild(this._hand);
      }
      
      private function __out(param1:MouseEvent) : void
      {
         if(this._arrow.parent)
         {
            this._arrow.parent.removeChild(this._arrow);
         }
         if(this._hand.parent)
         {
            this._hand.parent.removeChild(this._hand);
         }
         if(this._anit)
         {
            this._anit.cancel();
            this._anit = null;
         }
      }
      
      private function __up(param1:MouseEvent) : void
      {
         if(this._anit)
         {
            this._anit.cancel();
            this._anit = null;
         }
         addChild(this._hand);
      }
      
      private function __down(param1:MouseEvent) : void
      {
         if(this._allowDrag)
         {
            this._anit = new DirectionMovingAnimation(this._direction);
            this._map.animateSet.addAnimation(this._anit);
            if(this._hand.parent)
            {
               this._hand.parent.removeChild(this._hand);
            }
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.__down);
         removeEventListener(MouseEvent.MOUSE_UP,this.__up);
         removeChild(this._rect);
         this._rect = null;
         if(this._arrow.parent)
         {
            removeChild(this._arrow);
         }
         this._arrow.bitmapData.dispose();
         this._arrow = null;
         if(this._hand.parent)
         {
            removeChild(this._hand);
         }
         this._hand.stop();
         this._hand = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         this._map = null;
         this._anit = null;
      }
   }
}
