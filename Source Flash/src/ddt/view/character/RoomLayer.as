package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class RoomLayer extends BaseLayer
   {
       
      
      private var _clothType:int = 0;
      
      public function RoomLayer(param1:ItemTemplateInfo, param2:String = "", param3:Boolean = false, param4:int = 1, param5:String = null, param6:int = 0)
      {
         this._clothType = param6;
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function getUrl(param1:int) : String
      {
         if(this._clothType == 0)
         {
            return PathManager.solveGoodsPath(_info.CategoryID,_pic,_info.NeedSex == 1,SHOW,_hairType,String(param1),_info.Level,_gunBack,int(_info.Property1));
         }
         return "normal.png";
      }
      
      override protected function initLoaders() : void
      {
         var _loc1_:String = null;
         var _loc2_:BitmapLoader = null;
         if(_info)
         {
            _loc1_ = this.getUrl(0);
            _loc2_ = LoaderManager.Instance.creatLoader(_loc1_,BaseLoader.BITMAP_LOADER);
            _queueLoader.addLoader(_loc2_);
         }
      }
      
      override public function reSetBitmap() : void
      {
         var _loc1_:int = 0;
         clearBitmap();
         _loc1_ = 0;
         while(_loc1_ < _queueLoader.loaders.length)
         {
            _bitmaps.push(_queueLoader.loaders[_loc1_].content);
            if(_bitmaps[_loc1_])
            {
               _bitmaps[_loc1_].smoothing = true;
               _bitmaps[_loc1_].visible = false;
               addChild(_bitmaps[_loc1_]);
            }
            _loc1_++;
         }
      }
   }
}
