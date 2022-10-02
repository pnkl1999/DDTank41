package worldboss.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.core.Component;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import worldboss.WorldBossManager;
   import worldboss.model.WorldBossBuffInfo;
   
   public class BuffItem extends Component
   {
       
      
      private var _buffId:int;
      
      public function BuffItem(param1:int)
      {
         super();
         this._buffId = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:BitmapLoader = LoaderManager.Instance.creatLoader(WorldBossRoomView.getImagePath(this._buffId),BaseLoader.BITMAP_LOADER);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.__buffIconComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      private function __buffIconComplete(param1:LoaderEvent) : void
      {
         var _loc3_:Bitmap = null;
         if(param1.loader.isSuccess)
         {
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__buffIconComplete);
            _loc3_ = param1.loader.content as Bitmap;
            _loc3_.width = 50;
            _loc3_.height = 50;
            addChild(_loc3_);
         }
         tipStyle = "ddt.view.tips.OneLineTip";
         tipDirctions = "5,1";
         var _loc2_:WorldBossBuffInfo = WorldBossManager.Instance.bossInfo.getbuffInfoByID(this._buffId);
         tipData = _loc2_.name + ":" + LanguageMgr.GetTranslation("worldboss.buff.limit") + "\n" + _loc2_.decription;
      }
   }
}
