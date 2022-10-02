package game.view.control
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import game.model.LocalPlayer;
   
   public class ControlState extends Sprite implements Disposeable
   {
       
      
      protected var _self:LocalPlayer;
      
      protected var _container:DisplayObjectContainer;
      
      protected var _leavingFunc:Function;
      
      protected var _background:DisplayObject;
      
      public function ControlState(param1:LocalPlayer)
      {
         super();
         this._self = param1;
         this.configUI();
      }
      
      protected function configUI() : void
      {
      }
      
      protected function addEvent() : void
      {
      }
      
      protected function removeEvent() : void
      {
      }
      
      public function enter(param1:DisplayObjectContainer) : void
      {
         this._container = param1;
         this._container.addChild(this);
         this.addEvent();
         this.tweenIn();
      }
      
      protected function tweenIn() : void
      {
         y = 600;
         TweenLite.to(this,0.3,{
            "y":600 - height,
            "onComplete":this.enterComplete
         });
      }
      
      protected function tweenOut() : void
      {
         TweenLite.to(this,0.3,{
            "y":600,
            "onComplete":this.leavingComplete
         });
      }
      
      public function leaving(param1:Function = null) : void
      {
         this._leavingFunc = param1;
         this.removeEvent();
         this.tweenOut();
      }
      
      protected function enterComplete() : void
      {
      }
      
      protected function leavingComplete() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._leavingFunc != null)
         {
            this._leavingFunc.apply();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         TweenLite.killTweensOf(this);
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
