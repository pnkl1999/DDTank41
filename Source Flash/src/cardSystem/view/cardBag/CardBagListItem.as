package cardSystem.view.cardBag
{
   import cardSystem.data.CardInfo;
   import cardSystem.elements.CardBagCell;
   import cardSystem.elements.CardCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardBagListItem extends Sprite implements Disposeable, IListCell
   {
      
      public static const CELL_NUM:int = 4;
       
      
      private var _dataVec:Array;
      
      private var _cellVec:Vector.<CardCell>;
      
      private var _container:HBox;
      
      public function CardBagListItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get cellVec() : Vector.<CardCell>
      {
         return this._cellVec;
      }
      
      private function initEvent() : void
      {
      }
      
      private function initView() : void
      {
         var _loc2_:CardBagCell = null;
         this._dataVec = new Array();
         this._cellVec = new Vector.<CardCell>(CELL_NUM);
         this._container = ComponentFactory.Instance.creatComponentByStylename("cardBagListItem.container");
         var _loc1_:int = 0;
         while(_loc1_ < CELL_NUM)
         {
            _loc2_ = new CardBagCell(ComponentFactory.Instance.creatBitmap("asset.cardBag.cardBG"));
            _loc2_.setContentSize(71,96);
            _loc2_.canShine = true;
            _loc2_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            this._container.addChild(_loc2_);
            this._cellVec[_loc1_] = _loc2_;
            _loc1_++;
         }
         addChild(this._container);
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         var _loc2_:CardBagCell = param1.currentTarget as CardBagCell;
         if(_loc2_.cardInfo)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         var _loc3_:ItemTemplateInfo = null;
         param1.stopImmediatePropagation();
         var _loc2_:CardBagCell = param1.currentTarget as CardBagCell;
         if(_loc2_)
         {
            _loc3_ = _loc2_.info as ItemTemplateInfo;
         }
         if(_loc3_ == null)
         {
            return;
         }
         if(!_loc2_.locked)
         {
            SoundManager.instance.play("008");
            _loc2_.dragStart();
         }
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:CardBagCell = param1.currentTarget as CardBagCell;
         if(_loc2_.cardInfo)
         {
            if(_loc2_ && !_loc2_.locked)
            {
               if(_loc2_.cardInfo.templateInfo.Property8 == "1")
               {
                  SocketManager.Instance.out.sendMoveCards(_loc2_.cardInfo.Place,0);
                  return;
               }
               _loc3_ = 1;
               while(_loc3_ < 5)
               {
                  if(_loc3_ < 3)
                  {
                     if(PlayerManager.Instance.Self.cardEquipDic[_loc3_] == null || PlayerManager.Instance.Self.cardEquipDic[_loc3_].Count < 0)
                     {
                        SocketManager.Instance.out.sendMoveCards(_loc2_.cardInfo.Place,_loc3_);
                        return;
                     }
                  }
                  else
                  {
                     if(_loc3_ == 3 && PlayerManager.Instance.Self.cardEquipDic[3] && PlayerManager.Instance.Self.cardEquipDic[3].Count < 0)
                     {
                        SocketManager.Instance.out.sendMoveCards(_loc2_.cardInfo.Place,3);
                        return;
                     }
                     if(_loc3_ == 4 && PlayerManager.Instance.Self.cardEquipDic[4] && PlayerManager.Instance.Self.cardEquipDic[4].Count < 0)
                     {
                        SocketManager.Instance.out.sendMoveCards(_loc2_.cardInfo.Place,4);
                        return;
                     }
                  }
                  if(_loc3_ == 4)
                  {
                     SocketManager.Instance.out.sendMoveCards(_loc2_.cardInfo.Place,1);
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._dataVec;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._dataVec = param1;
         this.upView();
      }
      
      override public function get height() : Number
      {
         return this._container.height;
      }
      
      private function upView() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < CELL_NUM)
         {
            this._cellVec[_loc1_].place = this._dataVec[0] * 4 + _loc1_ + 1;
            if(this._dataVec[_loc1_ + 1])
            {
               this._cellVec[_loc1_].cardInfo = this._dataVec[_loc1_ + 1] as CardInfo;
            }
            else
            {
               this._cellVec[_loc1_].cardInfo = null;
            }
            _loc1_++;
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this._dataVec = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._cellVec.length)
         {
            this._cellVec[_loc1_].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            this._cellVec[_loc1_].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            this._cellVec[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            DoubleClickManager.Instance.disableDoubleClick(this._cellVec[_loc1_]);
            this._cellVec[_loc1_].dispose();
            this._cellVec[_loc1_] = null;
            _loc1_++;
         }
         this._cellVec = null;
         DoubleClickManager.Instance.clearTarget();
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         this.removeEvent();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
