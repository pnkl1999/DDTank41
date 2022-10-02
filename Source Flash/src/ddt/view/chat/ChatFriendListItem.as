package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ChatFriendListItem extends Sprite implements IListCell, Disposeable
   {
      
      public static const SELECT:String = "select";
       
      
      private var _bg:Bitmap;
      
      private var _contentTxt:TextField;
      
      private var _fun:Function;
      
      private var _info:BasePlayer;
      
      private var _spaceLine:Bitmap;
      
      public function ChatFriendListItem()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._spaceLine);
         this._spaceLine = null;
         if(this._contentTxt && this._contentTxt.parent)
         {
            this._contentTxt.parent.removeChild(this._contentTxt);
            this._contentTxt = null;
         }
         this._info = null;
         this._fun = null;
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function get info() : BasePlayer
      {
         return this._info;
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         if(this._fun != null)
         {
            SoundManager.instance.play("008");
            this._fun(this._info.NickName,this._info.ID);
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         this._bg.alpha = 0;
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         this._bg.alpha = 1;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.chat.FriendListItemBg");
         this._spaceLine = ComponentFactory.Instance.creat("asset.chat.FriendListItemSpaceLine");
         this._contentTxt = new TextField();
         this._contentTxt.defaultTextFormat = new TextFormat("Verdana",12,15787731);
         this._contentTxt.filters = [new GlowFilter(0,1,2,2,10)];
         this._contentTxt.height = this._bg.height;
         this._contentTxt.width = this._bg.width;
         PositionUtils.setPos(this._contentTxt,"chat.FriendListContentTxtPos");
         this._contentTxt.mouseEnabled = false;
         addChild(this._bg);
         addChild(this._spaceLine);
         addChild(this._contentTxt);
         this._bg.alpha = 0;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function updateItem() : void
      {
         this._contentTxt.text = this._info.NickName;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1;
         this.updateItem();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
