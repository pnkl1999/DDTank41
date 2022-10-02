package labyrinth.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   
   public class CleanOutConfirmView extends SimpleAlert
   {
       
      
      private var _vip6cut:Bitmap;
      
      private var _vip9cut:Bitmap;
      
      public function CleanOutConfirmView()
      {
         super();
      }
      
      override public function set info(param1:AlertInfo) : void
      {
         super.info = param1;
         this._vip6cut = ComponentFactory.Instance.creat("ddt.labyrinth.CleanOutFrame.VIP6cut");
         addToContent(this._vip6cut);
         this._vip9cut = ComponentFactory.Instance.creat("ddt.labyrinth.CleanOutFrame.VIP9cut");
         addToContent(this._vip9cut);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._vip6cut);
         this._vip6cut = null;
         ObjectUtils.disposeObject(this._vip9cut);
         this._vip9cut = null;
         super.dispose();
      }
   }
}
