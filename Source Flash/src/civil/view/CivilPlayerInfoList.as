package civil.view
{
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CivilPlayerInfoList extends Sprite implements Disposeable
   {
      
      private static const MAXITEM:int = 12;
       
      
      private var _currentItem:CivilPlayerItemFrame;
      
      private var _items:Vector.<CivilPlayerItemFrame>;
      
      private var _infoItems:Array;
      
      private var _list:VBox;
      
      private var _model:CivilModel;
      
      private var _selectedItem:CivilPlayerItemFrame;
      
      public function CivilPlayerInfoList()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._infoItems = [];
         this._list = ComponentFactory.Instance.creatComponentByStylename("civil.memberList");
         addChild(this._list);
         this._items = new Vector.<CivilPlayerItemFrame>();
      }
      
      public function MemberList(param1:Array) : void
      {
         var _loc4_:CivilPlayerItemFrame = null;
         this.clearList();
         if(!param1 || param1.length == 0)
         {
            return;
         }
         var _loc2_:int = param1.length > MAXITEM ? int(int(MAXITEM)) : int(int(param1.length));
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new CivilPlayerItemFrame();
            _loc4_.info = param1[_loc3_];
            _loc4_.addEventListener(MouseEvent.CLICK,this.__onItemClick);
            this._list.addChild(_loc4_);
            this._items.push(_loc4_);
            if(_loc3_ == 0)
            {
               this.selectedItem = _loc4_;
            }
            _loc3_++;
         }
      }
      
      public function clearList() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__onItemClick);
            ObjectUtils.disposeObject(this._items[_loc1_]);
            this._items[_loc1_] = null;
            _loc1_++;
         }
         this._items = new Vector.<CivilPlayerItemFrame>();
         this._currentItem = null;
         this._infoItems = [];
      }
      
      public function upItem(param1:CivilPlayerInfo) : void
      {
         var _loc3_:CivilPlayerItemFrame = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            _loc3_ = this._items[_loc2_] as CivilPlayerItemFrame;
            if(_loc3_.info.info.ID == param1.info.ID)
            {
               _loc3_.info = param1;
               break;
            }
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         if(this._model)
         {
            if(this._model.hasEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE))
            {
               this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
         }
      }
      
      private function __civilListHandle(param1:CivilEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:CivilPlayerItemFrame = null;
         if(this._model.civilPlayers == null)
         {
            return;
         }
         this.clearList();
         var _loc2_:Array = this._model.civilPlayers;
         var _loc3_:int = _loc2_.length > MAXITEM ? int(int(MAXITEM)) : int(int(_loc2_.length));
         if(_loc3_ <= 0)
         {
            this.selectedItem = null;
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new CivilPlayerItemFrame();
               _loc5_.info = _loc2_[_loc4_];
               this._list.addChild(_loc5_);
               this._items.push(_loc5_);
               if(_loc4_ == 0)
               {
                  this.selectedItem = _loc5_;
               }
               _loc5_.addEventListener(MouseEvent.CLICK,this.__onItemClick);
               _loc4_++;
            }
         }
      }
      
      private function __onItemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CivilPlayerItemFrame = param1.currentTarget as CivilPlayerItemFrame;
         if(!_loc2_.selected)
         {
            this.selectedItem = _loc2_;
         }
      }
      
      public function get selectedItem() : CivilPlayerItemFrame
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:CivilPlayerItemFrame) : void
      {
         var _loc2_:CivilPlayerItemFrame = null;
         if(this._selectedItem != param1)
         {
            _loc2_ = this._selectedItem;
            this._selectedItem = param1;
            if(this._selectedItem)
            {
               this._selectedItem.selected = true;
               this._model.currentcivilItemInfo = this._selectedItem.info;
            }
            else
            {
               this._model.currentcivilItemInfo = null;
            }
            if(_loc2_)
            {
               _loc2_.selected = false;
            }
            dispatchEvent(new CivilEvent(CivilEvent.SELECTED_CHANGE,param1));
         }
      }
      
      public function get model() : CivilModel
      {
         return this._model;
      }
      
      public function set model(param1:CivilModel) : void
      {
         if(this._model != param1)
         {
            if(this._model)
            {
               this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
            this._model = param1;
            if(this._model)
            {
               this._model.addEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         if(this._list)
         {
            this._list.dispose();
            this._list = null;
         }
         if(this._currentItem)
         {
            this._currentItem.dispose();
         }
         this._currentItem = null;
         this.model = null;
         this._infoItems = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
