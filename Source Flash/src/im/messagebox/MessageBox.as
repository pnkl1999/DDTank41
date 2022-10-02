package im.messagebox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import im.info.PresentRecordInfo;
   
   public class MessageBox extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _sign:Bitmap;
      
      private var _title:FilterFrameText;
      
      private var _cancelFlash:SimpleBitmapButton;
      
      private var _vbox:VBox;
      
      private var _item:Vector.<MessageBoxItem>;
      
      public var overState:Boolean;
      
      public function MessageBox()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("messageBox.bg");
         this._sign = ComponentFactory.Instance.creatBitmap("asset.messagebox.sign");
         this._title = ComponentFactory.Instance.creatComponentByStylename("messageBox.title");
         this._cancelFlash = ComponentFactory.Instance.creatComponentByStylename("messageBox.cancelFlash");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("messagebox.vbox");
         addChild(this._bg);
         addChild(this._sign);
         addChild(this._title);
         addChild(this._cancelFlash);
         addChild(this._vbox);
         this._item = new Vector.<MessageBoxItem>();
         this._title.text = LanguageMgr.GetTranslation("IM.messagebox.title");
         this._cancelFlash.addEventListener(MouseEvent.CLICK,this.__cancelFlashHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         this.overState = false;
         IMController.Instance.hideMessageBox();
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         this.overState = true;
      }
      
      protected function __cancelFlashHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.cancelFlash();
      }
      
      public function set message(param1:Vector.<PresentRecordInfo>) : void
      {
         var _loc3_:MessageBoxItem = null;
         this.clearBox();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new MessageBoxItem();
            _loc3_.recordInfo = param1[_loc2_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            _loc3_.addEventListener(MessageBoxItem.DELETE,this.__itemDeleteHandler);
            this._vbox.addChild(_loc3_);
            this._item.push(_loc3_);
            _loc2_++;
         }
         this._bg.height = this._item.length * 28 + 88;
      }
      
      private function clearBox() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._item.length)
         {
            if(this._item[_loc1_])
            {
               this._item[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
               this._item[_loc1_].removeEventListener(MessageBoxItem.DELETE,this.__itemDeleteHandler);
               ObjectUtils.disposeObject(this._item[_loc1_]);
            }
            this._item[_loc1_] = null;
            _loc1_++;
         }
         this._item = new Vector.<MessageBoxItem>();
      }
      
      protected function __itemDeleteHandler(param1:Event) : void
      {
         var _loc2_:MessageBoxItem = param1.currentTarget as MessageBoxItem;
         this._item.splice(this._item.indexOf(_loc2_),1);
         if(_loc2_)
         {
            _loc2_.removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            _loc2_.removeEventListener(MessageBoxItem.DELETE,this.__itemDeleteHandler);
            ObjectUtils.disposeObject(_loc2_);
         }
         _loc2_ = null;
         IMController.Instance.getMessage();
      }
      
      protected function __itemClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:MessageBoxItem = param1.currentTarget as MessageBoxItem;
         IMController.Instance.alertPrivateFrame(_loc2_.recordInfo.id);
         IMController.Instance.getMessage();
      }
      
      public function dispose() : void
      {
         this._cancelFlash.removeEventListener(MouseEvent.CLICK,this.__cancelFlashHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this.clearBox();
         this._item = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._sign)
         {
            ObjectUtils.disposeObject(this._sign);
         }
         this._sign = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._cancelFlash)
         {
            ObjectUtils.disposeObject(this._cancelFlash);
         }
         this._cancelFlash = null;
         if(this._vbox)
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
