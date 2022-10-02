package farm.view.compose.item
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ComposeItem extends BaseCell
   {
       
      
      protected var _tbxUseCount:FilterFrameText;
      
      protected var _tbxCount:FilterFrameText;
      
      private var _total:int;
      
      private var _need:int;
      
      public function ComposeItem(param1:DisplayObject)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("farmHouse.text.composeCount1");
         this._tbxCount.mouseEnabled = false;
         this._tbxUseCount = ComponentFactory.Instance.creatComponentByStylename("farmHouse.text.composeCount2");
         this._tbxUseCount.mouseEnabled = false;
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         PositionUtils.setPos(param1,"farm.componseItem.cellPos");
         param1.width = 50;
         param1.height = 50;
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         addChild(this._tbxUseCount);
         addChild(this._tbxCount);
         if(param1)
         {
            this._total = PlayerManager.Instance.Self.getBag(BagInfo.VEGETABLE).getItemCountByTemplateId(param1.TemplateID);
            this._tbxCount.text = this._total.toString();
         }
         else
         {
            this._tbxCount.text = "";
            this._tbxUseCount.text = "";
         }
      }
      
      public function set useCount(param1:int) : void
      {
         this._need = param1;
         this._tbxUseCount.text = param1 > 0 ? "/" + param1.toString() : "";
         this.fixPos();
      }
      
      private function fixPos() : void
      {
         if(this._tbxCount && this._tbxUseCount)
         {
            this._tbxUseCount.x = this.width - this._tbxUseCount.width - 6;
            this._tbxCount.x = this._tbxUseCount.x - this._tbxCount.textWidth - 1;
         }
      }
      
      public function get maxCount() : int
      {
         return int(this._total / this._need);
      }
      
      override public function dispose() : void
      {
         this._need = 0;
         this._total = 0;
         if(this._tbxUseCount)
         {
            ObjectUtils.disposeObject(this._tbxUseCount);
            this._tbxUseCount = null;
         }
         if(this._tbxCount)
         {
            ObjectUtils.disposeObject(this._tbxCount);
            this._tbxCount = null;
         }
         super.dispose();
      }
   }
}
