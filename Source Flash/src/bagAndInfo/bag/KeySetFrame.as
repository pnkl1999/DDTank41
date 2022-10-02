package bagAndInfo.bag
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class KeySetFrame extends BaseAlerFrame
   {
       
      
      private var _list:HBox;
      
      private var _defaultSetPalel:KeyDefaultSetPanel;
      
      private var _currentSet:KeySetItem;
      
      private var _tempSets:Dictionary;
      
      private var numberAccect:Bitmap;
      
      private var autocheck:SelectedCheckButton;
      
      private var _submit:TextButton;
      
      private var _cancel:TextButton;
      
      private var _imageRectString:String;
      
      private var _visible:Boolean = false;
      
      private var _prevFocus:InteractiveObject;
      
      public function KeySetFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("tank.view.bagII.KeySetFrame.titleText");
         this.initContent();
         this.escEnable = true;
      }
      
      private function initContent() : void
      {
         var _loc1_:* = null;
         this.numberAccect = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.keySetNumAsset");
         this._list = ComponentFactory.Instance.creatComponentByStylename("keySetHBox");
         this._tempSets = new Dictionary();
         for(_loc1_ in SharedManager.Instance.GameKeySets)
         {
            this._tempSets[_loc1_] = SharedManager.Instance.GameKeySets[_loc1_];
         }
         this._submit = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.KeySet.SubmitButton");
         this._submit.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._submit);
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.KeySet.CancelButton");
         this._cancel.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._cancel);
         this.creatCell();
         addToContent(this._list);
         addToContent(this.numberAccect);
         this._defaultSetPalel = new KeyDefaultSetPanel();
         this._defaultSetPalel.visible = false;
         this._defaultSetPalel.addEventListener(Event.SELECT,this.onItemSelected);
         this._defaultSetPalel.addEventListener(Event.REMOVED_FROM_STAGE,this.__ondefaultSetRemove);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(this._imageRectString != null)
         {
            MutipleImage(_backgound).imageRectString = this._imageRectString;
         }
      }
      
      private function addEvent() : void
      {
         this._submit.addEventListener(MouseEvent.CLICK,this.__onSubmit);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__onCancel);
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
      }
      
      private function removeEvent() : void
      {
         this._submit.removeEventListener(MouseEvent.CLICK,this.__onSubmit);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__onCancel);
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onSubmit(param1:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
      }
      
      private function __onCancel(param1:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.ESC_CLICK));
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.cancelClick();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.okClick();
         }
      }
      
      private function hide() : void
      {
         this.close();
      }
      
      private function okClick() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._tempSets)
         {
            SharedManager.Instance.GameKeySets[_loc1_] = this._tempSets[_loc1_];
         }
         SharedManager.Instance.save();
         this.close();
      }
      
      private function onItemClick(param1:ItemEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         this._currentSet = param1.currentTarget as KeySetItem;
         if(this._defaultSetPalel.parent)
         {
            removeChild(this._defaultSetPalel);
         }
         this._defaultSetPalel.visible = true;
         this._currentSet.glow = true;
         this._defaultSetPalel.x = param1.currentTarget.x + 2;
         this._defaultSetPalel.y = this._list.y - this._defaultSetPalel.height;
         addChild(this._defaultSetPalel);
      }
      
      private function cancelClick() : void
      {
         var _loc1_:* = null;
         this.close();
         this._tempSets = new Dictionary();
         for(_loc1_ in SharedManager.Instance.GameKeySets)
         {
            this._tempSets[_loc1_] = SharedManager.Instance.GameKeySets[_loc1_];
         }
         this.creatCell();
      }
      
      private function __ondefaultSetRemove(param1:Event) : void
      {
         if(this._currentSet)
         {
            this._currentSet.glow = false;
         }
      }
      
      private function creatCell() : void
      {
         var _loc1_:* = null;
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:KeySetItem = null;
         this.clearItemList();
         for(_loc1_ in this._tempSets)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(this._tempSets[_loc1_]);
            if(_loc1_ == "9")
            {
               return;
            }
            if(_loc2_)
            {
               _loc3_ = new KeySetItem(int(_loc1_),int(_loc1_),this._tempSets[_loc1_],PropItemView.createView(_loc2_.Pic,40,40));
               _loc3_.addEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               _loc3_.setClick(true,false,true);
               this._list.addChild(_loc3_);
            }
         }
      }
      
      public function show() : void
      {
         this.visible = true;
         this.addEvent();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         StageReferance.stage.focus = this;
      }
      
      private function clearItemList(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:KeySetItem = null;
         if(this._list)
         {
            _loc2_ = 0;
            while(_loc2_ < this._list.numChildren)
            {
               _loc3_ = KeySetItem(this._list.getChildAt(_loc2_));
               _loc3_.removeEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               _loc3_.dispose();
               _loc3_ = null;
               _loc2_++;
            }
            ObjectUtils.disposeAllChildren(this._list);
            if(param1)
            {
               if(this._list.parent)
               {
                  this._list.parent.removeChild(this._list);
               }
               this._list = null;
            }
         }
      }
      
      public function close() : void
      {
         this.visible = false;
         this._defaultSetPalel.hide();
         this.removeEvent();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function onItemSelected(param1:Event) : void
      {
         if(stage)
         {
            stage.focus = this;
         }
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._defaultSetPalel.selectedItemID);
         this._currentSet.setItem(PropItemView.createView(_loc2_.Pic,40,40),false);
         this._currentSet.propID = this._defaultSetPalel.selectedItemID;
         this._tempSets[this._currentSet.index] = this._defaultSetPalel.selectedItemID;
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.clearItemList(true);
         this._defaultSetPalel.removeEventListener(Event.SELECT,this.onItemSelected);
         this._defaultSetPalel.removeEventListener(Event.REMOVED_FROM_STAGE,this.__ondefaultSetRemove);
         this._defaultSetPalel.dispose();
         this._defaultSetPalel = null;
         if(this._currentSet)
         {
            this._currentSet.removeEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
            this._currentSet = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         super.dispose();
      }
      
      public function set imageRectString(param1:String) : void
      {
         this._imageRectString = param1;
         if(_backgound)
         {
            MutipleImage(_backgound).imageRectString = this._imageRectString;
         }
      }
      
      public function get imageRectString() : String
      {
         return this._imageRectString;
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
      }
      
      public function get prevFocus() : InteractiveObject
      {
         return this._prevFocus;
      }
      
      public function set prevFocus(param1:InteractiveObject) : void
      {
         this._prevFocus = param1;
      }
   }
}
