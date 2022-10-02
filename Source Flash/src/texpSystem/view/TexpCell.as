package texpSystem.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class TexpCell extends BagCell
   {
       
      
      private var _shiner:ShineObject;
      
      public function TexpCell()
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.texpSystem.itemBg");
         _loc1_.addChild(_loc2_);
         super(0,null,true,_loc1_);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.texpSystem.cellShine"));
         addChild(this._shiner);
         this._shiner.mouseEnabled = false;
         this._shiner.mouseChildren = false;
         var _loc3_:Rectangle = ComponentFactory.Instance.creatCustomObject("texpSystem.texpCell.content");
         setContentSize(_loc3_.width,_loc3_.height);
         PicPos = new Point(_loc3_.x,_loc3_.y);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.CategoryID != EquipType.TEXP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.typeError"));
               return;
            }
            SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,0,_loc2_.Count,true);
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("texpSystem.txtCount");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
      }
      
      public function startShine() : void
      {
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
      }
      
      private function __clickHandler(param1:InteractiveEvent) : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.playButtonSound();
         }
         dragStart();
      }
      
      override public function dispose() : void
      {
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         super.dispose();
      }
   }
}
