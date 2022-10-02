package game.view.propContainer
{
   import bagAndInfo.bag.ItemCellView;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import ddt.data.PropInfo;
   import ddt.events.ItemEvent;
   import ddt.view.PropItemView;
   import flash.display.DisplayObject;
   
   [Event(name="itemClick",type="ddt.events.ItemEvent")]
   [Event(name="itemOver",type="ddt.events.ItemEvent")]
   [Event(name="itemOut",type="ddt.events.ItemEvent")]
   [Event(name="itemMove",type="ddt.events.ItemEvent")]
   public class ItemContainer extends SimpleTileList
   {
      
      public static var USE_THREE:String = "use_threeSkill";
      
      public static var PLANE:int = 1;
      
      public static var THREE_SKILL:int = 2;
      
      public static var BOTH:int = 3;
       
      
      private var list:Array;
      
      private var _ordinal:Boolean;
      
      private var _clickAble:Boolean;
      
      public function ItemContainer(param1:Number, param2:Number = 1, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false, param6:String = "")
      {
         var _loc8_:ItemCellView = null;
         super(param2);
         vSpace = 4;
         hSpace = 6;
         this.list = new Array();
         var _loc7_:int = 0;
         while(_loc7_ < param1)
         {
            _loc8_ = new ItemCellView(_loc7_,null,false,param6);
            _loc8_.addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            _loc8_.addEventListener(ItemEvent.ITEM_OVER,this.__itemOver);
            _loc8_.addEventListener(ItemEvent.ITEM_OUT,this.__itemOut);
            _loc8_.addEventListener(ItemEvent.ITEM_MOVE,this.__itemMove);
            addChild(_loc8_);
            this.list.push(_loc8_);
            _loc7_++;
         }
         this._clickAble = param5;
         this._ordinal = param4;
      }
      
      public function setState(param1:Boolean, param2:Boolean) : void
      {
         this._clickAble = param1;
         this.setItemState(param1,param2);
      }
      
      public function get clickAble() : Boolean
      {
         return this._clickAble;
      }
      
      public function appendItem(param1:DisplayObject) : void
      {
         var _loc2_:ItemCellView = null;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.item == null)
            {
               _loc2_.setItem(param1,false);
               return;
            }
         }
      }
      
      public function get blankItems() : Array
      {
         var _loc3_:ItemCellView = null;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         for each(_loc3_ in this.list)
         {
            if(_loc3_.item == null)
            {
               _loc1_.push(_loc2_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function mouseClickAt(param1:int) : void
      {
         this.list[param1].mouseClick();
      }
      
      private function __itemClick(param1:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,param1.item,param1.index));
      }
      
      private function __itemOver(param1:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OVER,param1.item,param1.index));
      }
      
      private function __itemOut(param1:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OUT,param1.item,param1.index));
      }
      
      private function __itemMove(param1:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_MOVE,param1.item,param1.index));
      }
      
      public function appendItemAt(param1:DisplayObject, param2:int) : void
      {
         var _loc3_:ItemCellView = null;
         var _loc4_:int = 0;
         if(this._ordinal)
         {
            _loc3_ = this.list[this.list.length - 1] as ItemCellView;
            _loc4_ = param2;
            while(_loc4_ < this.list.length - 1)
            {
               this.list[_loc4_ + 1] = this.list[_loc4_];
               _loc4_++;
            }
            this.list[param2] = _loc3_;
            _loc3_.setItem(param1,false);
         }
         else
         {
            _loc3_ = this.list[param2];
            _loc3_.setItem(param1,false);
         }
      }
      
      public function removeItem(param1:DisplayObject) : void
      {
         var _loc3_:ItemCellView = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.list.length)
         {
            _loc3_ = this.list[_loc2_];
            if(_loc3_.item == param1)
            {
               removeChild(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function removeItemAt(param1:int) : void
      {
         var _loc2_:ItemCellView = this.list[param1];
         _loc2_.setItem(null,false);
         if(this._ordinal)
         {
            this.list.splice(param1,1);
            removeChild(_loc2_);
            this.list.push(_loc2_);
         }
      }
      
      public function clear() : void
      {
         var _loc1_:ItemCellView = null;
         for each(_loc1_ in this.list)
         {
            _loc1_.setItem(null,false);
         }
      }
      
      public function setItemClickAt(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this.list[param1].setClick(param2,param3,false);
      }
      
      public function disableCellIndex(param1:int) : void
      {
         this.list[param1].disable();
      }
      
      public function disableSelfProp(param1:int) : void
      {
         var _loc2_:ItemCellView = null;
         var _loc3_:PropInfo = null;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.item)
            {
               _loc3_ = PropItemView(_loc2_.item).info;
               if(_loc3_.Template.TemplateID == 10016 && (param1 == 1 || param1 == 3))
               {
                  _loc2_.disable();
               }
               else if(_loc3_.Template.TemplateID == 10003 && (param1 == 2 || param1 == 3))
               {
                  _loc2_.disable();
               }
            }
         }
      }
      
      public function disableCellArr() : void
      {
         var _loc1_:ItemCellView = null;
         for each(_loc1_ in this.list)
         {
            _loc1_.disable();
         }
      }
      
      public function setNoClickAt(param1:int) : void
      {
         this.list[param1].setNoEnergyAsset();
      }
      
      private function setItemState(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:ItemCellView = null;
         var _loc4_:Boolean = false;
         for each(_loc3_ in this.list)
         {
            _loc4_ = false;
            if(PropItemView(_loc3_.item) != null)
            {
               _loc4_ = PropItemView(_loc3_.item).isExist;
            }
            _loc3_.setClick(param1,param2,_loc4_);
         }
      }
      
      public function setClickByEnergy(param1:int) : void
      {
         var _loc2_:ItemCellView = null;
         var _loc3_:PropInfo = null;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.item)
            {
               _loc3_ = PropItemView(_loc2_.item).info;
               if(_loc3_)
               {
                  if(param1 < _loc3_.needEnergy)
                  {
                     _loc2_.setClick(true,true,PropItemView(_loc2_.item).isExist);
                  }
               }
            }
         }
      }
      
      public function setVisible(param1:int, param2:Boolean) : void
      {
         this.list[param1].visible = param2;
      }
      
      override public function dispose() : void
      {
         var _loc1_:ItemCellView = null;
         super.dispose();
         while(this.list.length > 0)
         {
            _loc1_ = this.list.shift() as ItemCellView;
            _loc1_.dispose();
         }
         this.list = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
