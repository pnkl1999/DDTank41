package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.list.IListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionUnitView extends Sprite implements Disposeable
   {
      
      public static const SELECTED_CHANGE:String = "avatarCollectionUnitView_selected_change";
       
      
      private var _index:int;
      
      private var _rightView:AvatarCollectionRightView;
      
      private var _selectedBtn:SelectedButton;
      
      private var _bg:Bitmap;
      
      private var _list:ListPanel;
      
      private var _dataList:Array;
      
      private var _selectedValue:AvatarCollectionUnitVo;
      
      private var _isFilter:Boolean = false;
      
      private var _isBuyFilter:Boolean = false;
      
      public function AvatarCollectionUnitView(param1:int, param2:AvatarCollectionRightView)
      {
         super();
         this._index = param1;
         this._rightView = param2;
         this.initView();
         this.initEvent();
         this.initData();
         this.initStatus();
      }
      
      public function set isBuyFilter(param1:Boolean) : void
      {
         this._isBuyFilter = param1;
         if(this._isBuyFilter)
         {
            this._isFilter = false;
         }
         this.refreshList();
      }
      
      public function set isFilter(param1:Boolean) : void
      {
         this._isFilter = param1;
         if(this._isFilter)
         {
            this._isBuyFilter = false;
         }
         this.refreshList();
      }
      
      private function initStatus() : void
      {
         if(this._index == 1)
         {
            this.extendSelecteTheFirst();
         }
      }
      
      private function initView() : void
      {
         this._selectedBtn = this.getSelectedBtn();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarColl.selectUnitBg");
         this._bg.visible = false;
         this._list = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unitCellList");
         this._list.visible = false;
         addChild(this._selectedBtn);
         addChild(this._bg);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         AvatarCollectionManager.instance.addEventListener(AvatarCollectionManager.REFRESH_VIEW,this.toDoRefresh);
      }
      
      private function initData() : void
      {
         this._dataList = this.getDataList();
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._dataList);
         this._list.list.updateListView();
      }
      
      private function toDoRefresh(param1:Event) : void
      {
         this.refreshList();
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedValue = param1.cellValue as AvatarCollectionUnitVo;
         if(this._rightView)
         {
            this._rightView.refreshView(this._selectedValue);
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.extendSelecteTheFirst();
         dispatchEvent(new Event(SELECTED_CHANGE));
      }
      
      private function extendSelecteTheFirst() : void
      {
         this.extendHandler();
         this.autoSelect();
      }
      
      private function extendHandler() : void
      {
         this._bg.visible = true;
         this._list.visible = true;
         this._selectedBtn.enable = false;
      }
      
      private function autoSelect() : void
      {
         var _loc3_:int = 0;
         var _loc4_:IntPoint = null;
         var _loc1_:IListModel = this._list.list.model;
         var _loc2_:int = _loc1_.getSize();
         if(_loc2_ > 0)
         {
            if(!this._selectedValue)
            {
               this._selectedValue = _loc1_.getElementAt(0) as AvatarCollectionUnitVo;
            }
            _loc3_ = _loc1_.indexOf(this._selectedValue);
            _loc4_ = new IntPoint(0,_loc1_.getCellPosFromIndex(_loc3_));
            this._list.list.viewPosition = _loc4_;
            this._list.list.currentSelectedIndex = _loc3_;
         }
         else
         {
            this._selectedValue = null;
         }
         this._rightView.refreshView(this._selectedValue);
      }
      
      public function unextendHandler() : void
      {
         this._selectedBtn.selected = false;
         this._selectedBtn.enable = true;
         this._bg.visible = false;
         this._list.visible = false;
      }
      
      private function refreshList() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = [];
         if(this._isFilter)
         {
            _loc2_ = this._dataList.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if((this._dataList[_loc3_] as AvatarCollectionUnitVo).canActivityCount > 0)
               {
                  _loc1_.push(this._dataList[_loc3_]);
               }
               _loc3_++;
            }
         }
         else if(this._isBuyFilter)
         {
            _loc4_ = this._dataList.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if((this._dataList[_loc5_] as AvatarCollectionUnitVo).canBuyCount > 0)
               {
                  _loc1_.push(this._dataList[_loc5_]);
               }
               _loc5_++;
            }
         }
         else
         {
            _loc1_ = this._dataList;
         }
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(_loc1_);
         this._list.list.updateListView();
         if(this._selectedValue && _loc1_.indexOf(this._selectedValue) == -1)
         {
            this._selectedValue = null;
         }
         if(this._list.visible)
         {
            this.autoSelect();
         }
      }
      
      private function getDataList() : Array
      {
         var _loc1_:Array = null;
         switch(this._index)
         {
            case 1:
               _loc1_ = AvatarCollectionManager.instance.maleUnitList;
               break;
            case 2:
               _loc1_ = AvatarCollectionManager.instance.femaleUnitList;
               break;
            default:
               _loc1_ = [];
         }
         return Boolean(_loc1_)?_loc1_:[];
      }
      
      private function getSelectedBtn() : SelectedButton
      {
         var _loc1_:SelectedButton = null;
         switch(this._index)
         {
            case 1:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("avatarColl.maleBtn");
               break;
            case 2:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("avatarColl.femaleBtn");
         }
         return _loc1_;
      }
      
      override public function get height() : Number
      {
         if(this._selectedBtn && this._bg)
         {
            if(this._bg.visible)
            {
               return this._bg.y + this._bg.height;
            }
            return this._selectedBtn.height;
         }
         return super.height;
      }
      
      private function removeEvent() : void
      {
         this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         AvatarCollectionManager.instance.removeEventListener(AvatarCollectionManager.REFRESH_VIEW,this.toDoRefresh);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._rightView = null;
         this._selectedBtn = null;
         this._bg = null;
         this._list = null;
         this._dataList = null;
         this._selectedValue = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
