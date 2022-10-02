package store
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.BagInfo;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class StoreCell extends BagCell
   {
       
      
      protected var _shiner:ShineObject;
      
      protected var _index:int;
      
      public var DoubleClickEnabled:Boolean = true;
      
      public var mouseSilenced:Boolean = false;
      
      public function StoreCell(param1:Sprite, param2:int)
      {
         super(0,null,false,param1);
         this._index = param2;
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.store.cellShine"));
         addChild(this._shiner);
         this._shiner.mouseEnabled = false;
         this._shiner.mouseChildren = false;
         if(_cellMouseOverBg)
         {
            ObjectUtils.disposeObject(_cellMouseOverBg);
         }
         _cellMouseOverBg = null;
         tipDirctions = "7,5,2,6,4,1";
         PicPos = new Point(3,3);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("store.stoneCountText");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!this.DoubleClickEnabled)
         {
            return;
         }
         if(info == null)
         {
            return;
         }
         if((param1.currentTarget as BagCell).info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,this.index,this.itemBagType,-1);
            if(!this.mouseSilenced)
            {
               SoundManager.instance.play("008");
            }
         }
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.play("008");
         }
         dragStart();
      }
      
      public function get itemBagType() : int
      {
         if(info && (info.CategoryID == 10 || info.CategoryID == 11 || info.CategoryID == 12))
         {
            return BagInfo.PROPBAG;
         }
         return BagInfo.EQUIPBAG;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function startShine() : void
      {
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
