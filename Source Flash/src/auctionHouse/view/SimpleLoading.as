package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class SimpleLoading extends Sprite implements Disposeable
   {
      
      public static var _instance:SimpleLoading;
       
      
      private var _view:Sprite;
      
      public function SimpleLoading()
      {
         super();
         this._view = ComponentFactory.Instance.creat("asset.auctionHouse.simpleLoading");
         addChild(this._view);
      }
      
      public static function get instance() : SimpleLoading
      {
         if(_instance == null)
         {
            _instance = new SimpleLoading();
         }
         return _instance;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.STAGE_DYANMIC_LAYER,true);
      }
      
      public function hide() : void
      {
         this.dispose();
      }
      
      public function dispose() : void
      {
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         if(_instance)
         {
            _instance = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
