package ddt.view.bossbox
{
   import com.pickgliss.ui.core.TransformableComponent;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class TimeTip extends TransformableComponent
   {
       
      
      private var _closeBox:Sprite;
      
      private var _delayText:Sprite;
      
      public function TimeTip()
      {
         super();
      }
      
      public function setView(param1:Sprite, param2:Sprite) : void
      {
         this._closeBox = param1;
         this._delayText = param2;
         addChild(this._closeBox);
         addChild(this._delayText);
      }
      
      public function get closeBox() : Sprite
      {
         return this._closeBox;
      }
      
      public function get delayText() : Sprite
      {
         return this._delayText;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._closeBox)
         {
            ObjectUtils.disposeObject(this._closeBox);
         }
         this._closeBox = null;
         if(this._delayText)
         {
            ObjectUtils.disposeObject(this._delayText);
         }
         this._delayText = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
