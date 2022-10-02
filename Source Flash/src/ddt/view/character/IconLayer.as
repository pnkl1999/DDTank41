package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class IconLayer extends BaseLayer
   {
       
      
      public function IconLayer(param1:ItemTemplateInfo, param2:String = "", param3:Boolean = false, param4:int = 1)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function initLoaders() : void
      {
         var _loc1_:String = null;
         var _loc2_:BitmapLoader = null;
         if(_info != null)
         {
            _loc1_ = this.getUrl(1);
            _loc2_ = LoaderManager.Instance.creatLoader(_loc1_,BaseLoader.BITMAP_LOADER);
            _queueLoader.addLoader(_loc2_);
            _defaultLayer = 0;
            _currentEdit = _info.Property8 == null ? uint(uint(0)) : uint(uint(_info.Property8.length));
         }
      }
      
      override protected function getUrl(param1:int) : String
      {
         return PathManager.solveGoodsPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,BaseLayer.ICON,_hairType,String(param1),_info.Level,_gunBack,int(_info.Property1));
      }
   }
}
