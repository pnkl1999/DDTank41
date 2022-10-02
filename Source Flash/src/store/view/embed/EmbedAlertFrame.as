package store.view.embed
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   
   public class EmbedAlertFrame extends BaseAlerFrame
   {
      
      public static const ADDFrameHeight:int = 60;
       
      
      public function EmbedAlertFrame()
      {
         super();
      }
      
      public function show(param1:DisplayObject) : void
      {
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc2_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc2_.cancelLabel = LanguageMgr.GetTranslation("cancel");
         _loc2_.data = param1;
         info = _loc2_;
         addToContent(param1);
         width = param1.width + _containerX * 2;
         height = param1.height + _containerY + ADDFrameHeight;
         moveEnable = false;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
