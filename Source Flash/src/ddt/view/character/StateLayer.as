package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import flash.events.Event;
   
   public class StateLayer extends BaseLayer
   {
       
      
      private var _stateType:int;
      
      private var _sex:Boolean;
      
      public function StateLayer(param1:ItemTemplateInfo, param2:Boolean, param3:String, param4:int = 1)
      {
         this._stateType = param4;
         this._sex = param2;
         super(param1,param3);
      }
      
      override protected function getUrl(param1:int) : String
      {
         return PathManager.SITE_MAIN + "image/equip/effects/state/" + (!!this._sex ? "m/" : "f/") + this._stateType + "/show" + param1 + ".png";
      }
      
      override protected function initLoaders() : void
      {
         var _loc2_:String = null;
         var _loc3_:BitmapLoader = null;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = this.getUrl(_loc1_ + 1);
            _loc3_ = LoaderManager.Instance.creatLoader(_loc2_,BaseLoader.BITMAP_LOADER);
            _queueLoader.addLoader(_loc3_);
            _loc1_++;
         }
         _defaultLayer = 0;
         _currentEdit = _queueLoader.length;
      }
      
      override protected function __loadComplete(param1:Event) : void
      {
         reSetBitmap();
         _queueLoader.removeEventListener(Event.COMPLETE,this.__loadComplete);
         _queueLoader.removeEvent();
         initColors(_color);
         loadCompleteCallBack();
      }
   }
}
