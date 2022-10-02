package noviceactivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NoviceActivityLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _titleBitmap:Bitmap;
      
      private var _content:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _items:Array;
      
      private var _selectedItem:NoviceActivityLeftTitleItem;
      
      public function NoviceActivityLeftView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.novice.leftview.bg");
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.novice.frame.titlebitmap");
         addChild(this._bg);
         addChild(this._titleBitmap);
         this._content = ComponentFactory.Instance.creatComponentByStylename("noviceactiviy.leftview.itemlist");
         this._vbox = new VBox();
         this._vbox.spacing = 6;
         this._content.setView(this._vbox);
         this._content.vScrollProxy = ScrollPanel.ON;
         this._content.hScrollProxy = ScrollPanel.OFF;
         this._content.vScrollbar;
         addChild(this._content);
         this.addItem();
         if(this._items && this._items[0])
         {
            this._items[0].selected = true;
            this._selectedItem = this._items[0];
         }
      }
      
      private function addItem() : void
      {
         var _loc3_:NoviceActivityLeftTitleItem = null;
         this._items = [];
         var _loc1_:Array = NoviceActivityManager.instance.list;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new NoviceActivityLeftTitleItem();
            _loc3_.setInfo(_loc2_ + 1,_loc1_[_loc2_].activityType);
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemHandler);
            this._items.push(_loc3_);
            this._vbox.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function __itemHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:NoviceActivityLeftTitleItem = param1.currentTarget as NoviceActivityLeftTitleItem;
         this.setSelectItem(_loc2_);
         NoviceActivityManager.instance.changeRightView(_loc2_.index);
      }
      
      private function setSelectItem(param1:NoviceActivityLeftTitleItem) : void
      {
         if(param1 != this._selectedItem)
         {
            if(this._selectedItem)
            {
               this._selectedItem.selected = false;
            }
            this._selectedItem = param1;
            this._selectedItem.selected = true;
         }
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._titleBitmap)
         {
            ObjectUtils.disposeObject(this._titleBitmap);
         }
         this._titleBitmap = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
