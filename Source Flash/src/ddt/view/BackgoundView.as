package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class BackgoundView extends Sprite
   {
      
      private static var _instance:BackgoundView;
       
      
      public function BackgoundView()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
         this.initView();
      }
      
      public static function get Instance() : BackgoundView
      {
         if(_instance == null)
         {
            _instance = new BackgoundView();
         }
         return _instance;
      }
      
      public function hide() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_BOTTOM_LAYER,false,0,false);
      }
      
      private function initView() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.core.bg012");
         addChild(_loc1_);
      }
   }
}
