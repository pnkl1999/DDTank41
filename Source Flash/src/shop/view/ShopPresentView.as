package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatFriendListPanel;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.ShopController;
   
   public class ShopPresentView extends Sprite
   {
       
      
      private var _frame:BaseAlerFrame;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _comBtn:BaseButton;
      
      private var _controller:ShopController;
      
      private var _bg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _textArea:TextArea;
      
      public function ShopPresentView()
      {
         super();
      }
      
      public function setup(param1:ShopController) : void
      {
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._friendList = new ChatFriendListPanel();
         this._frame = ComponentFactory.Instance.creatComponentByStylename("shop.PresentViewFrame");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.shop.PresentBg");
         this._comBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PresentViewCombo");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PresentViewFriendName");
         this._textArea = ComponentFactory.Instance.creatComponentByStylename("shop.PresentViewTextArea");
         var _loc1_:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _loc1_.moveEnable = false;
         this._frame.info = _loc1_;
         PositionUtils.setPos(this._friendList,"shop.PresentViewFriendListPos");
         this._nameTxt.maxChars = 25;
         this._friendList.visible = false;
         this._friendList.setup(this.doSelected);
         this._textArea.maxChars = 300;
         this._frame.addToContent(this._bg);
         this._frame.addToContent(this._nameTxt);
         this._frame.addToContent(this._textArea);
         this._frame.addToContent(this._friendList);
         this._frame.addToContent(this._comBtn);
         this._comBtn.addEventListener(MouseEvent.CLICK,this.__comBtnClickHandler);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         addChild(this._frame);
      }
      
      private function __comBtnClickHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         this._friendList.visible = true;
         this._frame.addToContent(this._friendList);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         var _loc2_:String = null;
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               _loc2_ = FilterWordManager.filterWrod(this._textArea.text);
               if(this._nameTxt.text == "")
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
                  return;
               }
               if(FilterWordManager.IsNullorEmpty(this._nameTxt.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
                  return;
               }
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this._controller.presentItems(this._controller.model.allItems,_loc2_,this._nameTxt.text);
               this._controller.model.clearAllitems();
               break;
         }
         this.dispose();
      }
      
      private function doSelected(param1:String, param2:Number = 0) : void
      {
         this._nameTxt.text = param1;
         if(this._friendList.parent)
         {
            this._friendList.parent.removeChild(this._friendList);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this._comBtn.removeEventListener(MouseEvent.CLICK,this.__comBtnClickHandler);
         this._frame.dispose();
         this._frame = null;
         this._friendList = null;
         this._comBtn = null;
         this._bg = null;
         this._nameTxt = null;
         this._textArea = null;
      }
   }
}
