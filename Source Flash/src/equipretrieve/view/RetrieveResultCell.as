package equipretrieve.view
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import store.StoreCell;
   
   public class RetrieveResultCell extends StoreCell
   {
      
      public static const SHINE_XY:int = 5;
      
      public static const SHINE_SIZE:int = 76;
       
      
      private var bg:Sprite;
      
      private var bgBit:Bitmap;
      
      public function RetrieveResultCell(param1:int)
      {
         this.bg = new Sprite();
         this.bgBit = ComponentFactory.Instance.creatBitmap("equipretrieve.trieveCell1");
         this.bg.addChild(this.bgBit);
         super(this.bg,param1);
      }
      
      override public function startShine() : void
      {
         _shiner.x = SHINE_XY;
         _shiner.y = SHINE_XY;
         _shiner.width = _shiner.height = SHINE_SIZE;
         super.startShine();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("equipretrieve.goodsCountTextII");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.bgBit)
         {
            ObjectUtils.disposeObject(this.bgBit);
         }
         if(this.bg)
         {
            ObjectUtils.disposeObject(this.bg);
         }
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         this.bgBit = null;
         this.bg = null;
         _tbxCount = null;
      }
   }
}
