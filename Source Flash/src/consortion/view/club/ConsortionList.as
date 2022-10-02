package consortion.view.club
{
   import com.pickgliss.ui.controls.container.VBox;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaApplyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaInfo;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class ConsortionList extends VBox
   {
       
      
      private var _currentItem:ConsortionListItem;
      
      private var items:Vector.<ConsortionListItem>;
      
      private var _selfApplyList:Vector.<ConsortiaApplyInfo>;
      
      public function ConsortionList()
      {
         super();
         this.__applyListChange(null);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__applyListChange);
      }
      
      private function __applyListChange(param1:ConsortionEvent) : void
      {
         this._selfApplyList = ConsortionModelControl.Instance.model.myApplyList;
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         super.init();
         this.items = new Vector.<ConsortionListItem>(6);
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            this.items[_loc1_] = new ConsortionListItem();
            this.items[_loc1_].buttonMode = true;
            addChild(this.items[_loc1_]);
            this.items[_loc1_].addEventListener(MouseEvent.CLICK,this.__clickHandler);
            this.items[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this.items[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            _loc1_++;
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            if(this.items[_loc2_] == param1.currentTarget as ConsortionListItem)
            {
               this.items[_loc2_].selected = true;
               this._currentItem = this.items[_loc2_];
            }
            else
            {
               this.items[_loc2_].selected = false;
            }
            _loc2_++;
         }
         dispatchEvent(new ConsortionEvent(ConsortionEvent.CLUB_ITEM_SELECTED));
      }
      
      public function get currentItem() : ConsortionListItem
      {
         return this._currentItem;
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as ConsortionListItem).light = true;
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as ConsortionListItem).light = false;
      }
      
      public function setListData(param1:Vector.<ConsortiaInfo>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc2_ = param1.length;
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               if(_loc3_ < _loc2_)
               {
                  this.items[_loc3_].info = param1[_loc3_];
                  this.items[_loc3_].visible = true;
                  this.items[_loc3_].isApply = false;
               }
               else
               {
                  this.items[_loc3_].visible = false;
               }
               _loc3_++;
            }
            this.setStatus();
            if(this._currentItem)
            {
               this._currentItem.selected = false;
            }
         }
      }
      
      private function setStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._selfApplyList != null)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               _loc2_ = this._selfApplyList.length;
               if(this.items[_loc1_].visible)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc2_)
                  {
                     if(this.items[_loc1_].info.ConsortiaID == this._selfApplyList[_loc3_].ConsortiaID)
                     {
                        this.items[_loc1_].isApply = true;
                     }
                     _loc3_++;
                  }
               }
               _loc1_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__applyListChange);
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this.items[_loc1_].dispose();
            this.items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            this.items[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this.items[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            this.items[_loc1_] = null;
            _loc1_++;
         }
         this._currentItem = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
