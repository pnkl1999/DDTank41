package consortion.view.club
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class ClubRecordList extends Sprite implements Disposeable
   {
      
      public static const INVITE:int = 1;
      
      public static const APPLY:int = 2;
       
      
      private var _items:Vector.<ClubRecordItem>;
      
      private var _panel:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _data:*;
      
      public function ClubRecordList()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("club.recordList.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("club.recordList.panel");
         this._panel.setView(this._vbox);
         addChild(this._panel);
      }
      
      public function setData(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ClubRecordItem = null;
         if(this._data == param1)
         {
            return;
         }
         this.clearItem();
         this._items = new Vector.<ClubRecordItem>();
         if(param1 && param1.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = new ClubRecordItem(param2);
               _loc4_.info = param1[_loc3_];
               this._items.push(_loc4_);
               this._vbox.addChild(_loc4_);
               _loc3_++;
            }
         }
         this._panel.invalidateViewport();
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._items && this._items.length > 0)
         {
            _loc1_ = this._items.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._items[_loc2_].dispose();
               this._items[_loc2_] = null;
               _loc2_++;
            }
         }
         this._items = null;
      }
      
      public function dispose() : void
      {
         this.clearItem();
         ObjectUtils.disposeAllChildren(this);
         this._vbox = null;
         this._panel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
