package store.view.strength
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import store.view.ConsortiaRateManager;
   
   public class MySmithLevel extends Component
   {
       
      
      private var _bg:Bitmap;
      
      private var _smithTxt:FilterFrameText;
      
      public function MySmithLevel()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.store.consortiaStoreLevelBG");
         addChild(this._bg);
         this._smithTxt = ComponentFactory.Instance.creatComponentByStylename("store.consortiaSmithLevelTxt");
         addChild(this._smithTxt);
         this._smithTxt.text = "LV." + ConsortiaRateManager.instance.smithLevel;
         tipData = LanguageMgr.GetTranslation("store.StoreIIComposeBG.consortiaSimthLevel");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            visible = false;
         }
      }
      
      private function initEvents() : void
      {
         ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._change);
      }
      
      private function removeEvents() : void
      {
         ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._change);
      }
      
      private function _change(param1:Event) : void
      {
         this._smithTxt.text = "LV." + ConsortiaRateManager.instance.smithLevel;
         visible = PlayerManager.Instance.Self.ConsortiaID == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvents();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._smithTxt)
         {
            ObjectUtils.disposeObject(this._smithTxt);
         }
         this._smithTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
