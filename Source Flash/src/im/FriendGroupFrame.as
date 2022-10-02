package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import im.info.CustomInfo;
   
   public class FriendGroupFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _confirm:SimpleBitmapButton;
      
      private var _combox:ComboBox;
      
      public var nickName:String;
      
      private var _customList:Vector.<CustomInfo>;
      
      public function FriendGroupFrame()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.friendGroup.bg");
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.confirm");
         this._combox = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.choose");
         addToContent(this._bg);
         addToContent(this._confirm);
         addToContent(this._combox);
         this._combox.beginChanges();
         this._combox.selctedPropName = "text";
         var _loc1_:VectorListModel = this._combox.listPanel.vectorListModel;
         _loc1_.clear();
         this._customList = PlayerManager.Instance.customList;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this._customList.length - 1)
         {
            _loc2_.push(this._customList[_loc3_].Name);
            _loc3_++;
         }
         _loc1_.appendAll(_loc2_);
         this._combox.listPanel.list.updateListView();
         this._combox.commitChanges();
         this._combox.textField.text = this._customList[0].Name;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._combox.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._combox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      protected function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __confirmHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = 0;
         while(_loc2_ < this._customList.length)
         {
            if(this._customList[_loc2_].Name == this._combox.textField.text)
            {
               SocketManager.Instance.out.sendAddFriend(this.nickName,this._customList[_loc2_].ID);
               break;
            }
            _loc2_++;
         }
         this.dispose();
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      protected function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._combox.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._combox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._customList = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._confirm)
         {
            ObjectUtils.disposeObject(this._confirm);
         }
         this._confirm = null;
         if(this._combox)
         {
            ObjectUtils.disposeObject(this._combox);
         }
         this._combox = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         IMController.Instance.clearGroupFrame();
      }
   }
}
