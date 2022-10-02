package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import im.info.CustomInfo;
   
   public class FriendGroupTItem extends Sprite implements Disposeable
   {
       
      
      private var _text:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _info:CustomInfo;
      
      private var _nickName:String;
      
      public function FriendGroupTItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.FriendGroupTItem.bg");
         this._text = ComponentFactory.Instance.creatComponentByStylename("GroupTItem.text");
         addChild(this._bg);
         addChild(this._text);
         this._bg.visible = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      public function set info(param1:CustomInfo) : void
      {
         this._info = param1;
         this._text.text = this._info.Name;
      }
      
      public function set NickName(param1:String) : void
      {
         this._nickName = param1;
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         this._bg.visible = true;
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         this._bg.visible = false;
      }
      
      protected function __clickHandler(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.sendAddFriend(this._nickName,this._info.ID);
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._text)
         {
            ObjectUtils.disposeObject(this._text);
         }
         this._text = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
