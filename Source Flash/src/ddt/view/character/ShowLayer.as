package ddt.view.character
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class ShowLayer extends BaseLayer
   {
       
      
      public function ShowLayer(param1:ItemTemplateInfo, param2:String = "", param3:Boolean = false, param4:int = 1, param5:String = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function getUrl(param1:int) : String
      {
         return PathManager.solveGoodsPath(_info.CategoryID,_pic,_info.NeedSex == 1,SHOW,_hairType,String(param1),_info.Level,_gunBack,int(_info.Property1));
      }
      
      override public function reSetBitmap() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
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
