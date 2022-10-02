package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import game.model.Living;
   
   public class BaseMirariEffectIcon
   {
      
      public static const MIRARI_TYPE:int = 0;
       
      
      protected var _icon:Bitmap;
      
      protected var _iconClass:String;
      
      protected var _executed:Boolean = true;
      
      public var src:int = -1;
      
      public function BaseMirariEffectIcon()
      {
         super();
         this._icon = ComponentFactory.Instance.creatBitmap(this._iconClass) as Bitmap;
      }
      
      public function get single() : Boolean
      {
         return false;
      }
      
      public function get mirariType() : int
      {
         return 0;
      }
      
      public function getEffectIcon() : Bitmap
      {
         return this._icon;
      }
      
      public function excuteEffect(param1:Living) : void
      {
         this.excuteEffectImp(param1);
      }
      
      protected function excuteEffectImp(param1:Living) : void
      {
         this._executed = true;
      }
      
      public function unExcuteEffect(param1:Living) : void
      {
      }
      
      public function dispose() : void
      {
         this._icon = null;
      }
   }
}
