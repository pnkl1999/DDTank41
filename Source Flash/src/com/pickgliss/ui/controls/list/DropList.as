package com.pickgliss.ui.controls.list
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.cell.IDropListCell;
   import com.pickgliss.ui.controls.container.BoxContainer;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class DropList extends Component implements Disposeable
   {
      
      public static const SELECTED:String = "selected";
      
      public static const P_backgound:String = "backgound";
      
      public static const P_container:String = "container";
       
      
      private var _backStyle:String;
      
      private var _backGround:DisplayObject;
      
      private var _cellStyle:String;
      
      private var _containerStyle:String;
      
      private var _container:BoxContainer;
      
      private var _targetDisplay:IDropListTarget;
      
      private var _showLength:int;
      
      private var _dataList:Array;
      
      private var _items:Vector.<IDropListCell>;
      
      private var _currentSelectedIndex:int;
      
      private var _preItemIdx:int;
      
      private var _cellHeight:int;
      
      private var _cellWidth:int;
      
      private var _isListening:Boolean;
      
      private var _canUseEnter:Boolean = true;
      
      public function DropList()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._items = new Vector.<IDropListCell>();
      }
      
      public function set container(param1:BoxContainer) : void
      {
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         this._container = param1;
         onPropertiesChanged(P_container);
      }
      
      public function set containerStyle(param1:String) : void
      {
         if(this._containerStyle == param1)
         {
            return;
         }
         this._containerStyle = param1;
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         this.container = ComponentFactory.Instance.creat(this._containerStyle);
      }
      
      public function set cellStyle(param1:String) : void
      {
         if(this._cellStyle == param1)
         {
            return;
         }
         this._cellStyle = param1;
      }
      
      public function set dataList(param1:Array) : void
      {
         if(!param1)
         {
            if(parent)
            {
               parent.removeChild(this);
            }
            return;
         }
         if(this._targetDisplay.parent)
         {
            this._targetDisplay.parent.addChild(this);
         }
         this._dataList = param1;
         var _loc2_:int = Math.min(this._dataList.length,this._showLength);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._items[_loc3_].setCellValue(this._dataList[_loc3_]);
            if(!this._container.contains(this._items[_loc3_].asDisplayObject()))
            {
               this._container.addChild(this._items[_loc3_].asDisplayObject());
            }
            _loc3_++;
         }
         if(_loc2_ == 0)
         {
            this._items[0].setCellValue(null);
            if(!this._container.contains(this._items[_loc3_].asDisplayObject()))
            {
               this._container.addChild(this._items[_loc3_].asDisplayObject());
            }
            _loc2_ = 1;
         }
         _loc3_ = _loc2_;
         while(_loc3_ < this._showLength)
         {
            if(this._container.contains(this._items[_loc3_].asDisplayObject()))
            {
               this._container.removeChild(this._items[_loc3_].asDisplayObject());
            }
            _loc3_++;
         }
         this.updateBg();
         this.unSelectedAllItems();
         this._currentSelectedIndex = 0;
         this._items[this._currentSelectedIndex].selected = true;
      }
      
      private function updateBg() : void
      {
         if(this._container.numChildren == 0)
         {
            if(contains(this._backGround))
            {
               removeChild(this._backGround);
            }
         }
         else
         {
            this._backGround.width = this._cellWidth + 2 * this._container.x;
            this._backGround.height = this._container.numChildren * (this._cellHeight + this._container.spacing) - this._container.spacing + 2 * this._container.y;
            addChildAt(this._backGround,0);
         }
      }
      
      private function getHightLightItemIdx() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._showLength)
         {
            if(this._items[_loc1_].selected)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      private function unSelectedAllItems() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._showLength)
         {
            if(this._items[_loc2_].selected)
            {
               _loc1_ = _loc2_;
            }
            this._items[_loc2_].selected = false;
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function updateItemValue(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._showLength)
         {
            this._items[_loc2_].setCellValue(this._dataList[this._currentSelectedIndex - this.getHightLightItemIdx() + _loc2_]);
            _loc2_++;
         }
      }
      
      private function setHightLightItem(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(this._dataList.length > 0)
         {
            _loc2_ = this.getHightLightItemIdx();
            if(!param1)
            {
               if(_loc2_ < this._showLength - 1)
               {
                  this.unSelectedAllItems();
                  _loc2_++;
               }
               else if(_loc2_ >= this._showLength - 1)
               {
                  this.updateItemValue();
               }
            }
            if(param1)
            {
               if(_loc2_ > 0)
               {
                  this.unSelectedAllItems();
                  _loc2_--;
               }
               else if(_loc2_ == 0)
               {
                  this.updateItemValue(true);
               }
            }
            this._items[_loc2_].selected = true;
         }
         else
         {
            this._currentSelectedIndex = 0;
         }
         this.setTargetValue();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._backGround)
         {
            addChild(this._backGround);
         }
         if(this._container)
         {
            addChild(this._container);
         }
      }
      
      public function set targetDisplay(param1:IDropListTarget) : void
      {
         if(param1 == this._targetDisplay)
         {
            return;
         }
         this._targetDisplay = param1;
         this._targetDisplay.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._targetDisplay.addEventListener(Event.REMOVED_FROM_STAGE,this.__onRemoveFromStage);
      }
      
      private function __onRemoveFromStage(param1:Event) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set showLength(param1:int) : void
      {
         var _loc2_:* = undefined;
         if(this._showLength == param1)
         {
            return;
         }
         this._showLength = param1;
         while(this._container.numChildren > this._showLength)
         {
            this._container.removeChild(this._items.pop());
         }
         while(this._container.numChildren < this._showLength)
         {
            if(this._items.length > this._container.numChildren)
            {
               this._container.addChild(this._items[this._container.numChildren].asDisplayObject());
            }
            else
            {
               _loc2_ = ComponentFactory.Instance.creat(this._cellStyle);
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.__onCellMouseOver);
               _loc2_.addEventListener(MouseEvent.CLICK,this.__onCellMouseClick);
               this._items.push(_loc2_);
               this._container.addChild(_loc2_);
            }
         }
         this._cellHeight = _loc2_.height;
         this._cellWidth = _loc2_.width;
         this.updateBg();
      }
      
      private function __onCellMouseClick(param1:MouseEvent) : void
      {
         ComponentSetting.PLAY_SOUND_FUNC("008");
         this.setTargetValue();
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(SELECTED));
      }
      
      private function __onCellMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = this.unSelectedAllItems();
         var _loc3_:int = this._items.indexOf(param1.currentTarget);
         this._currentSelectedIndex += _loc3_ - _loc2_;
         param1.currentTarget.selected = true;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_backgound] || _changedPropeties[P_container])
         {
            this.addChildren();
         }
      }
      
      private function __onKeyDown(param1:KeyboardEvent) : void
      {
         if(this._dataList == null)
         {
            return;
         }
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(!this._isListening && param1.keyCode == Keyboard.ENTER)
         {
            this._isListening = true;
            StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__setSelection);
         }
         switch(param1.keyCode)
         {
            case Keyboard.UP:
               ComponentSetting.PLAY_SOUND_FUNC("008");
               if(this._currentSelectedIndex == 0)
               {
                  return;
               }
               --this._currentSelectedIndex;
               this.setHightLightItem(true);
               break;
            case Keyboard.DOWN:
               ComponentSetting.PLAY_SOUND_FUNC("008");
               if(this._currentSelectedIndex == this._dataList.length - 1)
               {
                  return;
               }
               ++this._currentSelectedIndex;
               this.setHightLightItem();
               break;
            case Keyboard.ENTER:
               if(this._canUseEnter == false)
               {
                  return;
               }
               ComponentSetting.PLAY_SOUND_FUNC("008");
               if(parent)
               {
                  parent.removeChild(this);
               }
               this._targetDisplay.setValue(this._dataList[this._currentSelectedIndex]);
               dispatchEvent(new Event(SELECTED));
               break;
         }
      }
      
      public function set canUseEnter(param1:Boolean) : void
      {
         this._canUseEnter = param1;
      }
      
      public function get canUseEnter() : Boolean
      {
         return this._canUseEnter;
      }
      
      public function set currentSelectedIndex(param1:int) : void
      {
         if(this._dataList == null)
         {
            return;
         }
         ComponentSetting.PLAY_SOUND_FUNC("008");
         if(this._currentSelectedIndex == this._dataList.length - 1 || this._currentSelectedIndex == 0)
         {
            return;
         }
         this._currentSelectedIndex += param1;
         this.setHightLightItem();
      }
      
      private function setTargetValue() : void
      {
         if(!this._targetDisplay.parent)
         {
            this._targetDisplay.parent.addChild(this);
         }
         if(this._dataList)
         {
            this._targetDisplay.setValue(this._dataList[this._currentSelectedIndex]);
         }
      }
      
      private function __setSelection(param1:Event) : void
      {
         if(this._targetDisplay.caretIndex == this._targetDisplay.getValueLength())
         {
            this._isListening = false;
            StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__setSelection);
         }
         else
         {
            this._targetDisplay.setCursor(this._targetDisplay.getValueLength());
         }
      }
      
      public function set backStyle(param1:String) : void
      {
         if(this._backStyle == param1)
         {
            return;
         }
         this._backStyle = param1;
         this.backgound = ComponentFactory.Instance.creat(this._backStyle);
      }
      
      public function set backgound(param1:DisplayObject) : void
      {
         if(this._backGround == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._backGround);
         this._backGround = param1;
         if(this._backGround is InteractiveObject)
         {
            InteractiveObject(this._backGround).mouseEnabled = true;
         }
         onPropertiesChanged(P_backgound);
      }
      
      override public function dispose() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__setSelection);
         this._targetDisplay.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         if(this._backGround)
         {
            ObjectUtils.disposeObject(this._backGround);
         }
         this._backGround = null;
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(this._targetDisplay)
         {
            ObjectUtils.disposeObject(this._targetDisplay);
         }
         this._targetDisplay = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            if(this._items[_loc1_])
            {
               ObjectUtils.disposeObject(this._items[_loc1_]);
            }
            this._items[_loc1_] = null;
            _loc1_++;
         }
         this._dataList = null;
         super.dispose();
      }
   }
}
