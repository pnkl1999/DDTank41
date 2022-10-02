package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class SearchMemberFrame extends BaseAlerFrame implements Disposeable
   {
      
      public static const SEARCH:String = "search";
       
      
      private var _searchBtn:SimpleBitmapButton;
      
      private var _inputText:FilterFrameText;
      
      private var _inputBg:Scale9CornerImage;
      
      public function SearchMemberFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame");
         _loc1_.showCancel = false;
         _loc1_.moveEnable = false;
         info = _loc1_;
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("SearchMemberFrame.memberList.searchBtn");
         this._inputBg = ComponentFactory.Instance.creatComponentByStylename("SearchMemberFrame.memberList.TextInputBg");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("SearchMemberFrame.textInput");
         this._inputText.text = LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default");
         addToContent(this._inputBg);
         addToContent(this._searchBtn);
         addToContent(this._inputText);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__onSearchBtnClick);
         this._inputText.addEventListener(MouseEvent.CLICK,this.__onInputTextClick);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextChange);
      }
      
      private function removeEvent() : void
      {
         if(this._searchBtn)
         {
            this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__onSearchBtnClick);
         }
         if(this._inputText)
         {
            this._inputText.removeEventListener(MouseEvent.CLICK,this.__onInputTextClick);
         }
         if(this._inputText)
         {
            this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextChange);
         }
      }
      
      private function __onSearchBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
      }
      
      private function __onTextChange(param1:KeyboardEvent) : void
      {
         if(this._inputText.text == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"))
         {
            this._inputText.text = "";
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
         }
      }
      
      private function __onInputTextClick(param1:MouseEvent) : void
      {
         if(this._inputText.text == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"))
         {
            this._inputText.setSelection(0,this._inputText.text.length);
         }
      }
      
      public function getSearchText() : String
      {
         return this._inputText.text;
      }
      
      public function setFocus() : void
      {
         this._inputText.setFocus();
         this._inputText.setSelection(this._inputText.text.length,this._inputText.text.length);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._inputBg);
         this._inputBg = null;
         ObjectUtils.disposeObject(this._searchBtn);
         this._searchBtn = null;
         ObjectUtils.disposeObject(this._inputText);
         this._inputText = null;
         super.dispose();
      }
   }
}
