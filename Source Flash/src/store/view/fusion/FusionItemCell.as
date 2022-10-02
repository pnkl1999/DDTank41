package store.view.fusion
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   import store.StrengthDataManager;
   
   public class FusionItemCell extends StoreCell
   {
      
      public static const SHINE_XY:int = 5;
      
      public static const SHINE_SIZE:int = 76;
       
      
      private var bg:Sprite;
      
      private var canMouseEvt:Boolean;
      
      private var _autoSplit:Boolean;
      
      public function FusionItemCell(param1:int)
      {
         this.bg = new Sprite();
         this.canMouseEvt = true;
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.FusionCellBG");
         this.bg.addChild(_loc2_);
         super(this.bg,param1);
         PicPos = new Point(3,3);
      }
      
      public function set bgVisible(param1:Boolean) : void
      {
         this.bg.alpha = int(param1);
      }
      
      override public function startShine() : void
      {
         _shiner.x = SHINE_XY;
         _shiner.y = SHINE_XY;
         _shiner.width = _shiner.height = SHINE_SIZE;
         super.startShine();
      }
      
      public function set mouseEvt(param1:Boolean) : void
      {
         this.canMouseEvt = param1;
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!this.canMouseEvt)
         {
            return;
         }
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
               if(StrengthDataManager.instance.autoFusion)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
               }
               else
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,index,itemBagType,-1);
               }
               if(!mouseSilenced)
               {
                  SoundManager.instance.play("008");
               }
            }
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(!this.canMouseEvt)
         {
            return;
         }
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.play("008");
         }
         this.dragStart();
      }
      
      override public function dragStart() : void
      {
         super.dragStart();
         StoreIIFusionBG.lastIndexFusion = index;
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         super.dragStop(param1);
         StoreIIFusionBG.lastIndexFusion = -1;
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.width = _contentWidth - 4;
            param1.height = _contentHeight - 4;
            if(_picPos != null)
            {
               param1.x = _picPos.x;
            }
            else
            {
               param1.x = Math.abs(param1.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               param1.y = _picPos.y;
            }
            else
            {
               param1.y = Math.abs(param1.height - _contentHeight) / 2;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("store.FunsionstoneCountTextII");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:FusionSelectNumAlertFrame = null;
         if(!this.canMouseEvt)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
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
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.overdue"));
               return;
            }
            if(_loc2_.Property1 == StoneType.FORMULA)
            {
               return;
            }
            if(_loc2_.FusionType == 0 || _loc2_.FusionRate == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));
               return;
            }
            if(StrengthDataManager.instance.autoFusion)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
               return;
            }
            if(_loc2_.Count > 1)
            {
               this._autoSplit = (this.parent as StoreIIFusionBG).isAutoSplit;
               if(false && StoreIIFusionBG.lastIndexFusion == -1)
               {
                  StoreIIFusionBG.autoSplitSend(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,StoreIIFusionBG.getRemainIndexByEmpty(_loc2_.Count,this.parent as StoreIIFusionBG),_loc2_.Count,true,this.parent as StoreIIFusionBG);
               }
               else
               {
                  _loc3_ = ComponentFactory.Instance.creat("store.FusionSelectNumAlertFrame");
                  _loc3_.goodsinfo = _loc2_;
                  _loc3_.index = index;
                  _loc3_.show(_loc2_.Count);
                  _loc3_.addEventListener(FusionSelectEvent.SELL,this._alerSell);
                  _loc3_.addEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
               }
            }
            else
            {
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,_loc2_.Count,true);
            }
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      private function _alerSell(param1:FusionSelectEvent) : void
      {
         var _loc2_:FusionSelectNumAlertFrame = param1.currentTarget as FusionSelectNumAlertFrame;
         SocketManager.Instance.out.sendMoveGoods(param1.info.BagType,param1.info.Place,BagInfo.STOREBAG,param1.index,param1.sellCount,true);
         _loc2_.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _loc2_.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      private function _alerNotSell(param1:FusionSelectEvent) : void
      {
         var _loc2_:FusionSelectNumAlertFrame = param1.currentTarget as FusionSelectNumAlertFrame;
         _loc2_.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _loc2_.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
