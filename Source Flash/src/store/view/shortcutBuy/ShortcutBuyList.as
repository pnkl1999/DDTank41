package store.view.shortcutBuy
{
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShortcutBuyList extends Sprite implements Disposeable
   {
       
      
      private var _list:SimpleTileList;
      
      private var _cells:Vector.<ShortcutBuyCell>;
      
      private var _cow:int;
      
      public function ShortcutBuyList()
      {
         super();
      }
      
      public function setup(param1:Array) : void
      {
         this._cow = Math.ceil(param1.length / 4);
         this.init();
         this.createCells(param1);
      }
      
      private function init() : void
      {
         this._cells = new Vector.<ShortcutBuyCell>();
         this._list = new SimpleTileList(4);
         this._list.hSpace = 30;
         this._list.vSpace = 40;
         addChild(this._list);
      }
      
      override public function get height() : Number
      {
         return this._list.height;
      }
      
      private function createCells(param1:Array) : void
      {
         var _loc4_:ShortcutBuyCell = null;
         var _loc3_:ItemTemplateInfo = null;
         _loc4_ = null;
         this._list.beginChanges();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = ItemManager.Instance.getTemplateById(param1[_loc2_]);
            _loc4_ = new ShortcutBuyCell(_loc3_);
            _loc4_.info = _loc3_;
            _loc4_.addEventListener(MouseEvent.CLICK,this.cellClickHandler);
            _loc4_.buttonMode = true;
            _loc4_.showBg();
            this._list.addChild(_loc4_);
            this._cells.push(_loc4_);
            _loc2_++;
         }
         this._list.commitChanges();
      }
      
      public function shine() : void
      {
         var _loc1_:ShortcutBuyCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.hideBg();
            _loc1_.startShine();
         }
      }
      
      public function noShine() : void
      {
         var _loc1_:ShortcutBuyCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.stopShine();
            _loc1_.showBg();
         }
      }
      
      private function cellClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ShortcutBuyCell = null;
         SoundManager.instance.play("008");
         for each(_loc2_ in this._cells)
         {
            _loc2_.selected = false;
            this.noShine();
         }
         ShortcutBuyCell(param1.currentTarget).selected = true;
         dispatchEvent(new Event(Event.SELECT));
      }
      
      public function get selectedItemID() : int
      {
         var _loc1_:ShortcutBuyCell = null;
         for each(_loc1_ in this._cells)
         {
            if(_loc1_.selected)
            {
               return _loc1_.info.TemplateID;
            }
         }
         return -1;
      }
      
      public function set selectedItemID(param1:int) : void
      {
         var _loc2_:ShortcutBuyCell = null;
         for each(_loc2_ in this._cells)
         {
            if(_loc2_.info.TemplateID == param1)
            {
               _loc2_.selected = true;
               return;
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:ShortcutBuyCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.cellClickHandler);
            ObjectUtils.disposeObject(_loc1_);
         }
         this._cells = null;
         this._list.disposeAllChildren();
         this._list = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
