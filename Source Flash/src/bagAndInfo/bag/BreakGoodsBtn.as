package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import ddt.interfaces.ICell;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class BreakGoodsBtn extends SimpleBitmapButton implements IDragable
   {
       
      
      private var _dragTarget:BagCell;
      
      private var _enabel:Boolean;
      
      private var win:BreakGoodsView;
      
      private var myColorMatrix_filter:ColorMatrixFilter;
      
      private var lightingFilter:ColorMatrixFilter;
      
      public function BreakGoodsBtn()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         this.initEvent();
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         if(!PlayerManager.Instance.Self.bagLocked)
         {
            this.dragStart(param1.stageX,param1.stageY);
         }
      }
      
      public function dragStart(param1:Number, param2:Number) : void
      {
         DragManager.startDrag(this,this,ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.breakIconAsset"),param1,param2,DragEffect.MOVE);
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         var _loc2_:BagCell = null;
         if(param1.action == DragEffect.MOVE && param1.target is ICell)
         {
            _loc2_ = param1.target as BagCell;
            if(_loc2_)
            {
               if(_loc2_.itemInfo.Count > 1 && _loc2_.itemInfo.BagType != 11)
               {
                  this._dragTarget = _loc2_;
                  SoundManager.instance.play("008");
                  if(this.win == null)
                  {
                     this.win = ComponentFactory.Instance.creatComponentByStylename("breakGoodsView");
                  }
                  else
                  {
                     this.win.dispose();
                     this.win = null;
                     this.win = ComponentFactory.Instance.creatComponentByStylename("breakGoodsView");
                  }
                  this.win.cell = _loc2_;
                  this.win.show();
               }
            }
         }
      }
      
      private function breakBack() : void
      {
         if(this._dragTarget)
         {
         }
         if(stage)
         {
            this.dragStart(stage.mouseX,stage.mouseY);
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function getDragData() : Object
      {
         return this;
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._dragTarget)
         {
            this._dragTarget.locked = false;
         }
         PlayerManager.Instance.Self.Bag.unLockAll();
         if(this.win != null)
         {
            this.win.dispose();
         }
         this.win = null;
         super.dispose();
      }
      
      private function __addToStage(param1:Event) : void
      {
      }
      
      private function __removeFromStage(param1:Event) : void
      {
      }
      
      private function cancelBack() : void
      {
         if(this._dragTarget)
         {
            this._dragTarget.locked = false;
         }
      }
   }
}
