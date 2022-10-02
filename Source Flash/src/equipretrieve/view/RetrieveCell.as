package equipretrieve.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import equipretrieve.RetrieveController;
   import equipretrieve.RetrieveModel;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   
   public class RetrieveCell extends StoreCell
   {
      
      public static const SHINE_XY:int = 1;
      
      public static const SHINE_SIZE:int = 96;
       
      
      private var bg:Sprite;
      
      private var bgBit:Bitmap;
      
      public function RetrieveCell(param1:int)
      {
         this.bg = new Sprite();
         this.bgBit = ComponentFactory.Instance.creatBitmap("equipretrieve.trieveCell0");
         this.bg.addChild(this.bgBit);
         super(this.bg,param1);
         setContentSize(62,62);
         PicPos = new Point(10,10);
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
         _tbxCount = ComponentFactory.Instance.creat("equipretrieve.goodsCountText");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         RetrieveController.Instance.shine = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_.BagType == BagInfo.STOREBAG && this.info != null)
         {
            return;
         }
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,1);
            RetrieveModel.Instance.setSavePlaceType(_loc2_,index);
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!DoubleClickEnabled)
         {
            return;
         }
         if(info == null)
         {
            return;
         }
         if((param1.currentTarget as BagCell).info != null)
         {
            if((param1.currentTarget as BagCell).info != null)
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,index,RetrieveModel.Instance.getSaveCells(index).BagType,RetrieveModel.Instance.getSaveCells(index).Place);
               if(!mouseSilenced)
               {
                  SoundManager.instance.play("008");
               }
            }
         }
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
