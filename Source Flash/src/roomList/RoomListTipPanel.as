package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class RoomListTipPanel extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _list:VBox;
      
      private var _itemArray:Array;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      public function RoomListTipPanel(param1:int, param2:int)
      {
         this._cellWidth = param1;
         this._cellheight = param2;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("roomList.RoomList.tipItemBg");
         this._bg.width = this._cellWidth;
         this._bg.height = 0;
         addChild(this._bg);
         this._list = new VBox();
         addChild(this._list);
         this._itemArray = [];
      }
      
      public function addItem(param1:Bitmap, param2:int) : void
      {
         var _loc3_:TipItemView = new TipItemView(param1,param2,this._cellWidth,this._cellheight);
         _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick);
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         this._list.addChild(_loc3_);
         this._itemArray.push(_loc3_);
         this._bg.height += this._cellheight + 0.5;
      }
      
      private function __itemOut(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.target as Sprite;
         _loc2_.graphics.clear();
      }
      
      private function __itemOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.target as Sprite;
         _loc2_.graphics.beginFill(16777215,0.7);
         _loc2_.graphics.drawRect(0,0,this._cellWidth,this._cellheight);
         _loc2_.graphics.endFill();
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         var _loc2_:int = (param1.target as TipItemView).value;
         if(StateManager.currentStateType == StateType.ROOM_LIST)
         {
            SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,_loc2_);
         }
         else
         {
            SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.DUNGEON_LIST,_loc2_);
         }
         this.visible = false;
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            (this._itemArray[_loc1_] as TipItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[_loc1_] as TipItemView).removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
            (this._itemArray[_loc1_] as TipItemView).removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
            (this._itemArray[_loc1_] as TipItemView).dispose();
            _loc1_++;
         }
         this._itemArray = [];
      }
      
      public function dispose() : void
      {
         this.cleanItem();
         if(this._list && this._list.parent)
         {
            this._list.parent.removeChild(this._list);
            this._list.dispose();
            this._list = null;
         }
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.dispose();
            this._bg = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
