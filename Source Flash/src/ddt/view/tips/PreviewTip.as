package ddt.view.tips
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PreviewTip extends Sprite implements Disposeable, ITransformableTip
   {
       
      
      private var _tipData:Object;
      
      public function PreviewTip()
      {
         super();
      }
      
      public function get tipWidth() : int
      {
         return width;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return height;
      }
      
      public function set tipHeight(param1:int) : void
      {
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(!param1 || param1 is DisplayObject == false)
         {
            return;
         }
         if(param1 == this._tipData)
         {
            return;
         }
         this._tipData = param1;
         ObjectUtils.disposeAllChildren(this);
         addChild(this._tipData as DisplayObject);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
