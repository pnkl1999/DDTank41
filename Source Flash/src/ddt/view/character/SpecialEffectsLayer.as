package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class SpecialEffectsLayer extends BaseLayer
   {
       
      
      private var _specialType:int;
      
      public function SpecialEffectsLayer(param1:int = 1)
      {
         this._specialType = param1;
         super(new ItemTemplateInfo());
      }
      
      override protected function getUrl(param1:int) : String
      {
         return PathManager.SITE_MAIN + "image/equip/effects/specialEffect/effect_" + param1 + ".png";
      }
      
      override protected function initLoaders() : void
      {
         var _loc1_:String = this.getUrl(this._specialType);
         var _loc2_:BitmapLoader = LoaderManager.Instance.creatLoader(_loc1_,BaseLoader.BITMAP_LOADER);
         _queueLoader.addLoader(_loc2_);
      }
   }
}
