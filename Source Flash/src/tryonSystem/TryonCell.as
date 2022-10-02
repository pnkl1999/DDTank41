package tryonSystem
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class TryonCell extends ShopItemCell
   {
       
      
      private var _background:Bitmap;
      
      public function TryonCell(param1:DisplayObject, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Boolean = true)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function init() : void
      {
         super.init();
         this._background = ComponentFactory.Instance.creatBitmap("asset.core.cellBG");
         addChildAt(this._background,0);
         overBg = ComponentFactory.Instance.creatBitmap("asset.core.cellLight");
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(!overBg.visible && param1)
         {
            SoundManager.instance.play("008");
         }
         overBg.visible = param1;
         TaskManager.itemAwardSelected = this.info.TemplateID;
      }
      
      public function get selected() : Boolean
      {
         return overBg.visible;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         super.dispose();
      }
   }
}
